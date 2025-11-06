# Script rápido para testar conexão com PostgreSQL
Write-Host "Testando conexão com PostgreSQL..." -ForegroundColor Cyan
Write-Host ""

docker exec -e PGPASSWORD=postgres projectsacademy-db psql -U postgres -d postgres -c "SELECT version();"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ PostgreSQL está funcionando!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Agora execute a aplicação:" -ForegroundColor Yellow
    Write-Host "  .\mvnw.cmd spring-boot:run -D`"spring-boot.run.profiles=dev`"" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ou use o script:" -ForegroundColor Yellow
    Write-Host "  .\run-docker-app.bat" -ForegroundColor Green
} else {
    Write-Host "✗ Erro ao conectar" -ForegroundColor Red
}

