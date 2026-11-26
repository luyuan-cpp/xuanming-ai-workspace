#Requires -Version 5.1
<#
.SYNOPSIS
    scripts/bootstrap.ps1 自检（验证真实 .gitmodules 解析、克隆命令生成、本地安全配置写入、已有子仓跳过与非空杂目录保护）。
.PARAMETER TestClone
    可选：额外执行真实本地 git clone（依赖本机允许 git-upload-pack/sh.exe）。
#>
param([switch]$TestClone)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Bootstrap = Join-Path $PSScriptRoot 'bootstrap.ps1'

function Assert-True([bool]$Cond, [string]$Msg) {
    if (-not $Cond) { throw "ASSERT FAILED: $Msg" }
}

# 1. 对真实总仓跑 -DryRun，确认解析到全部 5 个子仓且不改动任何内容
$dryOut = & $Bootstrap -DryRun
Assert-True ($LASTEXITCODE -eq 0) "DryRun exited with $LASTEXITCODE"
$dryText = ($dryOut -join "`n")
foreach ($expected in @('mmorpg-client', 'xuanming-server-mmo-cpp', 'xuanming-server-mmo', 'xuanming-server-mmo-python', 'xuanming-server')) {
    Assert-True ($dryText -match [regex]::Escape("submodule.$expected.")) "Missing submodule config check for $expected"
    Assert-True ($dryText -match [regex]::Escape("[SKIP] $expected")) "Expected existing repo $expected to be skipped"
}

# 2. 临时工作区测试：命令生成、真实本地 config 写入、已有子仓跳过、非空杂目录拦截
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("xm-bootstrap-test-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
try {
    $seedDir = Join-Path $tmp 'seed'
    $workDir = Join-Path $tmp 'workspace'
    New-Item -ItemType Directory -Force $seedDir, (Join-Path $workDir 'scripts'), (Join-Path $workDir 'sub-a') | Out-Null

    git -C $workDir init -b main | Out-Null
    Copy-Item $Bootstrap (Join-Path $workDir 'scripts\bootstrap.ps1')
    $seedUrl = ($seedDir -replace '\\', '\\')
    Set-Content (Join-Path $workDir '.gitmodules') @"
[submodule "sub-a"]
	path = sub-a
	url = $seedUrl
	branch = main
	ignore = all
	update = none
"@

    # 2a. 空占位目录 -DryRun 验证克隆命令（含与不含 --filter=blob:none）
    $planWithFilter = (& (Join-Path $workDir 'scripts\bootstrap.ps1') -DryRun) -join "`n"
    Assert-True ($planWithFilter -match 'clone --branch main --filter=blob:none ') "Expected --filter=blob:none in clone command"
    $planNoFilter = (& (Join-Path $workDir 'scripts\bootstrap.ps1') -DryRun -NoBlobFilter) -join "`n"
    Assert-True ($planNoFilter -match 'clone --branch main ' -and $planNoFilter -notmatch '--filter=blob:none') "Expected -NoBlobFilter to omit blob filter"

    # 2b. 已有 .git 目录时，真实运行写入安全保护配置并完整保留脏文件
    git -C (Join-Path $workDir 'sub-a') init -b main | Out-Null
    Set-Content (Join-Path $workDir 'sub-a\hello.txt') 'local-dirty'
    $out2 = (& (Join-Path $workDir 'scripts\bootstrap.ps1')) -join "`n"
    Assert-True ($out2 -match '\[SKIP\] sub-a') "Existing repo was not skipped"
    Assert-True ((Get-Content (Join-Path $workDir 'sub-a\hello.txt') -Raw).Trim() -eq 'local-dirty') "Existing dirty file was overwritten"
    Assert-True ((git -C $workDir config submodule.sub-a.ignore).Trim() -eq 'all') "ignore=all not written to .git/config"
    Assert-True ((git -C $workDir config submodule.sub-a.update).Trim() -eq 'none') "update=none not written to .git/config"
    Assert-True ((git -C $workDir config submodule.sub-a.active).Trim() -eq 'true') "active=true not written to .git/config"

    # 2c. 非空且无 .git 的目录必须报错拒绝覆盖
    Remove-Item -Recurse -Force (Join-Path $workDir 'sub-a')
    New-Item -ItemType Directory -Force (Join-Path $workDir 'sub-a') | Out-Null
    Set-Content (Join-Path $workDir 'sub-a\keep.txt') 'important'
    $threw = $false
    try {
        & (Join-Path $workDir 'scripts\bootstrap.ps1') -NoBlobFilter | Out-Null
    } catch {
        $threw = $_.Exception.Message -match 'non-empty'
    }
    Assert-True $threw "Expected refusal on non-empty non-git directory"
    Assert-True (Test-Path (Join-Path $workDir 'sub-a\keep.txt')) "User file in non-empty directory was deleted"

    # 2d. 可选：真实本地 git clone 验证
    if ($TestClone) {
        git -C $seedDir init -b main | Out-Null
        git -C $seedDir config user.name test
        git -C $seedDir config user.email test@example.com
        Set-Content (Join-Path $seedDir 'hello.txt') 'ok'
        git -C $seedDir add hello.txt | Out-Null
        git -C $seedDir commit -m 'init' | Out-Null
        Remove-Item -Recurse -Force (Join-Path $workDir 'sub-a')
        New-Item -ItemType Directory -Force (Join-Path $workDir 'sub-a') | Out-Null
        & (Join-Path $workDir 'scripts\bootstrap.ps1') -NoBlobFilter | Out-Null
        Assert-True (Test-Path (Join-Path $workDir 'sub-a\.git')) "sub-a was not cloned"
        Assert-True ((git -C (Join-Path $workDir 'sub-a') branch --show-current).Trim() -eq 'main') "sub-a is not on main"
    }

    Write-Output "ALL BOOTSTRAP SELF-CHECKS PASSED."
} finally {
    if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
}
