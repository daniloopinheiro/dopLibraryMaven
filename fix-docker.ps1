# Script para diagnosticar e corrigir problemas com Docker
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Diagnóstico e Correção - Docker" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Teste 1: Docker está rodando?
Write-Host "[1/5] Verificando se Docker está rodando..." -ForegroundColor Yellow
docker version 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERRO] Docker não está rodando!" -ForegroundColor Red
    Write-Host "       Inicie o Docker Desktop e tente novamente." -ForegroundColor Red
    exit 1
}
Write-Host "      ✓ Docker está rodando" -ForegroundColor Green
Write-Host ""

# Teste 2: Conexão com Docker Hub
Write-Host "[2/5] Testando conexão com Docker Hub..." -ForegroundColor Yellow
$result = Test-NetConnection -ComputerName registry-1.docker.io -Port 443 -InformationLevel Quiet
if (-not $result) {
    Write-Host "      ✗ Problema de conexão com Docker Hub!" -ForegroundColor Red
    Write-Host "        - Verifique sua conexão com internet" -ForegroundColor Yellow
    Write-Host "        - Verifique firewall/proxy" -ForegroundColor Yellow
} else {
    Write-Host "      ✓ Conexão OK" -ForegroundColor Green
}
Write-Host ""

# Opção 3: Limpar cache do Docker
Write-Host "[3/5] Limpando cache do Docker..." -ForegroundColor Yellow
docker system prune -f 2>&1 | Out-Null
Write-Host "      ✓ Cache limpo" -ForegroundColor Green
Write-Host ""

# Opção 4: Tentar baixar a imagem diretamente
Write-Host "[4/5] Tentando baixar PostgreSQL (isso pode demorar)..." -ForegroundColor Yellow
Write-Host "      Aguarde..." -ForegroundColor Cyan

$pullJob = Start-Job -ScriptBlock {
    docker pull postgres:15-alpine 2>&1
}

$timeout = 120 # 2 minutos
$elapsed = 0
while ($pullJob.State -eq 'Running' -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 5
    $elapsed += 5
    Write-Host "      ... ainda baixando ($elapsed segundos)" -ForegroundColor Gray
}

if ($pullJob.State -eq 'Running') {
    Stop-Job $pullJob
    Remove-Job $pullJob
    Write-Host "      ✗ Timeout ao baixar a imagem" -ForegroundColor Red
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Yellow
    Write-Host "  SOLUÇÃO ALTERNATIVA" -ForegroundColor Yellow
    Write-Host "================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Tente estas opções:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. Reiniciar Docker Desktop:" -ForegroundColor Cyan
    Write-Host "   - Clique com botão direito no ícone do Docker" -ForegroundColor Gray
    Write-Host "   - Selecione 'Restart'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Verificar configurações de DNS:" -ForegroundColor Cyan
    Write-Host "   - Docker Desktop → Settings → Docker Engine" -ForegroundColor Gray
    Write-Host "   - Adicione: {`"dns`": [`"8.8.8.8`", `"8.8.4.4`"]}" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Usar versão minimal (sem Adminer):" -ForegroundColor Cyan
    Write-Host "   docker-compose -f docker-compose-minimal.yml up -d" -ForegroundColor Green
    Write-Host ""
    Write-Host "4. Verificar proxy/firewall corporativo" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

$pullOutput = Receive-Job $pullJob
Remove-Job $pullJob

if ($pullOutput -match "error|EOF") {
    Write-Host "      ✗ Erro ao baixar imagem" -ForegroundColor Red
    Write-Host ""
    Write-Host "      Tentando versão minimal..." -ForegroundColor Yellow
} else {
    Write-Host "      ✓ PostgreSQL baixado com sucesso!" -ForegroundColor Green
}
Write-Host ""

# Opção 5: Iniciar o compose
Write-Host "[5/5] Iniciando Docker Compose..." -ForegroundColor Yellow
docker-compose -f docker-compose-minimal.yml up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  ✓ SUCESSO!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "PostgreSQL está rodando em: localhost:5432" -ForegroundColor White
    Write-Host ""
    Write-Host "Próximo passo:" -ForegroundColor Cyan
    Write-Host "  .\mvnw.cmd spring-boot:run -D`"spring-boot.run.profiles=dev`"" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[ERRO] Falha ao iniciar containers" -ForegroundColor Red
    Write-Host ""
}

