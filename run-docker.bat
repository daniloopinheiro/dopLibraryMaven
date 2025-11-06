@echo off
echo ================================================
echo   Biblioteca API - Executando com Docker
echo ================================================
echo.
echo [1/2] Iniciando PostgreSQL + pgAdmin (Docker)...
docker-compose -f docker-compose-pgadmin.yml up -d
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERRO] Falha ao iniciar Docker. Verifique se o Docker esta instalado e rodando.
    echo.
    pause
    exit /b 1
)
echo.
echo [2/2] Aguardando PostgreSQL iniciar...
timeout /t 8 /nobreak >nul
echo.
echo ================================================
echo   PostgreSQL + pgAdmin iniciados com sucesso!
echo ================================================
echo.
echo   - Banco de dados: http://localhost:5432
echo   - pgAdmin Web UI: http://localhost:8082
echo.
echo   Para conectar no pgAdmin:
echo   Login: admin@admin.com / admin
echo.
echo   Adicionar servidor PostgreSQL:
echo   - Host: postgres
echo   - Port: 5432
echo   - Database: postgres
echo   - Username: postgres
echo   - Password: postgres
echo.
echo ================================================
echo   Agora execute a aplicacao Spring Boot:
echo ================================================
echo.
echo   mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
echo.
echo   Ou execute: run-docker-app.bat
echo.
echo   Ou abra pgAdmin: open-pgadmin.bat
echo.
pause

