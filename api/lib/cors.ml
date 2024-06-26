let middleware handler req =
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
