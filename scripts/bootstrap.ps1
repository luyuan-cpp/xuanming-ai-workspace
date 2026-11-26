<#
.SYNOPSIS
    新电脑/干净工作区一键初始化一级子仓（按 .gitmodules 直接拉到 main 分支，不递归 third_party）。
.PARAMETER DryRun
    仅打印将要执行的配置与克隆命令，不修改任何文件或发起网络请求。
.PARAMETER NoBlobFilter
    禁用 --filter=blob:none（默认启用以加快大仓库首克隆速度）。
#>
[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$NoBlobFilter
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Git {
    param([Parameter(Mandatory)][string[]]$GitArgs)
    # Windows PowerShell 5.1 在 ErrorActionPreference=Stop 下可能将 git stderr 进度输出误判为异常
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & git @GitArgs
        if ($LASTEXITCODE -ne 0) {
            throw ("git failed (exit {0}): git {1}" -f $LASTEXITCODE, ($GitArgs -join ' '))
        }
    } finally {
        $ErrorActionPreference = $prev
    }
}

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$GitModulesPath = Join-Path $RepoRoot '.gitmodules'

if (-not (Test-Path $GitModulesPath)) {
    throw "Missing .gitmodules at $GitModulesPath"
}

$rawLines = Invoke-Git @('-C', $RepoRoot, 'config', '--file', $GitModulesPath, '--get-regexp', '^submodule\..*\.(path|url|branch)$')

$submodules = [ordered]@{}
foreach ($line in $rawLines) {
    if ($line -match '^submodule\.(.+)\.(path|url|branch)\s+(.+)$') {
        $name = $Matches[1]
        $key = $Matches[2]
        $val = $Matches[3].Trim()
        if (-not $submodules.Contains($name)) {
            $submodules[$name] = @{ Name = $name; Path = ''; Url = ''; Branch = 'main' }
        }
        $submodules[$name][$key.Substring(0, 1).ToUpper() + $key.Substring(1)] = $val
    }
}

if ($submodules.Count -eq 0) {
    throw "No submodule entries found in $GitModulesPath"
}

foreach ($entry in $submodules.Values) {
    $name = $entry.Name
    $relPath = $entry.Path
    $url = $entry.Url
    $branch = if ($entry.Branch) { $entry.Branch } else { 'main' }

    if (-not $relPath -or -not $url) {
        throw "Incomplete submodule definition for '$name' in .gitmodules"
    }

    $targetDir = Join-Path $RepoRoot $relPath

    # 无论子仓是否已存在，都写入本仓安全防护：ignore=all + update=none，防止误回退/误标脏
    if ($DryRun) {
        Write-Output "[DRY-RUN] git config submodule.$name.{url,ignore=all,update=none,active=true}"
    } else {
        Invoke-Git @('-C', $RepoRoot, 'config', "submodule.$name.url", $url) | Out-Null
        Invoke-Git @('-C', $RepoRoot, 'config', "submodule.$name.ignore", 'all') | Out-Null
        Invoke-Git @('-C', $RepoRoot, 'config', "submodule.$name.update", 'none') | Out-Null
        Invoke-Git @('-C', $RepoRoot, 'config', "submodule.$name.active", 'true') | Out-Null
    }

    if (Test-Path (Join-Path $targetDir '.git')) {
        Write-Output "[SKIP] $relPath already initialized (existing .git preserved untouched)."
        continue
    }

    # 如果占位目录已存在且非空（无 .git），拒绝覆盖以保护用户数据
    if ((Test-Path $targetDir) -and ((Get-ChildItem -Force $targetDir | Measure-Object).Count -gt 0)) {
        throw "Target directory '$targetDir' is non-empty and not a git repo; refusing to overwrite."
    }

    $cloneArgs = @('-C', $RepoRoot, 'clone', '--branch', $branch)
    if (-not $NoBlobFilter) {
        $cloneArgs += '--filter=blob:none'
    }
    $cloneArgs += @($url, $targetDir)

    if ($DryRun) {
        Write-Output ("[DRY-RUN] git " + ($cloneArgs -join ' '))
    } else {
        Write-Output "[CLONE] $relPath ($branch) <- $url"
        Invoke-Git $cloneArgs
    }
}

Write-Output ""
Write-Output "Done. Next on a new machine: install global AI skills per docs/rules/required-skills.md"
