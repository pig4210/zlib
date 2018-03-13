@echo off

:begin
    setlocal
    set MyPath=%~dp0

:config
    if "%1" == "" (
      set PLAT=x64
    ) else (
      set PLAT=x86
    )

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\zlib-1.2.11
    set GPATH=%MyPath%\\%PLAT%

    set CC=cl
    set AR=lib

:compileflags
    set CFLAGS= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /D "WIN32" /D "NDEBUG" /D "_UNICODE" /D "UNICODE" /fp:except- /errorReport:none /GF /WX /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo /Fo"%GPATH%\\"

    set MyCFLAGS= /wd"4131" /wd"4244" /wd"4996" /wd"4245" /wd"4127" /wd"4267" /D "_LIB" /D"ZLIB_WINAPI"

    if not "%1" == "" set MyCFLAGS=%MyCFLAGS% /D "_USING_V110_SDK71_"

:arflags
    set ARFLAGS= /LTCG /MACHINE:%PLAT% /ERRORREPORT:NONE /NOLOGO

:makeinclude
    set IncludePath=%MyPath%\\include
    if not "%1" == "" (
        echo ==== ==== ==== ==== Prepare include folder and files...

        rd /S /Q "%IncludePath%" >nul
        if exist "%IncludePath%" goto fail
        mkdir "%IncludePath%" >nul

        copy "%VPATH%\\zconf.h" "%IncludePath%" >nul
        copy "%VPATH%\\zlib.h"  "%IncludePath%" >nul

        echo.
    )

:start
    echo ==== ==== ==== ==== Prepare dest folder(%PLAT%)...

    rd /S /Q "%GPATH%" >nul
    if exist "%GPATH%" goto fail
    mkdir "%GPATH%" >nul

    echo ==== ==== ==== ==== Prepare environment(%PLAT%)...

    cd /d %VCPath%
    if "%1" == "" (
        call vcvarsall.bat amd64 >nul
    ) else (
        call vcvarsall.bat x86 >nul
    )

    cd /d %VPATH%

:lib
    echo ==== ==== ==== ==== Building LIB(%PLAT%)...

    %CC% %CFLAGS% %MyCFLAGS% /Fd"%GPATH%\\zlib.pdb" "%VPATH%\\*.c" >nul
    if not %errorlevel%==0 goto compile_error

    %AR% %ARFLAGS% /OUT:"%GPATH%\\zlib.lib" "%GPATH%\\*.obj" >nul
    if not %errorlevel%==0 goto link_error

    del "%GPATH%\\*.obj" >nul

:done
    echo.
    endlocal

    if "%1" == "" (
        cmd /C %~f0 x86
    ) else (
        exit /B 0
    )

    echo done.
    goto end

:compile_error
    echo !!!!!!!!Compile error!!!!!!!!
    goto end

:link_error
    echo !!!!!!!!Link error!!!!!!!!
    goto end

:fail
    echo !!!!!!!!Fail!!!!!!!!
    goto end

:end
    pause >nul