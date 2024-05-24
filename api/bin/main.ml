module Payment = Models.Payment
module Cors = Lib.Cors
module PaymentRoute = Routes.Payment

let () =
  let postgres_url =
    match Sys.getenv_opt "DATABASE_URL" with
    | Some url -> url
    | None -> "postgresql://dream:password@postgres/dream"
  in

  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Cors.middleware
  @@ Dream.sql_pool postgres_url
  @@ Dream.sql_sessions
  @@ Dream.router
       [
         Dream.scope "/payments" []
           [
             Dream.post "/" PaymentRoute.post;
             Dream.get "/:id/" PaymentRoute.get;
             Dream.post "/:id/pay/" PaymentRoute.pay;
           ];
         Dream.get "/**" (Dream.static "static");
       ]
