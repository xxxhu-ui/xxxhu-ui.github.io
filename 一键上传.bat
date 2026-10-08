@echo off
title Pixel Rogue - Upload to GitHub
cls
echo.
echo   ==============================================
echo          Pixel Rogue - Upload to GitHub
echo   ==============================================
echo.
echo   The Chinese prompts will show up below.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0upload.ps1"
if errorlevel 1 (
  echo.
  echo   --------------------------------------------------
  echo   The script exited with an error.
  echo   Copy the red text above and send it to me.
  echo   --------------------------------------------------
  pause
)
