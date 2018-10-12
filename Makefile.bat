@echo off

::begin
    setlocal
    pushd "%~dp0"
    
::baseconfig
    set VCPath=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set MyPath=%CD%
    set MAKE=%MyPath%/../gnu/make/make.exe

    for /d %%P in (.) do set ProjectName=%%~nP
    if "%ProjectName%"=="" (
        echo !!!!!!!! Empty project name !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got project name [ %ProjectName% ]
    setlocal enabledelayedexpansion
    for %%I in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do set ProjectName=!ProjectName:%%I=%%I!
    setlocal disabledelayedexpansion

    for /d %%P in ("%MyPath%\\%ProjectName%*") do set SrcPath=%%~fP
    if "%SrcPath%"=="" (
        echo !!!!!!!! Src no found !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got source folder [ %SrcPath% ]
    echo.

    cl >nul 2>&1
    if %errorlevel%==0 (
        set SUF=
    ) else (
        set SUF=^>nul
    )

::makeinclude
    echo ==== ==== ==== ==== Prepare include folder ^& files...

    call :make inc || goto end

::main
    echo.
    cl >nul 2>&1
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

    cd /d "%MyPath%"

    echo ==== ==== ==== ==== Building LIB(%PLAT%)...

    call :make lib || goto done

::ok
    endlocal
    echo.
    exit /B 0

:done
    endlocal
    echo.
    exit /B 1

:make
    if "%SUF%"=="" (
        echo.
        echo %MAKE% SrcPath=%SrcPath% %1
        echo.
    )
    %MAKE% SRCPATH="%SrcPath%" %1 %SUF% && exit /B 0
    
    echo !!!!!!!! Make Error !!!!!!!!
    exit /B 1