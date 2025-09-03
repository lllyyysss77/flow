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

# 设置OpenAI API密钥提示
echo "请设置OPENAI_API_KEY环境变量："
echo "1. 临时设置: export OPENAI_API_KEY=your_api_key"
echo "2. 永久设置: 将 'export OPENAI_API_KEY=your_api_key' 添加到 ~/.bashrc 或 ~/.zshrc"
echo "3. 使用.env文件: 在项目根目录创建.env文件并添加 OPENAI_API_KEY=your_api_key"
