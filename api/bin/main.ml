module Payment = Models.Payment
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type payment_creation = {
  id : string;
  owner : string;
  amount : float;
  created_at : string;
}
[@@deriving yojson]

let post_payments request =
  let%lwt body = Dream.body request in

  let payment_create_obj =
    body |> Yojson.Safe.from_string |> Payment.t_of_yojson
  in
  let%lwt payment = Dream.sql request (Payment.create payment_create_obj) in

  let response =
    (fun (id, owner, amount, created_at) -> {id; owner; amount; created_at})
      payment
  in

  yojson_of_payment_creation response
  |> Yojson.Safe.to_string
  |> Dream.json ~status:`Created

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
         Dream.get "/" (fun _ -> Dream.html "hello world");
         Dream.post "/payments/" post_payments;
       ]
