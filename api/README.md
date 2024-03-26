# API

Steps for development

1. Install Linux deps `ocaml libev-dev libpq-dev pkg-config`

2. Install project deps `opam install --deps-only .`

3. Build `opam exec -- dune build`

4. Set up `DATABASE_URL` variable: it should be a PostgreSQL uri. Set up a
   `API_TOKEN` used to create new payments.

5. Run `dune run acmebank`
