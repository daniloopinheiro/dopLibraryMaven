# Script para testar criação em lote de autores
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Testando API - Criação de Autores em Lote" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se a API está rodando
Write-Host "[1/3] Verificando se a API está rodando..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:8080/api/autores" -Method GET -TimeoutSec 2
    Write-Host "      ✓ API está rodando!" -ForegroundColor Green
}
catch {
    Write-Host "      ✗ API não está rodando!" -ForegroundColor Red
    Write-Host "      Execute: .\run-docker-app.bat" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "[2/3] Carregando dados do arquivo..." -ForegroundColor Yellow

# Verificar se o arquivo existe
if (-not (Test-Path "test-autores-batch.json")) {
    Write-Host "      ✗ Arquivo test-autores-batch.json não encontrado!" -ForegroundColor Red
    exit 1
}

$json = Get-Content test-autores-batch.json -Raw
Write-Host "      ✓ Arquivo carregado!" -ForegroundColor Green

Write-Host ""
Write-Host "[3/3] Enviando requisição POST para /api/autores/batch..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/autores/batch" `
                                  -Method POST `
                                  -ContentType "application/json" `
                                  -Body $json
    
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  ✅ SUCESSO!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  📊 Estatísticas:" -ForegroundColor Cyan
    Write-Host "     Total processado: $($response.totalProcessado)" -ForegroundColor White
    Write-Host "     Criados: $($response.criados)" -ForegroundColor Green
    Write-Host "     Já existentes: $($response.existentes)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  💬 $($response.mensagem)" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  📚 Autores:" -ForegroundColor Cyan
    
    $response.autores | ForEach-Object {
        Write-Host "     • ID: $($_.idAutor) - $($_.nome) $($_.sobrenome)" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Listar todos: http://localhost:8080/api/autores" -ForegroundColor Gray
    Write-Host "Ver no pgAdmin: http://localhost:8082" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Red
    Write-Host "  ❌ ERRO ao criar autores" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Detalhes:" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Resposta da API:" -ForegroundColor Yellow
        Write-Host $responseBody -ForegroundColor Red
    }
    Write-Host ""
    exit 1
}

