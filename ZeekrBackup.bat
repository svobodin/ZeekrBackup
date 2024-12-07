@echo off
setlocal enabledelayedexpansion
set folder=zeekrbackup-%RANDOM%
mkdir %folder%

:: Получаем список пакетов
for /f "tokens=*" %%a in ('adb shell pm list packages') do (
    set "apk=%%a"
    set "apk=!apk:package:=!"

    :: Получаем путь к APK
    for /f "tokens=*" %%b in ('adb shell pm path !apk!') do (
        set "path=%%b"
        set "path=!path:package:=!"

        :: Получаем имя приложения
        for /f "tokens=*" %%c in ('adb shell dumpsys package !apk! ^| find "applicationInfo"') do (
            set "app_name=%%c"
            set "app_name=!app_name:*applicationInfo=!"
            set "app_name=!app_name:~1!"  :: Удаляем пробел в начале
            set "app_name=!app_name:~0,-1!"  :: Удаляем пробел в конце
        )

        echo !apk! !path!
        echo copy !path! /storage/emulated/0/!app_name!.apk

        adb shell cp -r !path! /storage/emulated/0/!app_name!.apk

        adb pull /storage/emulated/0/!app_name!.apk %folder%/

        adb shell rm /storage/emulated/0/!app_name!.apk
    )
)

endlocal
