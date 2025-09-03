脚本目录说明

可用脚本：

- `setup_env.sh`：安装系统依赖（GTK、WebKit 等）并安装 JS 依赖（FlowDeerTree、FlowDeerTreeElectron）。
- `build_backend.sh`：构建 Rust 后端（`FlowDeerTree/src-tauri`）。
- `run_tests.sh`：运行 Rust 后端测试。
- `run_backend.sh`：运行后端（`cargo run`）。
- `package_tauri.sh`：使用 tauri CLI 打包应用（需要 node + tauri CLI）。
- `deploy_and_start.sh`：一键部署并后台启动后端（见脚本头部说明）。

示例：

安装并构建（本机，有 sudo 权限）:

```bash
./scripts/deploy_and_start.sh
```

跳过系统依赖安装（CI）并启动前端：

```bash
./scripts/deploy_and_start.sh --skip-system-deps --ui
```
