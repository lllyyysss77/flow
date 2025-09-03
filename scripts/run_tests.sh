#!/bin/bash
set -e
. "$HOME/.cargo/env"
cd "$(dirname "$0")/.."/FlowDeerTree/src-tauri
cargo test -- --nocapture
