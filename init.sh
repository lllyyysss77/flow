#!/bin/bash
# 自动化环境初始化脚本
set -e

# 检查 Node.js 和 Yarn
if ! command -v node &> /dev/null; then
  echo "请先安装 Node.js"
  exit 1
fi
if ! command -v yarn &> /dev/null; then
  echo "请先安装 Yarn"
  exit 1
fi

# FlowDeerTree 依赖安装
echo "安装 FlowDeerTree 依赖..."
cd FlowDeerTree
yarn install

# FlowDeerTreeElectron 依赖安装
echo "安装 FlowDeerTreeElectron 依赖..."
cd ../FlowDeerTreeElectron
yarn install

cd ..
echo "依赖安装完成。"

echo "启动 FlowDeerTreeElectron..."
cd FlowDeerTreeElectron
yarn start
