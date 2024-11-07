@echo on

:: Call the install_vcpkg.bat script to ensure vcpkg is installed and bootstrapped
call vcpkg_install.bat
if %errorlevel% neq 0 (
    echo Failed to install or bootstrap vcpkg
    exit /b %errorlevel%
)

:: Define the directory where vcpkg is installed
set VCPKG_DIR=%~dp0vcpkg

:: Install vcpkg dependencies using the vcpkg.json manifest file
echo vcpkg installing ffmpeg
%VCPKG_DIR%\vcpkg install --feature-flags=manifests
if %errorlevel% neq 0 (
    echo Failed to install ffmpeg
    exit /b %errorlevel%
)

:: Set the path to the ffmpeg installation directory
set FFMPEG_PATH=%VCPKG_DIR%\installed\arm64-windows\tools\ffmpeg

:: Add ffmpeg to the PATH environment variable
echo add ffmpeg to PATH
setx PATH "%PATH%;%FFMPEG_PATH%"

:: Verify ffmpeg installation
ffmpeg -version