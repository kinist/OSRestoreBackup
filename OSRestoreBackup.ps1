# ============================================================================
# 文件名: OSRestoreBackup.ps1
# 描述: Windows 系统备份工具
# 功能: 支持自定义备份和全量备份，可排除特定 Junction 点
# 
# 作者: Gavin
# 最后更新: 2024-05-07
# 版本: 1.0.0
# 
# 更新历史:
# v1.0.0 (2024-05-07)
# - 初始版本
# - 支持自定义备份和全量备份
# - 支持排除特定 Junction 点
# - 添加详细的日志记录
# 
# 使用说明:
# 1. 需要管理员权限运行
# 2. 支持两种备份模式：
#    - 自定义备份：不含系统六目录
#    - 全量备份：含系统六目录
# 3. 自动排除 Documents 目录下的特定 Junction 点
# 4. 使用 run.bat 进行启动
# 
# 注意事项:
# 1. 请确保有足够的磁盘空间
# 2. 建议在备份前关闭正在运行的程序
# 3. 备份过程中请勿关闭窗口
# ============================================================================

# 检查当前进程是否以管理员身份运行
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # 重新以管理员权限运行 PowerShell
    Write-Host "🔺 需要管理员权限，正在请求提升权限..." -ForegroundColor Yellow

    # 获取当前 PowerShell 脚本路径
    $scriptPath = $PSCommandPath

    # 获取当前工作目录
    $currentDirectory = Get-Location

    # 构造启动参数 - 保持窗口打开，并传递当前目录
    $arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"Set-Location -Path '$currentDirectory'; & '$scriptPath'`""

    # 以管理员权限运行 PowerShell，并退出当前进程
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    Exit
}

# 设置输出编码为 UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 显示欢迎信息
$welcomeMessage = @"
=======================================
欢迎来到系统级备份脚本，该脚本将按照要求备份指定的文件夹，
包括并不限于如文档、下载等目录。

0) 退出备份 - 退出备份脚本 (按回车键)
1) 自定义备份 - 不含系统六目录
2) 全量级备份 - 含系统六目录, 如:桌面、下载、文档、图片、音乐、视频
=======================================
"@

Write-Output $welcomeMessage

# 监听用户输入，确保输入正确
do {
    Write-Host "请输入选项 (0-2)..." -NoNewline
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host " $($key.Character)"  # 在同一行显示用户按下的键

    # 判断用户输入
    $char = $key.Character
    if ($char -eq "`r" -or $char -eq "0") { # "回车" 或 "0"
        Write-Output "你已选择退出，备份终止！"
        Exit
    } elseif ($char -eq "1") { # "1"
        $backupAll = $false
        Write-Output "你已选择【1】, 自定义备份，将会跳过系统级六个目录，将备份其他关键数据..."
        Write-Host "按回车键开始备份，按其他键取消..." -NoNewline
        $confirmKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($confirmKey.Character -ne "`r") {
            Write-Output "`n备份已取消！"
            Exit
        }
        break
    } elseif ($char -eq "2") { # "2"
        $backupAll = $true
        Write-Output "你已选择【2】, 全量备份，将备份所有目录..."
        Write-Host "按回车键开始备份，按其他键取消..." -NoNewline
        $confirmKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($confirmKey.Character -ne "`r") {
            Write-Output "`n备份已取消！"
            Exit
        }
        break
    } else {
        Write-Output "❌ 输入无效，请重新输入！"
    }
} while ($true)

# 获取当前时间和计算机名
$now = Get-Date -Format "yyyyMMdd-HHmmss"
$computerName = $env:COMPUTERNAME
$destinationPath = Join-Path -Path $PWD.Path -ChildPath "Backup_${computerName}_${now}"

# 创建备份目录
New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null

# 1生成日志文件
$logFile = Join-Path -Path $destinationPath -ChildPath "backup_${now}.log"
"日志开始... [$now]" | Out-File -FilePath $logFile -Encoding utf8

# 3️⃣ 记录备份模式
if ($backupAll) {
    "`n本次为全量备份，将备份所有目录...`n" | Out-File -FilePath $logFile -Encoding utf8 -Append
} else {
    "`n本次为自定义备份，将会跳过系统级六个目录，将备份其他关键数据...`n" | Out-File -FilePath $logFile -Encoding utf8 -Append
}


# 定义所有需要备份的文件夹
# 添加需要备份的文件夹，目前仅支持文件夹备份
# $env:USERPROFILE = C:\Users\当前用户
# $env:APPDATA = C:\Users\当前用户\AppData\Roaming
# $env:LOCALAPPDATA = C:\Users\当前用户\AppData\Local
# ${env:ProgramFiles(x86)} = C:\Program Files (x86)
# $env:windir = C:\Windows

# 定义要排除的Junction点
$excludeJunctions = @(
    "$env:USERPROFILE\Documents\My Music",
    "$env:USERPROFILE\Documents\My Pictures",
    "$env:USERPROFILE\Documents\My Videos"
)

