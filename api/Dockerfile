FROM ocaml/opam:debian-12-ocaml-5.1 as build
WORKDIR /build

# Install dependencies.
RUN sudo apt-get update
RUN sudo apt-get install -y libev-dev libpq-dev pkg-config libgmp-dev

COPY . .

RUN opam install --deps-only .

# Build project.
RUN opam exec -- dune build



FROM debian:bookworm-slim as run

RUN apt-get update
RUN apt-get install -y libev4 libpq5 libssl3

COPY --from=build /build/_build/default/bin/main.exe /bin/acmebank

ENTRYPOINT /bin/acmebank
