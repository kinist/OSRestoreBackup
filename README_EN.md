# Windows System Backup Tool

[中文版](README.md) | English Version

### Description
A powerful Windows system backup tool that supports both custom and full system backup modes. This tool is designed to help users backup their important system configurations and user data efficiently.

### Features
- Two backup modes:
  - Custom backup: Excludes system six directories
  - Full backup: Includes all directories including system six directories
- Automatic exclusion of specific Junction points
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
- Windows operating system
- Administrator privileges
- PowerShell 5.0 or higher

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