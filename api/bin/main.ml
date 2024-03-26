module Payment = Models.Payment
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type payment_creation = {
  id : string;
  owner : string;
  amount : float;
  description : string;
  paid : bool;
  created_at : string;
}
[@@deriving yojson]

let cors_middleware handler req =
  let handlers =
    [
      ("Allow", "OPTIONS, GET, HEAD, POST");
      ("Access-Control-Allow-Origin", "*");
      ("Access-Control-Allow-Methods", "OPTIONS, GET, HEAD, POST");
      ("Access-Control-Allow-Headers", "Content-Type");
      ("Access-Control-Max-Age", "86400");
    ]
  in
  let%lwt res = handler req in
  handlers
  |> List.map (fun (key, value) -> Dream.add_header res key value)
  |> ignore;
  Lwt.return res

let is_logged req =
  match Dream.header req "X-API-TOKEN" with
  | Some x -> x = Sys.getenv "API_TOKEN"
  | None ->
    Dream.log "X-API-TOKEN not defined";
    false

let post_payments request =
  let is_logged = is_logged request in

  if not is_logged then
    Dream.json ~status:`Unauthorized ""
  else
    let%lwt body = Dream.body request in

    let payment_create_obj =
      body |> Yojson.Safe.from_string |> Payment.t_of_yojson
    in
    let%lwt payment = Dream.sql request (Payment.create payment_create_obj) in

    let response =
      (fun (id, (owner, (amount, (description, (paid, created_at))))) ->
        {id; owner; amount; description; paid; created_at})
        payment
    in

    yojson_of_payment_creation response
    |> Yojson.Safe.to_string
    |> Dream.json ~status:`Created

let get_payment request =
  let payment_id = Dream.param request "id" in

  let%lwt payment = Dream.sql request (Payment.find payment_id) in

  match payment with
  | Some payment ->
    let response =
      (fun (id, (owner, (amount, (description, (paid, created_at))))) ->
        {id; owner; amount; description; paid; created_at})
        payment
    in

    yojson_of_payment_creation response |> Yojson.Safe.to_string |> Dream.json
  | None -> Dream.json ~status:`Not_Found ""

let pay_payment request =
  let payment_id = Dream.param request "id" in

  let%lwt payment = Dream.sql request (Payment.find payment_id) in

  match payment with
  | Some _ ->
    let%lwt () = Dream.sql request (Payment.pay payment_id) in

    Dream.json ~status:`OK ""
  | None -> Dream.json ~status:`Not_Found ""

let () =
  let postgres_url =
    match Sys.getenv_opt "DATABASE_URL" with
    | Some url -> url
    | None -> "postgresql://dream:password@postgres/dream"
  in

  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ cors_middleware
  @@ Dream.sql_pool postgres_url
  @@ Dream.sql_sessions
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html "hello world");
         Dream.scope "/payments" []
           [
             Dream.post "/" post_payments;
             Dream.get "/:id/" get_payment;
             Dream.post "/:id/pay/" pay_payment;
           ];
       ]
