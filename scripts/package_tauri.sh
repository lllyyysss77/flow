#!/bin/bash
set -e
. "$HOME/.cargo/env"
cd "$(dirname "$0")/.."/FlowDeerTree
# 构建前端静态资源（如需要）
if [ -f package.json ]; then
  if command -v yarn >/dev/null 2>&1; then
    yarn build || true
  else
    npm run build || true
  fi
fi
# 使用 tauri CLI 打包
if command -v yarn >/dev/null 2>&1; then
  yarn tauri build
else
  npx tauri build
fi
