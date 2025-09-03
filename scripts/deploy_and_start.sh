#!/usr/bin/env bash
set -euo pipefail

# 一键部署并启动脚本
# 用途：安装（可选）系统依赖 -> 安装 JS 依赖 -> 构建 Rust 后端 -> 运行后端测试 -> 后台启动后端
# 用法：
#   ./scripts/deploy_and_start.sh [--skip-system-deps] [--no-ui]
# 参数：
#   --skip-system-deps  跳过 apt 安装（适用于 CI 或已准备好环境的容器）
#   --no-ui             不尝试启动 Electron 界面（默认不启动，因为无头环境可能不可用）

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKIP_SYSTEM_DEPS=0
NO_UI=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-system-deps) SKIP_SYSTEM_DEPS=1; shift ;;
    --no-ui) NO_UI=1; shift ;;
    --ui) NO_UI=0; shift ;;
    -h|--help)
      sed -n '1,120p' "$0"
      exit 0
      ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

echo "ROOT_DIR=$ROOT_DIR"

if [ "$SKIP_SYSTEM_DEPS" -eq 0 ]; then
  echo "安装系统依赖（需要 sudo）..."
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y pkg-config libgtk-3-dev libwebkit2gtk-4.1-dev build-essential curl || true
else
  echo "跳过系统依赖安装"
fi

# 加载 Rust 环境（如果已安装）
if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.cargo/env"
fi

echo "安装前端/renderer 依赖..."
bash "$ROOT_DIR/scripts/setup_env.sh"

echo "构建 Rust 后端..."
bash "$ROOT_DIR/scripts/build_backend.sh"

echo "运行后端测试..."
bash "$ROOT_DIR/scripts/run_tests.sh"

# 确保日志目录存在
mkdir -p "$ROOT_DIR/logs"

echo "后台启动后端（logs/backend.log）..."
nohup bash "$ROOT_DIR/scripts/run_backend.sh" > "$ROOT_DIR/logs/backend.log" 2>&1 &
echo $! > "$ROOT_DIR/logs/backend.pid"
echo "后端已后台启动，PID=$(cat "$ROOT_DIR/logs/backend.pid")"

if [ "$NO_UI" -eq 0 ]; then
  echo "尝试启动 Electron (FlowDeerTreeElectron)..."
  if command -v yarn >/dev/null 2>&1; then
    (cd "$ROOT_DIR/FlowDeerTreeElectron" && nohup yarn start > "$ROOT_DIR/logs/electron.log" 2>&1 &) || true
  else
    (cd "$ROOT_DIR/FlowDeerTreeElectron" && nohup npm run start > "$ROOT_DIR/logs/electron.log" 2>&1 &) || true
  fi
  echo "Electron 启动日志: $ROOT_DIR/logs/electron.log"
else
  echo "未启动前端（--no-ui 或 默认）。若需启动 Electron，请运行：\n  (cd $ROOT_DIR/FlowDeerTreeElectron && yarn start)"
fi

echo "一键部署完成。查看后端日志: tail -n 200 $ROOT_DIR/logs/backend.log"
