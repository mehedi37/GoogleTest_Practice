@echo off
setlocal EnableDelayedExpansion

REM Check for MinGW in common locations
set "MINGW_PATHS=C:\msys64\ucrt64\bin;C:\msys64\mingw64\bin;C:\MinGW\bin;C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin"

for %%p in (%MINGW_PATHS:;= %) do (
    if exist "%%p\g++.exe" (
        set "MINGW_PATH=%%p"
        goto :found_mingw
    )
)

echo Error: MinGW not found! Please install MinGW or MSYS2
echo Checked paths: %MINGW_PATHS%
echo Please install from: https://www.msys2.org/
exit /b 1

:found_mingw
echo Found MinGW at: %MINGW_PATH%

REM Add MinGW to PATH
set "PATH=%MINGW_PATH%;%PATH%"

REM Ensure we're in the correct directory
cd /d "%~dp0"

REM Clean and create build directory
if exist .build\ (
    rd /s /q ".build"
)
mkdir .build
cd .build

REM Configure with CMake using explicit compiler paths
cmake -G "MinGW Makefiles" ^
    -DCMAKE_C_COMPILER="%MINGW_PATH%\gcc.exe" ^
    -DCMAKE_CXX_COMPILER="%MINGW_PATH%\g++.exe" ^
    -DCMAKE_MAKE_PROGRAM="%MINGW_PATH%\mingw32-make.exe" ^
    .. || (
    echo CMake configuration failed!
    exit /b 1
)

REM Build using mingw32-make
mingw32-make -j%NUMBER_OF_PROCESSORS% || (
    echo Build failed!
    exit /b 1
)

REM Run tests
cd tests
RunTests.exe || (
    echo Tests failed!
    exit /b 1
)

echo Build and tests completed successfully!
exit /b 0