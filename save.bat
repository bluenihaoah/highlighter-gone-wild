@echo off
cd /d "%~dp0"
(
  echo === %date% %time% ===
  if not exist .git git init -b main
  git config user.name >nul 2>&1 || git config user.name "Blue"
  git config user.email >nul 2>&1 || git config user.email "bluenihaoah@users.noreply.github.com"
  git add -A
  git commit -F commit-msg.txt
  git remote get-url origin >nul 2>&1
  if errorlevel 1 (
    gh repo view highlighter-gone-wild >nul 2>&1
    if errorlevel 1 (
      gh repo create highlighter-gone-wild --public --description "A class whiteboard for Mandarin teachers: live pinyin/zhuyin, highlighters, dictionary, PDF" --source . --remote origin
    ) else (
      for /f "delims=" %%u in ('gh repo view highlighter-gone-wild --json url -q .url') do git remote add origin %%u.git
    )
  )
  git push -u origin main
  gh api repos/{owner}/{repo}/pages >nul 2>&1
  if errorlevel 1 gh api -X POST repos/{owner}/{repo}/pages -f "source[branch]=main" -f "source[path]=/"
  echo.
  echo Website: https://bluenihaoah.github.io/highlighter-gone-wild/
  echo === DONE ===
) > save-log.txt 2>&1
