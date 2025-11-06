@echo off
echo ================================================
echo   Biblioteca API - Spring Boot com Docker
echo ================================================
echo.
echo Verificando Docker...
docker ps >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [AVISO] Docker nao parece estar rodando.
    echo Executando docker-compose up...
    docker-compose -f docker-compose-pgadmin.yml up -d
    echo Aguardando banco de dados...
    timeout /t 8 /nobreak >nul
)
echo.
echo ================================================
echo   Iniciando Spring Boot (Profile: dev)
echo ================================================
echo.
echo   API: http://localhost:8080/api
echo   pgAdmin: http://localhost:8082
echo.
echo ================================================
echo.
call mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"

