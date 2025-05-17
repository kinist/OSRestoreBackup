# Changelog | 更新日志

[中文](#chinese) | [English](#english)

<a name="chinese"></a>
## 中文

本文件记录项目所有重要的更改。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
并且本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - 2025-05-17

### 新增
- 首次发布
- 支持自定义备份模式
- 支持全量备份模式
- 自动排除所有 Junction 点（目录本身为 Junction 时，会在备份目录中创建同名空目录，并生成 JUNCTION_INFO.txt 说明文件）
- 详细的日志记录系统
- 管理员权限检查
- UTF-8 编码支持
- 多线程文件复制
- 全面的备份覆盖范围
- 备份前的用户确认步骤
- 双语文档（英文和中文）

### 改进
- 改进用户交互流程
- 增强错误处理
- 优化备份过程

### 修复
- 修复潜在的编码问题
- 修复 Junction 点处理 

## 后续优化建议

### 代码结构与可读性
- 函数化：将主要逻辑（如备份单个目录、检测Junction、日志写入等）进一步封装为函数，提升可维护性和可扩展性。
- 异常处理：对整个主流程增加全局异常捕获，避免脚本中断时无提示。
- 变量命名：保持变量命名一致性，便于后续维护。

### 兼容性与健壮性
- 路径存在性检查：在加入备份列表前判断目录是否存在，减少无效日志。
- 日志文件：在日志文件开头增加脚本版本号、操作系统信息，便于溯源。
- 多语言支持：如有国际化需求，增加英文提示。

### 用户体验
- 进度提示：在终端输出更详细的进度条或百分比。
- 参数化支持：支持命令行参数（如直接指定备份模式、目标路径等），方便自动化。

### 代码安全
- 路径拼接：继续采用 Join-Path，保证安全性。

---

<a name="english"></a>
## English

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-05-17

### Added
- Initial release
- Support for custom backup mode
- Support for full backup mode
- Automatic exclusion of all Junction points (if a directory itself is a Junction, an empty directory with the same name will be created in the backup, along with a JUNCTION_INFO.txt description file)
- Detailed logging system
- Administrator privilege check
- UTF-8 encoding support
- Multi-threaded file copying
- Comprehensive backup coverage
- User confirmation step before backup
- Bilingual documentation (English and Chinese)

### Changed
- Improved user interaction flow
- Enhanced error handling
- Optimized backup process

### Fixed
- Fixed potential encoding issues
- Fixed junction point handling 

## Future Improvement Suggestions

### Code Structure & Readability
- Refactor: Encapsulate main logic (such as backing up a single directory, detecting Junctions, logging, etc.) into functions for better maintainability and extensibility.
- Exception Handling: Add global exception handling to the main process to avoid silent script termination.
- Variable Naming: Maintain consistent variable naming for easier future maintenance.

### Compatibility & Robustness
- Path Existence Check: Check if directories exist before adding them to the backup list to reduce invalid logs.
- Log File: Add script version and OS information at the beginning of the log file for traceability.
- Multi-language Support: Add English prompts if internationalization is needed.

### User Experience
- Progress Indication: Output more detailed progress bars or percentages in the terminal.
- Parameterization: Support command-line parameters (such as specifying backup mode, target path, etc.) for automation.

### Code Security
- Path Concatenation: Continue using Join-Path to ensure security.

--- 