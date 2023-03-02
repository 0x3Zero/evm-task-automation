#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

# set current working directory to script directory to run script from everywhere
cd "$(dirname "$0")"

# This script builds all subprojects and puts all created Wasm modules in one dir
cargo update --aggressive
marine build --release

mkdir -p artifacts
rm -f artifacts/*.wasm
cp target/wasm32-wasi/release/evm_block_listener.wasm artifacts/
marine aqua artifacts/evm_block_listener.wasm -s evm_block_listener -i evm_block_listener > ./aqua/evm_block_listener.aqua

wget https://github.com/fluencelabs/sqlite/releases/download/v0.15.0_w/sqlite3.wasm
mv sqlite3.wasm artifacts/

RUST_LOG="info" mrepl --quiet Config.toml