module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

type t = {
  owner : string;
  amount : float;
  description : string;
  callback : string option;
}

val t_of_yojson : Ppx_yojson_conv_lib.Yojson.Safe.t -> t
val yojson_of_t : t -> Ppx_yojson_conv_lib.Yojson.Safe.t

val create :
  t ->
  (module DB) ->
  (string * (string * (float * (string * (string option * (bool * string))))))
  Lwt.t

val find :
  string ->
  (module DB) ->
  (string * (string * (float * (string * (string option * (bool * string))))))
  option
  Lwt.t

val pay : string -> (module DB) -> unit Lwt.t
val unpay : string -> (module DB) -> unit Lwt.t
