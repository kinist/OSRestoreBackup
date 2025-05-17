# Windows System Backup Tool | Windows 系统备份工具

[CHANGELOG](CHANGELOG.md)

[中文](#chinese) | [English](#english)

<a name="chinese"></a>
## 中文

### 简介
一个功能强大的 Windows 系统备份工具，支持自定义和全量系统备份模式。该工具旨在帮助用户高效地备份重要的系统配置和用户数据。

### 功能特点
- 两种备份模式：
  - 自定义备份：不含系统六目录
  - 全量备份：含系统六目录
- 自动检测并排除所有 Junction 点（目录本身为 Junction 时，会在备份目录中创建同名空目录，并生成 JUNCTION_INFO.txt 说明文件）
- 详细的日志记录系统
- 管理员权限检查
- UTF-8 编码支持
- 多线程文件复制
- 全面的备份覆盖范围，包括：
  - 用户配置文件
  - 应用程序数据
  - 开发目录
  - 系统配置
  - 各种应用程序设置

### 使用前提
- Windows 10 或 Windows 11 操作系统
- 管理员权限
- PowerShell 5.0 或更高版本（建议使用 Windows 自带 PowerShell，或 PowerShell Core 7.x 及以上）

### 使用方法
1. 以管理员权限运行脚本
2. 选择备份模式：
   - 0：退出
   - 1：自定义备份（不含系统六目录）
   - 2：全量备份（含所有目录）
3. 按回车键确认选择
4. 等待备份过程完成

### 备份内容
- 桌面
- 下载
- 文档
- 图片
- 音乐
- 视频
- 收藏夹
- 开发配置（.vscode、.m2 等）
- IDE 项目目录
- 应用程序数据
- 系统配置

### 注意事项
- 备份前确保有足够的磁盘空间
- 备份前关闭正在运行的程序
- 备份过程中请勿关闭窗口
- 备份日志保存在备份目录中

### 手动备份建议
- 浏览器收藏夹和密码
- 记事本
- 桌面截图
- 邮件客户端通讯录
- 数据库配置
- HeidiSQL 设置

---

<a name="english"></a>
## English

### Description
A powerful Windows system backup tool that supports both custom and full system backup modes. This tool is designed to help users backup their important system configurations and user data efficiently.

### Features
- Two backup modes:
  - Custom backup: Excludes system six directories
  - Full backup: Includes all directories including system six directories
- Automatically detect and exclude all Junction points (if a directory itself is a Junction, an empty directory with the same name will be created in the backup, along with a JUNCTION_INFO.txt description file)
- Detailed logging system
- Administrator privilege check
- UTF-8 encoding support
- Multi-threaded file copying
- Comprehensive backup coverage including:
  - User profiles
  - Application data
  - Development directories
  - System configurations
  - Various application settings

### Prerequisites
- Windows 10 or Windows 11 operating system
- Administrator privileges
- PowerShell 5.0 or higher (recommended: built-in Windows PowerShell, or PowerShell Core 7.x and above)

### Usage
1. Run the script with administrator privileges
2. Choose backup mode:
   - 0: Exit
   - 1: Custom backup (excluding system six directories)
   - 2: Full backup (including all directories)
3. Confirm your choice by pressing Enter
4. Wait for the backup process to complete

### Backup Contents
- Desktop
- Downloads
- Documents
- Pictures
- Music
- Videos
- Favorites
- Development configurations (.vscode, .m2, etc.)
- IDE project directories
- Application data
- System configurations

### Notes
- Ensure sufficient disk space before backup
- Close running applications before backup
- Do not close the window during backup
- Backup logs are saved in the backup directory

### Manual Backup Recommendations
- Browser bookmarks and passwords
- Sticky notes
- Desktop screenshots
- Email client contacts
- Database configurations
- HeidiSQL settings 