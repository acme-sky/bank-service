# ACME Sky - Bank Service

This repo refers to the Bank service used by ACME Sky.

## `./api` folder

It exposes a REST API with three endpoints:

- `POST /payments/` used to create new payments. An example is:

```
curl -X POST http://localhost:8080/payments/ -H 'x-api-token: token' -H 'content-type: application/json' -H 'accept: application/json, */*;q=0.5' -d '{"owner":"John Doe","amount":30.4,"description":"Flight to CTA"}'
```

You have to know the API token and pass it by `X-API-TOKEN` header.

- `GET /payments/<id>/` used to get info about a payment. An example is:

```
curl http://localhost:8080/payments/20e8f98d-f67e-4e40-9ddb-77b786e61560/

HTTP/1.1 200 OK
Access-Control-Allow-Headers: Content-Type
Access-Control-Allow-Methods: OPTIONS, GET, HEAD, POST
Access-Control-Allow-Origin: *
Access-Control-Max-Age: 86400
Allow: OPTIONS, GET, HEAD, POST
Content-Length: 162
Content-Type: application/json

{
    "id": "20e8f98d-f67e-4e40-9ddb-77b786e61560",
    "owner": "John Doe",
    "amount": 30.4,
    "description": "Flight to BLQ",
    "paid": true,
    "created_at": "2024-03-25 15:34:45.093465"
}
```

- `POST /payments/<id>/pay/` used to change `paid` status. It is a fake:
  card information are ignored. Payload can be empty.

> [!NOTE]
> Do not forget to create a PostgreSQL database and link it to the API through
> `DATABASE_URL` environment variable.

## `./ui` folder

A simple frontend built in Vue+Vite. You must define `VITE_BACKEND_URL` which
points to the API.

![Screnshot](./assets/screenshot.png)

## Build

> [!TIP]
> You can use `./build.sh` for a step-by-step guide for deploying.

You need to set up

```
POSTGRES_USER=user
POSTGRES_PASSWORD=pass
POSTGRES_DB=db
DATABASE_URL=postgres://user:pass@bankservice-postgres:5432/db
API_TOKEN=token
```

and build

```
docker build -t acmesky-bankservice-api api
docker build -t acmesky-bankservice-ui --build-arg VITE_BACKEND_URL=http://localhost:8080 ui
```

after that you can put everything up

```
docker compose up
```
