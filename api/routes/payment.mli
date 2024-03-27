module Payment = Models.Payment

type payment_creation = {
  id : string;
  owner : string;
  amount : float;
  description : string;
  callback : string option;
  paid : bool;
  created_at : string;
}

val payment_creation_of_yojson :
  Ppx_yojson_conv_lib.Yojson.Safe.t -> payment_creation

val yojson_of_payment_creation :
  payment_creation -> Ppx_yojson_conv_lib.Yojson.Safe.t

val is_logged : 'a Dream.message -> bool
val post : Dream.client Dream.message -> Dream.response Dream.promise
val get : Dream.request -> Dream.response Lwt.t
val pay : Dream.request -> Dream.response Lwt.t
