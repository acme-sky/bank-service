open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type foo = {message : string} [@@deriving yojson]

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.post "/" (fun request ->
             let%lwt body = Dream.body request in

             let m = body |> Yojson.Safe.from_string |> foo_of_yojson in
             yojson_of_foo m |> Yojson.Safe.to_string |> Dream.json);
       ]
