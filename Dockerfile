# Multi-stage Dockerfile for the IronClaw agent (cloud deployment).
#
# Build:
#   docker build --platform linux/amd64 -t ironclaw:latest .
#
# Run:
#   docker run --env-file .env -p 3000:3000 ironclaw:latest

# Stage 1: Build
FROM rust:slim-bookworm AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev cmake gcc g++ curl \
    && rm -rf /var/lib/apt/lists/*

# Add WASM target for building Telegram channel
RUN rustup target add wasm32-wasip2

# Install wasm-tools for WASM processing
RUN cargo install wasm-tools

WORKDIR /app

# Copy manifests first for layer caching
COPY Cargo.toml Cargo.lock ./
COPY build.rs ./

# Copy source code
COPY src/ src/

# Copy examples (required by Cargo.toml manifest)
COPY examples/ examples/

# Copy migrations and wit files
COPY migrations/ migrations/
COPY wit/ wit/

# Copy WASM channel sources (required by build.rs)
COPY channels-src/telegram/ channels-src/telegram/

# Build the release binary
RUN cargo build --release --bin ironclaw

# Stage 2: Runtime
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/ironclaw /usr/local/bin/ironclaw
COPY --from=builder /app/migrations /app/migrations

# Non-root user
RUN useradd -m -u 1000 -s /bin/bash ironclaw
USER ironclaw

EXPOSE 3000

ENV RUST_LOG=ironclaw=info

ENTRYPOINT ["ironclaw"]
