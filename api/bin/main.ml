open Ppx_yojson_conv_lib.Yojson_conv.Primitives

module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

type payment_create_request = {
  owner : string;
  amount : float;
  description : string;
}
[@@deriving yojson]

type payment_create_response = {
  id : string;
  owner : string;
  amount : float;
  created_at : string;
}
[@@deriving yojson]

let add_payment =
  let query =
    let open Caqti_request.Infix in
    (T.(tup3 string float string) ->! T.(tup4 string string float string))
      {|
      INSERT INTO payment (owner, amount, description) VALUES ($1, $2, $3)
      RETURNING id, owner, amount, created_at
      |}
  in
  fun (payment : payment_create_request) (module Db : DB) ->
    let%lwt result =
      Db.find query (payment.owner, payment.amount, payment.description)
    in
    Caqti_lwt.or_fail result

let () =
  let postgres_url =
    match Sys.getenv_opt "DATABASE_URL" with
    | Some url -> url
    | None -> "postgresql://dream:password@postgres/dream"
  in

  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Dream.sql_pool postgres_url
  @@ Dream.sql_sessions
  @@ Dream.router
       [
         Dream.get "/" (fun _ ->
             let x = Uuidm.v `V4 |> Uuidm.to_string in
             Dream.html x);
         Dream.post "/payments/" (fun request ->
             let%lwt body = Dream.body request in

             let payment_create_obj =
               body
               |> Yojson.Safe.from_string
               |> payment_create_request_of_yojson
             in
             let%lwt payment =
               Dream.sql request (add_payment payment_create_obj)
             in

             let response =
               (fun (id, owner, amount, created_at) ->
                 {id; owner; amount; created_at})
                 payment
             in

             yojson_of_payment_create_response response
             |> Yojson.Safe.to_string
             |> Dream.json);
       ]
