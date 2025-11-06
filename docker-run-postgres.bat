@echo off
REM ================================
REM Run Biblioteca API with PostgreSQL
REM ================================

echo.
echo ====================================
echo   Starting Biblioteca API with PostgreSQL
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
set CONTAINER_NAME=biblioteca-api
set POSTGRES_CONTAINER=biblioteca-postgres
set NETWORK_NAME=biblioteca-network
set PORT=8080
set POSTGRES_PORT=5432

REM Create network if it doesn't exist
echo [INFO] Verificando rede Docker...
docker network inspect %NETWORK_NAME% >nul 2>&1
if errorlevel 1 (
    echo [INFO] Criando rede: %NETWORK_NAME%
    docker network create %NETWORK_NAME%
)

REM Check if PostgreSQL is already running
docker ps --filter "name=%POSTGRES_CONTAINER%" --format "{{.Names}}" | findstr /C:"%POSTGRES_CONTAINER%" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Iniciando PostgreSQL...
    docker run -d ^
        --name %POSTGRES_CONTAINER% ^
        --network %NETWORK_NAME% ^
        -e POSTGRES_DB=biblioteca ^
        -e POSTGRES_USER=postgres ^
        -e POSTGRES_PASSWORD=postgres ^
        -p %POSTGRES_PORT%:5432 ^
        postgres:15-alpine
    
    echo [INFO] Aguardando PostgreSQL inicializar... (15 segundos)
    timeout /t 15 /nobreak >nul
) else (
    echo [INFO] PostgreSQL ja esta rodando
)

REM Stop and remove existing app container if running
docker ps -a --filter "name=%CONTAINER_NAME%" --format "{{.Names}}" | findstr /C:"%CONTAINER_NAME%" >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Parando e removendo container existente da aplicacao...
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
echo [INFO] Iniciando aplicacao...
echo.

REM Run the application container
docker run -d ^
    --name %CONTAINER_NAME% ^
    --network %NETWORK_NAME% ^
    -p %PORT%:8080 ^
    -e SPRING_DATASOURCE_URL=jdbc:postgresql://%POSTGRES_CONTAINER%:5432/biblioteca ^
    -e SPRING_DATASOURCE_USERNAME=postgres ^
    -e SPRING_DATASOURCE_PASSWORD=postgres ^
    -e SPRING_JPA_HIBERNATE_DDL_AUTO=update ^
    %IMAGE_NAME%

if errorlevel 1 (
    echo.
    echo [ERROR] Falha ao iniciar o container da aplicacao
    pause
    exit /b 1
)

echo.
echo ====================================
echo   Aplicacao Iniciada com Sucesso!
echo ====================================
echo.
echo Containers:
echo   - App: %CONTAINER_NAME%
echo   - Database: %POSTGRES_CONTAINER%
echo   - Network: %NETWORK_NAME%
echo.
echo Acessos:
echo   - API REST: http://localhost:%PORT%/api/autores
echo   - PostgreSQL: localhost:%POSTGRES_PORT%
echo.
echo Database Info:
echo   - Database: biblioteca
echo   - Username: postgres
echo   - Password: postgres
echo.
echo Comandos uteis:
echo   - Ver logs app: docker logs -f %CONTAINER_NAME%
echo   - Ver logs db: docker logs -f %POSTGRES_CONTAINER%
echo   - Parar tudo: docker stop %CONTAINER_NAME% %POSTGRES_CONTAINER%
echo.

REM Wait and show logs
echo [INFO] Aguardando inicializacao... (15 segundos)
timeout /t 15 /nobreak >nul

echo.
echo [INFO] Ultimas linhas do log:
echo ====================================
docker logs --tail 20 %CONTAINER_NAME%

echo.
echo ====================================
echo.
echo Pressione qualquer tecla para sair (containers continuarao rodando)
pause >nul

