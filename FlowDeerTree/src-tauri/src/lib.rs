//! Tauri 命令处理模块
//! 
//! 包含核心业务逻辑和API端点

mod openai_config;
use openai_config::{OpenAIConfig, get_config, update_config};

/// 应用状态结构体
#[derive(Default)]
pub struct AppState {
    // 状态字段示例
    // task_queue: Mutex<Vec<String>>,
}

/// 欢迎命令
/// 
/// # 参数
/// - `name`: 用户名
/// 
/// # 返回
/// 格式化后的欢迎消息
#[tauri::command]
pub fn greet(name: &str) -> String {
    format!("Hello, {}! Welcome to FlowDeer", name)
}

/// 启动异步任务
/// 
/// # 参数
/// - `app`: 应用句柄
/// - `id`: 任务ID
/// 
/// # 返回
/// 任务执行结果
#[tauri::command]
pub async fn start_task(app: tauri::AppHandle, id: String) -> Result<(), String> {
    // 模拟异步任务
    tokio::time::sleep(std::time::Duration::from_secs(2)).await;
    
    // 发送事件到前端
    app.emit("task_completed", &id)
        .map_err(|e| e.to_string())?;
    
    Ok(())
}

/// 获取当前OpenAI配置
#[tauri::command]
pub async fn get_openai_config() -> Result<OpenAIConfig, String> {
    Ok(get_config())
}

/// 更新OpenAI配置
#[tauri::command]
pub async fn update_openai_config(new_config: OpenAIConfig) -> Result<OpenAIConfig, String> {
    Ok(update_config(new_config))
}

/// 初始化Tauri应用
pub fn run_app() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            greet, 
            start_task,
            get_openai_config,
            update_openai_config
        ])
        .manage(AppState::default())
        .run(tauri::generate_context!())
        .expect("运行Tauri应用时出错");
}
