/**
 * Creates a new browser window for the Electron application.
 */
const createWindow = () => {
    // 创建窗口的逻辑
    try {
        const { BrowserWindow } = require('electron');
        const win = new BrowserWindow({
            width: 800,
            height: 600,
            webPreferences: {
                nodeIntegration: true,
                contextIsolation: false,
            },
        });

        win.loadURL('http://localhost:3000'); // 假设前端运行在本地服务器上

        win.on('closed', () => {
            // 清理操作
        });
    } catch (error) {
        console.error('Failed to create window:', error);
    }
};

module.exports = createWindow;
