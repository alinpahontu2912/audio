:: Define the directory where vcpkg will be installed
set VCPKG_DIR=%~dp0vcpkg

echo VCPKG_DIR: %VCPKG_DIR%

:: Check if vcpkg is already installed
if exist "%VCPKG_DIR%\vcpkg.exe" (
    echo vcpkg is already installed.
) else (
    :: Clone the vcpkg repository
    git clone https://github.com/microsoft/vcpkg.git %VCPKG_DIR%
    if %errorlevel% neq 0 (
        echo Failed to clone vcpkg repository
        exit /b %errorlevel%
    )
    dir

    echo Move to vcpkg dir
    :: Bootstrap vcpkg
    cd %VCPKG_DIR%
    dir
    call bootstrap-vcpkg.bat
    if %errorlevel% neq 0 (
        echo Failed to bootstrap vcpkg
        exit /b %errorlevel%
    )
    cd %~dp0
)

:: Verify that vcpkg can be called
%VCPKG_DIR%\vcpkg --version
if %errorlevel% neq 0 (
    echo vcpkg command failed
    exit /b %errorlevel%
)

:: Install vcpkg dependencies using the vcpkg.json manifest file
echo vcpkg installing ffmpeg
%VCPKG_DIR%\vcpkg install --feature-flags=manifests
if %errorlevel% neq 0 (
    echo Failed to install ffmpeg
    exit /b %errorlevel%
)

cd %VCPKG_DIR%
cd ..\vcpkg_installed

:: Set the path to the ffmpeg installation directory
set FFMPEG_PATH=.\arm64-windows\tools\ffmpeg

echo FFMPEG_PATH: %FFMPEG_PATH%

:: Add ffmpeg to the PATH environment variable
echo add ffmpeg to PATH
setx PATH "%PATH%;%FFMPEG_PATH%"

:: Verify ffmpeg installation
ffmpeg -version