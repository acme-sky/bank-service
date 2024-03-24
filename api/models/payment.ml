open Ppx_yojson_conv_lib.Yojson_conv.Primitives

module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

type t = {
  owner : string;
  amount : float;
  description : string;
}
[@@deriving yojson]

let create =
  let query =
    let open Caqti_request.Infix in
    (T.(tup3 string float string) ->! T.(tup4 string string float string))
      {|
      INSERT INTO payment (owner, amount, description) VALUES ($1, $2, $3)
      RETURNING id, owner, amount, created_at
      |}
  in
  fun (payment : t) (module Db : DB) ->
    let%lwt result =
      Db.find query (payment.owner, payment.amount, payment.description)
    in
    Caqti_lwt.or_fail result

let find =
  let query =
    let open Caqti_request.Infix in
    (T.string ->? T.(tup4 string string float string))
      {|
      SELECT id, owner, amount, created_at FROM payment WHERE id = $1
      |}
  in
  fun (id : string) (module Db : DB) ->
    let%lwt result = Db.find_opt query id in
    Caqti_lwt.or_fail result
