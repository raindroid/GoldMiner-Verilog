@echo off
echo Remeber to put " 
set /p c="Enter push comment: "
echo commiting
git add -A
git commit -m %c%
echo uploading
git push -u origin master
echo All done!
pause
