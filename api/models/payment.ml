open Ppx_yojson_conv_lib.Yojson_conv.Primitives

module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

type t = {
  owner : string;
  amount : float;
  description : string;
  callback : string option;
}
[@@deriving yojson]

let create =
  let query =
    let open Caqti_request.Infix in
    (T.(tup4 string float string (option string))
    ->! T.(
          tup2 string
            (tup2 string
               (tup2 float
                  (tup2 string (tup2 (option string) (tup2 bool string)))))))
      {|
      INSERT INTO payment (owner, amount, description, callback) VALUES ($1, $2, $3, $4)
      RETURNING id, owner, amount, description, callback, paid, created_at
      |}
  in
  fun (payment : t) (module Db : DB) ->
    let%lwt result =
      Db.find query
        (payment.owner, payment.amount, payment.description, payment.callback)
    in
    Caqti_lwt.or_fail result

let find =
  let query =
    let open Caqti_request.Infix in
    (T.string
    ->? T.(
          tup2 string
            (tup2 string
               (tup2 float
                  (tup2 string (tup2 (option string) (tup2 bool string)))))))
      {|
      SELECT id, owner, amount, description, callback, paid, created_at FROM payment WHERE id = $1
      |}
  in
  fun (id : string) (module Db : DB) ->
    let%lwt result = Db.find_opt query id in
    Caqti_lwt.or_fail result

let pay =
  let query =
    let open Caqti_request.Infix in
    (T.string ->. T.unit)
      {|
      UPDATE payment SET paid = 't' WHERE id = $1
      |}
  in
  fun (id : string) (module Db : DB) ->
    let%lwt result = Db.exec query id in
    Caqti_lwt.or_fail result

let unpay =
  let query =
    let open Caqti_request.Infix in
    (T.string ->. T.unit)
      {|
      UPDATE payment SET paid = 'f' WHERE id = $1
      |}
  in
  fun (id : string) (module Db : DB) ->
    let%lwt result = Db.exec query id in
    Caqti_lwt.or_fail result
