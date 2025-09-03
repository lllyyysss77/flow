#!/bin/bash
set -e
# 安装系统依赖并准备环境（非交互式）
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y pkg-config libgtk-3-dev libwebkit2gtk-4.1-dev build-essential curl

# 加载 Rust 环境（如果已安装）
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# 安装 JS/Yarn 依赖
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR/FlowDeerTree"
if command -v yarn >/dev/null 2>&1; then
  yarn install --frozen-lockfile || yarn install
else
  echo "yarn 未安装，请手动安装 yarn 或使用 npm 安装依赖。继续使用 npm..."
  npm install
fi

cd "$ROOT_DIR/FlowDeerTreeElectron"
if command -v yarn >/dev/null 2>&1; then
  yarn install --frozen-lockfile || yarn install
else
  npm install
fi

echo "环境准备完成。"
