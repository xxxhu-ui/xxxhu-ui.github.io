# 像素肉鸽 · 一键上传到 GitHub Pages
Set-Location -LiteralPath $PSScriptRoot

function Line { Write-Host ("-" * 50) -ForegroundColor DarkGray }

Write-Host ""
Line
Write-Host "        像素肉鸽 · 上传到 GitHub" -ForegroundColor Cyan
Line
Write-Host ""
Write-Host "先做一件事（只在浏览器里点）：" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. 打开  https://github.com/new"
Write-Host "  2. Repository name 随便起，建议  pixel-rogue"
Write-Host "  3. 选  Public"
Write-Host "  4. 下面三个勾（Add README / .gitignore / license）"
Write-Host "     一个都【不要】勾"
Write-Host "  5. 点  Create repository"
Write-Host ""

$null = Read-Host "弄好了就按回车继续"

Write-Host ""
$user = Read-Host "你的 GitHub 用户名"
$repo = Read-Host "你刚建的仓库名（例如 pixel-rogue）"

if ([string]::IsNullOrWhiteSpace($user) -or [string]::IsNullOrWhiteSpace($repo)) {
    Write-Host ""
    Write-Host "用户名或仓库名不能空着。" -ForegroundColor Red
    $null = Read-Host "按回车关闭"
    exit 1
}

$url = "https://github.com/$user/$repo.git"

# 如果已经有 origin，先删掉再重加
$remotes = git remote 2>&1
if ($remotes -contains 'origin') {
    git remote remove origin 2>&1 | Out-Null
}
git remote add origin $url 2>&1 | Out-Null
git branch -M main 2>&1 | Out-Null

Write-Host ""
Line
Write-Host "推送目标：$url" -ForegroundColor Green
Write-Host "第一次推送会弹出浏览器，让你登录 / 授权 GitHub" -ForegroundColor Yellow
Line
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Line
    Write-Host "推送成功！" -ForegroundColor Green
    Line
    Write-Host ""
    Write-Host "最后一步，还是只在网页上点（一次性）：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. 打开  https://github.com/$user/$repo/settings/pages"
    Write-Host "  2. Source 选  Deploy from a branch"
    Write-Host "  3. Branch 选  main    目录选  / (root)     点 Save"
    Write-Host "  4. 等 1 分钟左右，你的网址就是："
    Write-Host ""
    Write-Host "        https://$user.github.io/$repo/" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  这个网址是永久的，关机也能访问。" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "推送失败。最常见的原因：" -ForegroundColor Red
    Write-Host "  · 仓库名打错了（要和你刚建的那个完全一致）"
    Write-Host "  · 建仓库的时候勾了 Add a README（那样远程会不为空）"
    Write-Host "  · GitHub 登录没完成"
    Write-Host ""
    Write-Host "改完再双击本脚本跑一次就行。" -ForegroundColor Yellow
}

Write-Host ""
$null = Read-Host "按回车关闭"
