@echo off
setlocal enabledelayedexpansion
set folder=zeekrbackup-%secs%%year%%time:~6,2%%time:~3,2%%RANDOM%
mkdir %folder%

for /f "tokens=*" %%a in ('adb shell pm list packages') do (
    set "apk=%%a"
    set "apk=!apk:package:=!"
    
    for /f "tokens=*" %%b in ('adb shell pm path !apk!') do (
        set "path=%%b"
        set "path=!path:package:=!"
        
        echo !apk! !path!
        echo copy !path! /storage/emulated/0/!apk!.apk

        adb shell cp -r !path! /storage/emulated/0/!apk!.apk

        adb pull /storage/emulated/0/!apk!.apk %folder%/

        adb shell rm /storage/emulated/0/!apk!.apk
    )
)

endlocal
