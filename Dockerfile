
# set up a rust build environment:
FROM rust:1.98.1-bookworm AS buildbase
WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    && rm -rf /var/lib/apt/lists/*

RUN <<EOT bash
    set -ex
    rustup target add wasm32-wasip1
EOT

FROM buildbase as build

COPY Cargo.toml .

COPY crates ./crates

RUN cargo install wasm-pack
#is this needed?^

RUN wasm-pack build ./crates/webxraydb-wasm --target web --out-dir ./wasm-pkg
# creates a wasm pkg at: crates/webxraydb-wasm/wasm-pkg

FROM oven/bun:1.2-debian as client

WORKDIR /app

COPY /app/bun.lock /app/package.json ./

# error here!
COPY --from=build src/crates/webxraydb-wasm/wasm-pkg /wasm-pkg
RUN bun install


# RUN bun install

# EXPOSE 3000

# ENTRYPOINT = ["bun", "run", "dev"]
