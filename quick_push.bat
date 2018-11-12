@echo off
set /p c="Enter push comment: "
git add -A
git commit -m %c%
git push -u origin master
echo All done!
pause
