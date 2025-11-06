# Script para verificar status da aplicação
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Verificando Status da Aplicação" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar se a API está rodando
Write-Host "[1/4] Verificando se a API está respondendo..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/autores" -Method GET -TimeoutSec 2
    Write-Host "      ✓ API está rodando!" -ForegroundColor Green
    Write-Host "      Total de autores: $($response.Count)" -ForegroundColor Gray
}
catch {
    Write-Host "      ✗ API NÃO está rodando!" -ForegroundColor Red
    Write-Host "      Inicie com: .\mvnw.cmd spring-boot:run -D`"spring-boot.run.profiles=dev`"" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "[2/4] Verificando Docker/PostgreSQL..." -ForegroundColor Yellow
try {
    $containers = docker ps --format "{{.Names}}" 2>$null
    if ($containers -match "projectsacademy-db") {
        Write-Host "      ✓ PostgreSQL está rodando" -ForegroundColor Green
    } else {
        Write-Host "      ✗ PostgreSQL NÃO está rodando" -ForegroundColor Red
        Write-Host "      Inicie com: docker-compose -f docker-compose-pgadmin.yml up -d" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "      ⚠ Docker não disponível ou não instalado" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[3/4] Testando criação de empréstimo..." -ForegroundColor Yellow

$testJson = @"
{
  "idLivro": 1,
  "nomeUsuario": "Teste Status Check",
  "dataEmprestimo": "2025-11-04",
  "dataPrevistaDevolucao": "2025-11-18",
  "status": "emprestado"
}
"@

try {
    $emprestimo = Invoke-RestMethod -Uri "http://localhost:8080/api/emprestimos" `
                                   -Method POST `
                                   -ContentType "application/json" `
                                   -Body $testJson `
                                   -ErrorAction Stop
    
    Write-Host "      ✓ Empréstimo criado com sucesso!" -ForegroundColor Green
    Write-Host "      ID: $($emprestimo.idEmprestimo) | Status: $($emprestimo.status)" -ForegroundColor Gray
    
    # Limpar o teste
    try {
        Invoke-RestMethod -Uri "http://localhost:8080/api/emprestimos/$($emprestimo.idEmprestimo)" `
                         -Method DELETE `
                         -ErrorAction SilentlyContinue | Out-Null
        Write-Host "      ✓ Empréstimo de teste removido" -ForegroundColor DarkGray
    } catch {
        # Ignora erro ao deletar
    }
}
catch {
    Write-Host "      ✗ ERRO ao criar empréstimo!" -ForegroundColor Red
    Write-Host ""
    
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "      Status HTTP: $statusCode" -ForegroundColor Red
        
        if ($_.ErrorDetails.Message) {
            $errorMsg = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "      Erro: $($errorMsg.message)" -ForegroundColor Red
        }
    } else {
        Write-Host "      Erro: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "      🔧 Soluções:" -ForegroundColor Yellow
    Write-Host "      1. REINICIE a aplicação Spring Boot" -ForegroundColor Cyan
    Write-Host "      2. Verifique se salvou as alterações no código" -ForegroundColor Cyan
    Write-Host "      3. Execute: .\mvnw.cmd clean spring-boot:run -D`"spring-boot.run.profiles=dev`"" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "[4/4] Verificando configuração do banco..." -ForegroundColor Yellow

try {
    $query = @"
SELECT column_name, data_type, udt_name
FROM information_schema.columns
WHERE table_name = 'emprestimos' AND column_name = 'status';
"@
    
    $dbCheck = docker exec -e PGPASSWORD=postgres projectsacademy-db `
                     psql -U postgres -d postgres -t -c $query 2>$null
    
    if ($dbCheck -match "status_emprestimo") {
        Write-Host "      ✓ Coluna status está como ENUM (status_emprestimo)" -ForegroundColor Green
    } elseif ($dbCheck -match "character varying") {
        Write-Host "      ⚠ Coluna status está como VARCHAR" -ForegroundColor Yellow
        Write-Host "      Considere executar: fix-enum-database.sql" -ForegroundColor Cyan
    }
}
catch {
    Write-Host "      ⚠ Não foi possível verificar estrutura do banco" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  ✅ Sistema está funcionando corretamente!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "URLs úteis:" -ForegroundColor Cyan
Write-Host "  API:     http://localhost:8080/api" -ForegroundColor White
Write-Host "  pgAdmin: http://localhost:8082" -ForegroundColor White
Write-Host ""

