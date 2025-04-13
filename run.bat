@echo off
setlocal EnableDelayedExpansion

REM Enable virtual terminal processing for ANSI colors (Windows 10+)
reg query HKCU\Console /v VirtualTerminalLevel >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
)

REM Method 1: Use the ASCII escape character directly (works in PowerShell)
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

REM Define colors with proper escape sequence
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "BLUE=%ESC%[94m"
set "CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "RESET=%ESC%[0m"

REM Parse command line arguments
set CLEAN_BUILD=0
set TEST_FILTER=

if "%1"=="--clean" set CLEAN_BUILD=1
if "%1"=="--help" goto show_help
if "%1"=="--list" set LIST_TESTS=1

echo %CYAN%GoogleTest Runner for Windows%RESET%
echo.

REM Check for MinGW in common locations
set "MINGW_PATHS=C:\msys64\ucrt64\bin;C:\msys64\mingw64\bin;C:\MinGW\bin;C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin"

for %%p in (%MINGW_PATHS:;= %) do (
    if exist "%%p\g++.exe" (
        set "MINGW_PATH=%%p"
        goto :found_mingw
    )
)

echo %RED%Error: MinGW not found! Please install MinGW or MSYS2%RESET%
echo Checked paths: %MINGW_PATHS%
echo Please install from: https://www.msys2.org/
exit /b 1

:found_mingw
echo %GREEN%Found MinGW at: %MINGW_PATH%%RESET%
echo.

REM Add MinGW to PATH
set "PATH=%MINGW_PATH%;%PATH%"

REM Ensure we're in the correct directory
cd /d "%~dp0"

REM Clean build directory only if requested
if %CLEAN_BUILD%==1 (
    echo %YELLOW%Performing clean build...%RESET%
    if exist .build\ (
        rd /s /q ".build"
    )
    mkdir .build
) else (
    if not exist .build\ (
        echo %YELLOW%Creating build directory...%RESET%
        mkdir .build
    )
)
cd .build

REM Configure with CMake using explicit compiler paths
echo %BLUE%Configuring with CMake...%RESET%
cmake -G "MinGW Makefiles" ^
    -DCMAKE_C_COMPILER="%MINGW_PATH%\gcc.exe" ^
    -DCMAKE_CXX_COMPILER="%MINGW_PATH%\g++.exe" ^
    -DCMAKE_MAKE_PROGRAM="%MINGW_PATH%\mingw32-make.exe" ^
    .. || (
    echo %RED%CMake configuration failed!%RESET%
    exit /b 1
)

REM Build using mingw32-make
echo %BLUE%Building project...%RESET%
mingw32-make -j%NUMBER_OF_PROCESSORS% || (
    echo %RED%Build failed!%RESET%
    exit /b 1
)

cd tests

REM Handle test listing
if defined LIST_TESTS (
    echo %YELLOW%Available tests:%RESET%
    RunTests.exe --gtest_list_tests
    exit /b 0
)

REM Using a hard-coded menu approach instead of dynamic parsing to avoid syntax issues
echo %YELLOW%Available tests:%RESET%
echo %CYAN%0.%RESET% Run ALL tests
echo %CYAN%1.%RESET% BaseTest.TriangleTypeTest
echo %CYAN%2.%RESET% BaseTest.MathUtilsTest
echo %CYAN%3.%RESET% BaseTest.TestIsPrime

echo.
set /p TEST_CHOICE="%YELLOW%Enter test number to run (0 for all tests):%RESET% "

if "%TEST_CHOICE%"=="0" (
    set "TEST_FILTER=--gtest_filter=*"
) else if "%TEST_CHOICE%"=="1" (
    set "TEST_FILTER=--gtest_filter=BaseTest.TriangleTypeTest"
) else if "%TEST_CHOICE%"=="2" (
    set "TEST_FILTER=--gtest_filter=BaseTest.MathUtilsTest"
) else if "%TEST_CHOICE%"=="3" (
    set "TEST_FILTER=--gtest_filter=BaseTest.TestIsPrime"
) else (
    echo %RED%Invalid selection. Running all tests.%RESET%
    set "TEST_FILTER=--gtest_filter=*"
)

REM Run tests with the chosen filter
echo %BLUE%Running tests with filter: %TEST_FILTER%%RESET%
RunTests.exe %TEST_FILTER% || (
    echo %RED%Tests failed!%RESET%
    exit /b 1
)

echo %GREEN%Build and tests completed successfully!%RESET%
exit /b 0

:show_help
echo.
echo %CYAN%GoogleTest Runner for Windows - Usage:%RESET%
echo.
echo   %WHITE%run.bat [options]%RESET%
echo.
echo %CYAN%Options:%RESET%
echo   %WHITE%--clean%RESET% Perform a clean build (delete .build folder)
echo   %WHITE%--list %RESET% List all available tests
echo   %WHITE%--help %RESET% Show this help message
echo.
exit /b 0