//! OpenAI 标准配置接口
//! 
//! 提供符合OpenAI官方API标准的配置选项

use serde::{Deserialize, Serialize};
use std::env;

/// OpenAI配置结构体
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OpenAIConfig {
    /// API密钥 (默认从环境变量读取)
    pub api_key: String,
    /// 模型名称 (例如: "gpt-4-turbo")
    pub model: String,
    /// 生成温度 (0.0-2.0)
    pub temperature: f32,
    /// 最大返回token数
    pub max_tokens: Option<u32>,
    /// 请求超时时间 (秒)
    pub timeout: u64,
}

impl Default for OpenAIConfig {
    fn default() -> Self {
        OpenAIConfig {
            api_key: env::var("OPENAI_API_KEY").unwrap_or_default(),
            model: "gpt-4-turbo".to_string(),
            temperature: 0.7,
            max_tokens: Some(2048),
            timeout: 30,
        }
    }
}

/// 更新OpenAI配置
/// 
/// # 参数
/// - `new_config`: 新的配置对象
/// 
/// # 返回
/// 更新后的配置对象
pub fn update_config(new_config: OpenAIConfig) -> OpenAIConfig {
    // 实际应用中这里会有配置持久化逻辑
    new_config
}

/// 获取当前OpenAI配置
/// 
/// # 返回
/// 当前配置对象
pub fn get_config() -> OpenAIConfig {
    OpenAIConfig::default()
}
