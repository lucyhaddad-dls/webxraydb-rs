FROM oven/bun:latest AS builder

RUN apt-get update -y && apt-get install -y ca-certificates curl build-essential

# get Rust:
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- --default-toolchain stable --profile minimal --target x86_64-unknown-linux-gnu -y

ENV PATH="/root/.cargo/bin:${PATH}"

# and get wasm-pack + cargo-generate for template and rust->wasm:

RUN cargo install wasm-pack
# wasm-pack build crates/webxraydb-wasm --target web --out-dir ../../app/src/wasm-pkg


# WORKDIR /app

# COPY /app/bun.lock /app/package.json ./

# # error here!
# COPY --from=build src/crates/webxraydb-wasm/wasm-pkg /wasm-pkg
# RUN bun install

# # EXPOSE 3000

# # ENTRYPOINT = ["bun", "run", "dev"]
