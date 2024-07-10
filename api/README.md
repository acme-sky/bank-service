# ACME Sky - Bank Service API

This repo refers to the Bank service PAI used by ACME Sky.

## Build

> [!TIP]
> You can use `./build.sh` for a step-by-step setup guide for deploying.

You need to set up

```
POSTGRES_USER=user
POSTGRES_PASSWORD=pass
POSTGRES_DB=db
DATABASE_DSN="host=localhost user=user password=pass dbname=db port=5432"
API_TOKEN=t0k3n
```

and build

```
docker build -t acmesky-bankservice-api .
```

## Auth

You need to pass `X-API-TOKEN` to create a new payment.
