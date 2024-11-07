@echo on

:: install Ffmpeg
call ffmpeg_install.bat
if %errorlevel% neq 0 (
    echo Failed to install ffmpeg
    exit /b %errorlevel%
)

:: Create python virtual environment
python -m venv venv
echo * > ./venv/.gitignore 
call venv\Scripts\activate

:: activate arm64 environment TODO ->replace visual studio
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" arm64

:: TODO replace with link to wheel
pip install C:\Users\spahontu\Downloads\pytorch-wheel_test\torch-2.6.0a0+git0d0b838-cp312-cp312-win_arm64.whl

cd ..\..\
:: isntall dependencies
pip install -r requirements.txt

:: set path to ffmpeg 

set FFMPEG_INSTALLATION_DIR=%~dp0..\vcpkg

cd FFMPEG_INSTALLATION_DIR

dir

set FFMPEG_ROOT=FFMPEG_INSTALLATION_DIR

::start build
python setup.py install

:: test torchaudio
python -c "import torchaudio; available_backends = torchaudio.list_audio_backends(); print('Available backends:', available_backends)"