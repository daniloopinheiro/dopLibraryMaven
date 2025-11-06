@echo off
REM ================================
REM Stop Biblioteca API Docker Containers
REM ================================

echo.
echo ====================================
echo   Stopping Biblioteca API Containers
echo ====================================
echo.

REM Container names
set APP_CONTAINER=biblioteca-api
set APP_DEV_CONTAINER=biblioteca-api-dev
set POSTGRES_CONTAINER=biblioteca-postgres

echo [INFO] Parando containers...
echo.

REM Stop app container (prod)
docker ps --filter "name=%APP_CONTAINER%" --format "{{.Names}}" | findstr /C:"%APP_CONTAINER%" >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Parando %APP_CONTAINER%...
    docker stop %APP_CONTAINER%
    docker rm %APP_CONTAINER%
)

REM Stop app container (dev)
docker ps --filter "name=%APP_DEV_CONTAINER%" --format "{{.Names}}" | findstr /C:"%APP_DEV_CONTAINER%" >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Parando %APP_DEV_CONTAINER%...
    docker stop %APP_DEV_CONTAINER%
    docker rm %APP_DEV_CONTAINER%
)

REM Stop PostgreSQL
docker ps --filter "name=%POSTGRES_CONTAINER%" --format "{{.Names}}" | findstr /C:"%POSTGRES_CONTAINER%" >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Parando %POSTGRES_CONTAINER%...
    docker stop %POSTGRES_CONTAINER%
    docker rm %POSTGRES_CONTAINER%
)

echo.
echo ====================================
echo   Containers Parados
echo ====================================
echo.

REM Show remaining containers
echo [INFO] Containers ativos:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo Pressione qualquer tecla para sair...
pause >nul