$allFolders = @(
    "$env:USERPROFILE\Desktop",   # 桌面
    "$env:USERPROFILE\Downloads", # 下载
    "$env:USERPROFILE\Documents", # 文档
    "$env:USERPROFILE\Pictures",  # 图片
    "$env:USERPROFILE\Music",     # 音乐
    "$env:USERPROFILE\Videos",    # 视频
    "$env:USERPROFILE\Favorites",
    "$env:USERPROFILE\.config",
    "$env:USERPROFILE\.ssh",
    "$env:USERPROFILE\.vscode",
    "$env:USERPROFILE\.m2",
    "$env:USERPROFILE\apple",
    "$env:USERPROFILE\AndroidStudioProjects",
    "$env:USERPROFILE\IdeaProjects",
    "$env:USERPROFILE\PhpstormProjects",
    "$env:USERPROFILE\WebstormProjects",
    "$env:USERPROFILE\workspace",
    "$env:USERPROFILE\Workspaces",
    "$env:USERPROFILE\Zend",
    "$env:LOCALAPPDATA\wjjsoft",
    "$env:LOCALAPPDATA\Transmission Remote GUI",
    "$env:APPDATA\DBeaverData",
    "$env:APPDATA\Microsoft\Sticky Notes",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs",
    "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch",
    "$env:APPDATA\Scooter Software",
    "$env:APPDATA\Mikrotik",
    "$env:APPDATA\obsidian",
    "$env:APPDATA\RustDesk",
    "$env:APPDATA\Typora",
    "$env:APPDATA\XnViewMP",
    "${env:ProgramFiles(x86)}\AliWangWang\profiles",
    "$env:windir\System32\drivers\etc"
)

# 排除系统目录
$excludeFolders = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Pictures",
    "$env:USERPROFILE\Music",
    "$env:USERPROFILE\Videos"
)

$backupFolders = if ($backupAll) {
    $allFolders
} else {
    $allFolders | Where-Object { $_ -notin $excludeFolders }
}

# 终端显示日志文件路径
$logHeader = @"
=======================================
📂 备份目标路径: $destinationPath
📝 日志文件: $logFile
排除的Junction点: $($excludeJunctions -join ', ')
=======================================
"@
Write-Output $logHeader
$logHeader | Out-File -FilePath $logFile -Encoding utf8 -Append
           
# 备份文件夹
$counter = 0
$total = $backupFolders.Count

foreach ($source in $backupFolders) {
    $counter++
    $logEntry = "`n[$counter/$total] 正在备份: $source"
    Write-Host $logEntry
    $logEntry | Out-File -FilePath $logFile -Encoding utf8 -Append

    if (Test-Path $source) {
    	
        # 获取盘符，并构造新的相对路径
        $driveLetter = ($source -split ":")[0]
        $relativePath = ($source -replace "^[A-Z]:\\", "")
        $relativePath = "$driveLetter\$relativePath"

        # 计算目标目录
        $destination = Join-Path -Path $destinationPath -ChildPath $relativePath

        # ✅ 这里删除重复的 "Log File" 输出
        $logInfo = "`正在拷贝目录: $source -> $destination"
        Write-Host $logInfo
        $logInfo | Out-File -FilePath $logFile -Encoding utf8 -Append

        try {
            # 确保目标目录存在, 否则创建
            New-Item -ItemType Directory -Path $destination -Force | Out-Null

            # 使用 robocopy 进行完整复制 /E - 复制所有文件和子目录（包括空目录）
            # robocopy $source $destination /E /COPYALL /R:3 /W:5 /NP /LOG+:$logFile
            # robocopy $source $destination /E /COPYALL /A-:SH /R:3 /W:5 /NP /LOG+:$logFile
            # robocopy $source $destination /E /COPYALL /A-:SH /R:3 /W:5 /MT:8 /NP /LOG+:$logFile
            # robocopy $source $destination /E /COPYALL /A-:SH /XD $excludeJunctions /R:3 /W:5 /MT:8 /NP /LOG+:$logFile *> $null
            robocopy $source $destination /E /COPYALL /A-:SH /XJ /R:3 /W:5 /MT:8 /NP /LOG+:$logFile *> $null

            $logResult = "`✔  拷贝成功: $source"
            Write-Host $logResult
            $logResult | Out-File -FilePath $logFile -Encoding utf8 -Append

        } catch {
            $logResult = "`❌  拷贝失败: $source - 错误: $_"
            Write-Host $logResult
            $logResult | Out-File -FilePath $logFile -Encoding utf8 -Append
        }
    } else {
        $logResult = "`⚠  源目录不存在: $source"
        Write-Host $logResult
        $logResult | Out-File -FilePath $logFile -Encoding utf8 -Append
    }
}

# 备份完成的其他确认信息
$backupMessage = @"
`n=======================================
🎉 【浏览器手工备份部分】
✔  备份浏览器收藏夹, 包括: "Edge", "Chrome", "Firefox"
✔  备份浏览器密码, 包括: "Edge", "Chrome", "Firefox"
✔  备份浏览器插件配置文件, 如: "Firefox"
✔  备份浏览器当前浏览网页

🎉 【记事本手工备份部分】
✔  备份记事本缓存文档

🎉 【桌面手工备份部分】
✔  把桌面截图保存下来

🎉 【邮箱相关手工备份部分】
✔  备份邮件客户端的通讯录, 如: "Outlook"

🎉 【数据库相关手工备份部分】
✔  导出 HeidiSQL 配置文件
✔  备份数据库数据文件, 如: "mysql"
=======================================`n
"@

Write-Host $backupMessage
$backupMessage | Out-File -FilePath $logFile -Encoding utf8 -Append

# 等待用户按键
Write-Output "请按任意键继续..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
