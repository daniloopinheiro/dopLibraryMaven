# ================================
# Test Render Dockerfile Locally - PowerShell
# ================================

$IMAGE_NAME = "biblioteca-api:render"
$CONTAINER_NAME = "biblioteca-api-render-test"

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Testing Render Dockerfile" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
try {
    docker --version | Out-Null
}
catch {
    Write-Host "[ERROR] Docker não está instalado" -ForegroundColor Red
    exit 1
}

Write-Host "[INFO] Building with Dockerfile.render..." -ForegroundColor Yellow
Write-Host ""

# Build the image
$buildResult = docker build -f Dockerfile.render -t $IMAGE_NAME . 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Build falhou" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possíveis causas:" -ForegroundColor Yellow
    Write-Host "  1. Erro de dependências Maven (502)"
    Write-Host "  2. Erro no código fonte"
    Write-Host "  3. Falta de recursos"
    Write-Host ""
    Write-Host "Soluções:" -ForegroundColor Yellow
    Write-Host "  1. Aguarde alguns minutos e tente novamente"
    Write-Host "  2. Verifique sua conexão com internet"
    Write-Host "  3. Execute: docker build -f Dockerfile.render -t biblioteca-api:render . --no-cache"
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  Build Successful!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Stop and remove existing container
docker stop $CONTAINER_NAME 2>$null | Out-Null
docker rm $CONTAINER_NAME 2>$null | Out-Null

Write-Host "[INFO] Starting container..." -ForegroundColor Yellow
Write-Host ""

# Run the container
docker run -d `
    --name $CONTAINER_NAME `
    -p 8080:8080 `
    -e PORT=8080 `
    -e SPRING_PROFILES_ACTIVE=dev `
    $IMAGE_NAME

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Falha ao iniciar container" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  Container Started!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Container: $CONTAINER_NAME"
Write-Host "Image: $IMAGE_NAME"
Write-Host "Port: 8080"
Write-Host ""
Write-Host "Aguardando inicialização... (15 segundos)" -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host ""
Write-Host "[INFO] Últimas linhas do log:" -ForegroundColor Cyan
Write-Host "===================================="
docker logs --tail 30 $CONTAINER_NAME

Write-Host ""
Write-Host "===================================="
Write-Host ""
Write-Host "Testes:" -ForegroundColor Green
Write-Host "  curl http://localhost:8080/api/autores"
Write-Host "  http://localhost:8080/h2-console"
Write-Host ""
Write-Host "Comandos úteis:" -ForegroundColor Yellow
Write-Host "  Ver logs: docker logs -f $CONTAINER_NAME"
Write-Host "  Parar: docker stop $CONTAINER_NAME"
Write-Host "  Remover: docker rm $CONTAINER_NAME"
Write-Host ""
Write-Host "Se funcionar aqui, deve funcionar no Render!" -ForegroundColor Green
Write-Host ""

# Test the API
Write-Host "Testando API..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/autores" -UseBasicParsing -TimeoutSec 10
    Write-Host "[SUCCESS] API respondeu com status: $($response.StatusCode)" -ForegroundColor Green
}
catch {
    Write-Host "[WARNING] API ainda não está respondendo. Aguarde mais alguns segundos." -ForegroundColor Yellow
    Write-Host "          Execute: curl http://localhost:8080/api/autores"
}

Write-Host ""

