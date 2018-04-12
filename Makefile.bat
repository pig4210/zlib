@echo off

::begin
    setlocal
    pushd "%~dp0"
    
::baseconfig
    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set MyPath=%CD%

    for /d %%P in (.) do set ProjectName=%%~nP
    if "%ProjectName%"=="" (
        echo !!!!!!!! Empty project name !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got project name [ %ProjectName% ]
    setlocal enabledelayedexpansion
    for %%I in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do set ProjectName=!ProjectName:%%I=%%I!
    setlocal disabledelayedexpansion

    for /d %%P in ("%MyPath%\\%ProjectName%*") do set VPATH=%%~fP
    if "%VPATH%"=="" (
        echo !!!!!!!! Src no found !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got source folder [ %VPATH% ]
    echo.

::biuldconfig
    set CC=cl
    set AR=lib

    set CFLAGS=/c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo

    set ARFLAGS=/LTCG /ERRORREPORT:NONE /NOLOGO

::makeinclude
    echo ==== ==== ==== ==== Prepare include folder ^& files...
    set IncludePath=%MyPath%\\include

    if exist "%IncludePath%" rd /s /q "%IncludePath%" >nul
    if exist "%IncludePath%" (
        echo !!!!!!!! Can't clear include folder !!!!!!!!
        goto end
    )

    md "%IncludePath%" >nul

    copy "%VPATH%\\zconf.h"     "%IncludePath%" >nul
    copy "%VPATH%\\zlib.h"      "%IncludePath%" >nul

    echo.

::main
    echo.
    %CC% >nul 2>&1
    if %errorlevel%==0 (
        echo ==== ==== ==== ==== Build %Platform% ^& processing ==== ==== ==== ==== 
        echo.
        call :do || goto end
    ) else (
        echo ==== ==== ==== ==== Build x64 ^& x86 by silence ==== ==== ==== ==== 
        echo.
        call :do x64 || goto end
        call :do x86 || goto end
    )

    popd
    endlocal
    echo.
    echo ==== ==== ==== ==== Done ==== ==== ==== ====
    cl >nul 2>&1 || pause >nul
    exit /B 0

:end
    popd
    endlocal
    echo.
    echo ==== ==== ==== ==== Done ==== ==== ==== ====
    cl >nul 2>&1 || pause >nul
    exit /B 1

:do
    setlocal

    if "%1"=="" (
        set PLAT=%Platform%
        set SUF=
    ) else (
        set PLAT=%1
        set SUF=^>nul
    )
    if "%PLAT%"=="" (
        echo !!!!!!!! Need arg with x64/x86 !!!!!!!!
        goto done
    )
    set GPATH=%MyPath%\\%PLAT%

    echo.

::prepare
    if not "%1"=="" (
        echo ==== ==== ==== ==== Prepare environment^(%PLAT%^)...
        
        cd /d "%VCPath%"
        if "%PLAT%"=="x64" (
            call vcvarsall.bat amd64 >nul
        ) else (
            call vcvarsall.bat x86 >nul
        )
    )

    echo ==== ==== ==== ==== Prepare dest folder(%PLAT%)...

    if exist "%GPATH%" rd /s /q "%GPATH%" >nul
    if exist "%GPATH%" (
        echo !!!!!!!! Can't clear dest folder !!!!!!!!
        goto done
    )
    md "%GPATH%" >nul

    echo.

    cd /d "%VPATH%"

::localbuildconfig
    set CFLAGS=%CFLAGS% /wd"4131" /wd"4244" /wd"4996" /wd"4245" /wd"4127" /wd"4267" /D "_LIB" /D"ZLIB_WINAPI"
    if "%PLAT%" == "x86" set CFLAGS=%CFLAGS% /D "_USING_V110_SDK71_"

    set ARFLAGS=%ARFLAGS% /MACHINE:%PLAT%

::lib
    set CIN="%VPATH%\\*.c"

    set COUT=/Fo"%GPATH%\\" /Fd"%GPATH%\\%ProjectName%.pdb"

    set MyCFlags=

    set ARIN="%GPATH%\\*.obj"

    set AROUT=/OUT:"%GPATH%\\%ProjectName%.lib"
    
    set MyARFlags=

    echo ==== ==== ==== ==== Building LIB(%PLAT%)...

    call :compile || goto done
    call :ar || goto done

::clear
    del "%GPATH%\\*.obj" >nul

::ok
    endlocal
    echo.
    exit /B 0

:done
    endlocal
    echo.
    exit /B 1

:compile
    if "%SUF%"=="" (
        echo.
        echo %CC% %CFLAGS% %MyCFlags% %COUT% %CIN%
        echo.
    )
    %CC% %CFLAGS% %MyCFlags% %COUT% %CIN% %SUF% && exit /B 0
    
    echo !!!!!!!! Compile Error !!!!!!!!
    exit /B 1

:ar
    if "%SUF%"=="" (
        echo.
        echo %AR% %ARFLAGS% %MyARFlags% %AROUT% %ARIN%
        echo.
    )
    %AR% %ARFLAGS% %MyARFlags% %AROUT% %ARIN% %SUF% && exit /B 0

    echo !!!!!!!! AR Error !!!!!!!!
    exit /B 1