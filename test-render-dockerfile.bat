@echo off
REM ================================
REM Test Render Dockerfile Locally
REM ================================

echo.
echo ====================================
echo   Testing Render Dockerfile
echo ====================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker nao esta instalado
    pause
    exit /b 1
)

set IMAGE_NAME=biblioteca-api:render
set CONTAINER_NAME=biblioteca-api-render-test

echo [INFO] Building with Dockerfile.render...
echo.

REM Build the image using Dockerfile.render
docker build -f Dockerfile.render -t %IMAGE_NAME% .

if errorlevel 1 (
    echo.
    echo [ERROR] Build falhou
    echo.
    echo Possiveis causas:
    echo   1. Erro de dependencias Maven (502)
    echo   2. Erro no codigo fonte
    echo   3. Falta de recursos
    echo.
    echo Solucoes:
    echo   1. Aguarde alguns minutos e tente novamente
    echo   2. Verifique sua conexao com internet
    echo   3. Execute: docker build -f Dockerfile.render -t biblioteca-api:render . --no-cache
    echo.
    pause
    exit /b 1
)

echo.
echo ====================================
echo   Build Successful!
echo ====================================
echo.

REM Stop and remove existing test container
docker stop %CONTAINER_NAME% >nul 2>&1
docker rm %CONTAINER_NAME% >nul 2>&1

echo [INFO] Starting container...
echo.

REM Run the container
docker run -d ^
    --name %CONTAINER_NAME% ^
    -p 8080:8080 ^
    -e PORT=8080 ^
    -e SPRING_PROFILES_ACTIVE=dev ^
    %IMAGE_NAME%

if errorlevel 1 (
    echo [ERROR] Falha ao iniciar container
    pause
    exit /b 1
)

echo.
echo ====================================
echo   Container Started!
echo ====================================
echo.
echo Container: %CONTAINER_NAME%
echo Image: %IMAGE_NAME%
echo Port: 8080
echo.
echo Aguardando inicializacao... (15 segundos)
timeout /t 15 /nobreak >nul

echo.
echo [INFO] Ultimas linhas do log:
echo ====================================
docker logs --tail 30 %CONTAINER_NAME%

echo.
echo ====================================
echo.
echo Testes:
echo   curl http://localhost:8080/api/autores
echo   http://localhost:8080/h2-console
echo.
echo Comandos uteis:
echo   Ver logs: docker logs -f %CONTAINER_NAME%
echo   Parar: docker stop %CONTAINER_NAME%
echo   Remover: docker rm %CONTAINER_NAME%
echo.
echo Se funcionar aqui, deve funcionar no Render!
echo.

pause

