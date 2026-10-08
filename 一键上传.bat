@echo off
title 像素肉鸽 - 一键上传到 GitHub
cls
echo.
echo   ============================================
echo            像素肉鸽 - 一键上传到 GitHub
echo   ============================================
echo.
echo   跟着提示走就行。第一次会弹浏览器让你登录 GitHub。
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0upload.ps1"
if errorlevel 1 (
  echo.
  echo   --------------------------------------------------
  echo   脚本异常退出了。
  echo   把上面那些红字截图发给我。
  echo   --------------------------------------------------
  pause
)
