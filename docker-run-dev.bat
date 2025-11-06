@echo off
REM ================================
REM Run Biblioteca API with H2 (Dev Mode)
REM ================================

echo.
echo ====================================
echo   Starting Biblioteca API - DEV Mode
echo   Database: H2 (In-Memory)
echo ====================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker nao esta instalado ou nao esta no PATH
    pause
    exit /b 1
)

REM Configuration
set IMAGE_NAME=biblioteca-api:latest
set CONTAINER_NAME=biblioteca-api-dev
set PORT=8080

REM Stop and remove existing container if running
echo [INFO] Verificando containers existentes...
docker ps -a --filter "name=%CONTAINER_NAME%" --format "{{.Names}}" | findstr /C:"%CONTAINER_NAME%" >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Parando e removendo container existente...
    docker stop %CONTAINER_NAME% >nul 2>&1
    docker rm %CONTAINER_NAME% >nul 2>&1
)

REM Check if image exists
docker images %IMAGE_NAME% --format "{{.Repository}}:{{.Tag}}" | findstr /C:"%IMAGE_NAME%" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Imagem %IMAGE_NAME% nao encontrada
    echo Execute primeiro: docker-build.bat
    pause
    exit /b 1
)

echo.
echo [INFO] Iniciando container...
echo.

REM Run the container
docker run -d ^
    --name %CONTAINER_NAME% ^
    -p %PORT%:8080 ^
    -e SPRING_PROFILES_ACTIVE=dev ^
    %IMAGE_NAME%

if errorlevel 1 (
    echo.
    echo [ERROR] Falha ao iniciar o container
    pause
    exit /b 1
)

echo.
echo ====================================
echo   Aplicacao Iniciada com Sucesso!
echo ====================================
echo.
echo Container: %CONTAINER_NAME%
echo Porta: %PORT%
echo Profile: DEV (H2 Database)
echo.
echo Acessos:
echo   - API REST: http://localhost:%PORT%/api/autores
echo   - H2 Console: http://localhost:%PORT%/h2-console
echo.
echo H2 Console Login:
echo   - JDBC URL: jdbc:h2:mem:biblioteca
echo   - Username: sa
echo   - Password: (vazio)
echo.
echo Comandos uteis:
echo   - Ver logs: docker logs -f %CONTAINER_NAME%
echo   - Parar: docker stop %CONTAINER_NAME%
echo   - Remover: docker rm %CONTAINER_NAME%
echo.

REM Wait a few seconds and show logs
echo [INFO] Aguardando inicializacao... (10 segundos)
timeout /t 10 /nobreak >nul

echo.
echo [INFO] Ultimas linhas do log:
echo ====================================
docker logs --tail 20 %CONTAINER_NAME%

echo.
echo ====================================
echo.
echo Pressione qualquer tecla para sair (container continuara rodando)
pause >nul

