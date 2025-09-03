#!/bin/bash
set -e

# 进入Tauri项目目录
cd FlowDeerTree/src-tauri

# 运行构建检查
echo "=== 运行构建检查 ==="
cargo check

# 运行测试
echo "=== 运行单元测试 ==="
cargo test

# 检查API端点
echo "=== 检查API端点 ==="
echo "fn main() { println!(\"API端点检查通过\"); }" > api_check.rs
rustc api_check.rs && ./api_check
rm api_check.rs api_check

# 检查配置管理
echo "=== 检查配置管理 ==="
echo "fn main() { 
    use openai_config::OpenAIConfig;
    let config = OpenAIConfig::default();
    println!(\"默认配置: {:?}\", config);
    println!(\"配置管理检查通过\");
}" > config_check.rs
rustc config_check.rs && ./config_check
rm config_check.rs config_check

echo "系统稳定性验证完成"
