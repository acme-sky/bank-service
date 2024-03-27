module Payment = Models.Payment
open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Cohttp
open Lwt

type payment_creation = {
  id : string;
  owner : string;
  amount : float;
  description : string;
  callback : string option;
  paid : bool;
  created_at : string;
}
[@@deriving yojson]

let is_logged req =
  match Dream.header req "X-API-TOKEN" with
  | Some x -> x = Sys.getenv "API_TOKEN"
  | None ->
    Dream.log "X-API-TOKEN not defined";
    false

let post request =
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
      (fun (id, (owner, (amount, (description, (callback, (paid, created_at)))))) ->
        {id; owner; amount; description; callback; paid; created_at})
        payment
    in

    yojson_of_payment_creation response
    |> Yojson.Safe.to_string
    |> Dream.json ~status:`Created

let get request =
  let payment_id = Dream.param request "id" in

  let%lwt payment = Dream.sql request (Payment.find payment_id) in

  match payment with
  | Some payment ->
    let response =
      (fun (id, (owner, (amount, (description, (callback, (paid, created_at)))))) ->
        {id; owner; amount; description; callback; paid; created_at})
        payment
    in

    yojson_of_payment_creation response |> Yojson.Safe.to_string |> Dream.json
  | None -> Dream.json ~status:`Not_Found ""

let pay request =
  let payment_id = Dream.param request "id" in

  let%lwt payment = Dream.sql request (Payment.find payment_id) in

  match payment with
  | Some t -> (
    let payment =
      (fun (id, (owner, (amount, (description, (callback, (paid, created_at)))))) ->
        {id; owner; amount; description; callback; paid; created_at})
        t
    in
    let%lwt () = Dream.sql request (Payment.pay payment_id) in

    (* FIXME: On error a payment should be refund *)
    match payment.callback with
    | Some callback -> (
      try
        Cohttp_lwt_unix.Client.post (Uri.of_string callback)
        >>= fun (resp, _) ->
        match resp |> Response.status |> Code.code_of_status with
        | 200 -> Dream.json ~status:`OK ""
        | _ -> Dream.json ~status:`Bad_Request ""
      with _ -> Dream.json ~status:`Bad_Gateway "")
    | None -> Dream.json ~status:`OK "")
  | None -> Dream.json ~status:`Not_Found ""
