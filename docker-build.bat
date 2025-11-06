@echo off
REM ================================
REM Build Docker Image - Biblioteca API
REM ================================

echo.
echo ====================================
echo   Building Biblioteca API Docker Image
echo ====================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker nao esta instalado ou nao esta no PATH
    echo Por favor, instale o Docker Desktop: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Set image name and tag
set IMAGE_NAME=biblioteca-api
set IMAGE_TAG=latest

echo [INFO] Building image: %IMAGE_NAME%:%IMAGE_TAG%
echo.

REM Build the Docker image
docker build -t %IMAGE_NAME%:%IMAGE_TAG% .

if errorlevel 1 (
    echo.
    echo [ERROR] Falha ao construir a imagem Docker
    pause
    exit /b 1
)

echo.
echo ====================================
echo   Build Concluido com Sucesso!
echo ====================================
echo.
echo Imagem criada: %IMAGE_NAME%:%IMAGE_TAG%
echo.
echo Proximos passos:
echo   1. Execute: docker-run-dev.bat (para rodar com H2)
echo   2. Execute: docker-run-postgres.bat (para rodar com PostgreSQL)
echo   3. Ou use: docker run -p 8080:8080 %IMAGE_NAME%:%IMAGE_TAG%
echo.

pause

