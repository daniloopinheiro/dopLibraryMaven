# ================================
# Docker Manager - Biblioteca API
# Gerenciador completo de containers Docker
# ================================

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('build', 'start', 'stop', 'restart', 'logs', 'status', 'clean', 'help')]
    [string]$Action = 'help',
    
    [Parameter(Mandatory=$false)]
    [ValidateSet('dev', 'postgres', 'compose')]
    [string]$Mode = 'dev'
)

# Colors for output
$Color_Success = "Green"
$Color_Error = "Red"
$Color_Warning = "Yellow"
$Color_Info = "Cyan"

# Configuration
$IMAGE_NAME = "biblioteca-api:latest"
$CONTAINER_APP = "biblioteca-api"
$CONTAINER_APP_DEV = "biblioteca-api-dev"
$CONTAINER_POSTGRES = "biblioteca-postgres"
$CONTAINER_PGADMIN = "biblioteca-pgadmin"
$NETWORK_NAME = "biblioteca-network"
$COMPOSE_FILE = "docker-compose-app.yml"

# ================================
# Helper Functions
# ================================

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-ColorOutput "========================================" $Color_Info
    Write-ColorOutput "  $Title" $Color_Info
    Write-ColorOutput "========================================" $Color_Info
    Write-Host ""
}

function Test-DockerInstalled {
    try {
        docker --version | Out-Null
        return $true
    }
    catch {
        Write-ColorOutput "[ERROR] Docker não está instalado ou não está no PATH" $Color_Error
        Write-ColorOutput "Instale o Docker Desktop: https://www.docker.com/products/docker-desktop" $Color_Warning
        return $false
    }
}

function Test-DockerRunning {
    try {
        docker ps | Out-Null
        return $true
    }
    catch {
        Write-ColorOutput "[ERROR] Docker não está rodando" $Color_Error
        Write-ColorOutput "Inicie o Docker Desktop e tente novamente" $Color_Warning
        return $false
    }
}

# ================================
# Action Functions
# ================================

function Build-DockerImage {
    Write-Header "Building Docker Image"
    
    Write-ColorOutput "[INFO] Building image: $IMAGE_NAME" $Color_Info
    
    docker build -t $IMAGE_NAME .
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-ColorOutput "[SUCCESS] Imagem criada com sucesso!" $Color_Success
        Write-Host ""
        docker images $IMAGE_NAME
    }
    else {
        Write-ColorOutput "[ERROR] Falha ao criar a imagem" $Color_Error
        exit 1
    }
}

function Start-DevMode {
    Write-Header "Starting Application - DEV Mode (H2)"
    
    # Stop existing container
    $existing = docker ps -a --filter "name=$CONTAINER_APP_DEV" --format "{{.Names}}"
    if ($existing -eq $CONTAINER_APP_DEV) {
        Write-ColorOutput "[INFO] Parando container existente..." $Color_Warning
        docker stop $CONTAINER_APP_DEV | Out-Null
        docker rm $CONTAINER_APP_DEV | Out-Null
    }
    
    # Check if image exists
    $imageExists = docker images $IMAGE_NAME --format "{{.Repository}}:{{.Tag}}"
    if (-not $imageExists) {
        Write-ColorOutput "[ERROR] Imagem não encontrada. Execute: .\docker-manager.ps1 build" $Color_Error
        exit 1
    }
    
    Write-ColorOutput "[INFO] Iniciando container..." $Color_Info
    
    docker run -d `
        --name $CONTAINER_APP_DEV `
        -p 8080:8080 `
        -e SPRING_PROFILES_ACTIVE=dev `
        $IMAGE_NAME
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-ColorOutput "[SUCCESS] Aplicação iniciada com sucesso!" $Color_Success
        Write-Host ""
        Write-ColorOutput "Container: $CONTAINER_APP_DEV" $Color_Info
        Write-ColorOutput "Profile: DEV (H2 Database)" $Color_Info
        Write-Host ""
        Write-ColorOutput "Acessos:" $Color_Success
        Write-Host "  - API REST: http://localhost:8080/api/autores"
        Write-Host "  - H2 Console: http://localhost:8080/h2-console"
        Write-Host ""
        Write-ColorOutput "Aguardando inicialização..." $Color_Warning
        Start-Sleep -Seconds 10
        docker logs --tail 20 $CONTAINER_APP_DEV
    }
    else {
        Write-ColorOutput "[ERROR] Falha ao iniciar container" $Color_Error
    }
}

function Start-PostgresMode {
    Write-Header "Starting Application with PostgreSQL"
    
    # Create network
    $networkExists = docker network ls --filter "name=$NETWORK_NAME" --format "{{.Name}}"
    if (-not $networkExists) {
        Write-ColorOutput "[INFO] Criando rede: $NETWORK_NAME" $Color_Info
        docker network create $NETWORK_NAME
    }
    
    # Start PostgreSQL
    $postgresRunning = docker ps --filter "name=$CONTAINER_POSTGRES" --format "{{.Names}}"
    if ($postgresRunning -ne $CONTAINER_POSTGRES) {
        Write-ColorOutput "[INFO] Iniciando PostgreSQL..." $Color_Info
        docker run -d `
            --name $CONTAINER_POSTGRES `
            --network $NETWORK_NAME `
            -e POSTGRES_DB=biblioteca `
            -e POSTGRES_USER=postgres `
            -e POSTGRES_PASSWORD=postgres `
            -p 5432:5432 `
            postgres:15-alpine
        
        Write-ColorOutput "[INFO] Aguardando PostgreSQL inicializar..." $Color_Warning
        Start-Sleep -Seconds 15
    }
    else {
        Write-ColorOutput "[INFO] PostgreSQL já está rodando" $Color_Success
    }
    
    # Stop existing app container
    $existing = docker ps -a --filter "name=$CONTAINER_APP" --format "{{.Names}}"
    if ($existing -eq $CONTAINER_APP) {
        Write-ColorOutput "[INFO] Parando container existente da aplicação..." $Color_Warning
        docker stop $CONTAINER_APP | Out-Null
        docker rm $CONTAINER_APP | Out-Null
    }
    
    # Start application
    Write-ColorOutput "[INFO] Iniciando aplicação..." $Color_Info
    
    docker run -d `
        --name $CONTAINER_APP `
        --network $NETWORK_NAME `
        -p 8080:8080 `
        -e SPRING_DATASOURCE_URL=jdbc:postgresql://${CONTAINER_POSTGRES}:5432/biblioteca `
        -e SPRING_DATASOURCE_USERNAME=postgres `
        -e SPRING_DATASOURCE_PASSWORD=postgres `
        -e SPRING_JPA_HIBERNATE_DDL_AUTO=update `
        $IMAGE_NAME
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-ColorOutput "[SUCCESS] Aplicação iniciada com sucesso!" $Color_Success
        Write-Host ""
        Write-ColorOutput "Containers:" $Color_Info
        Write-Host "  - App: $CONTAINER_APP"
        Write-Host "  - Database: $CONTAINER_POSTGRES"
        Write-Host ""
        Write-ColorOutput "Acessos:" $Color_Success
        Write-Host "  - API REST: http://localhost:8080/api/autores"
        Write-Host "  - PostgreSQL: localhost:5432"
        Write-Host ""
        Write-ColorOutput "Aguardando inicialização..." $Color_Warning
        Start-Sleep -Seconds 15
        docker logs --tail 20 $CONTAINER_APP
    }
    else {
        Write-ColorOutput "[ERROR] Falha ao iniciar aplicação" $Color_Error
    }
}

function Start-ComposeMode {
    Write-Header "Starting with Docker Compose"
    
    if (-not (Test-Path $COMPOSE_FILE)) {
        Write-ColorOutput "[ERROR] Arquivo $COMPOSE_FILE não encontrado" $Color_Error
        exit 1
    }
    
    Write-ColorOutput "[INFO] Iniciando serviços..." $Color_Info
    docker-compose -f $COMPOSE_FILE up -d --build
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-ColorOutput "[SUCCESS] Serviços iniciados com sucesso!" $Color_Success
        Write-Host ""
        Write-ColorOutput "Acessos:" $Color_Success
        Write-Host "  - API REST: http://localhost:8080/api/autores"
        Write-Host "  - pgAdmin: http://localhost:8082"
        Write-Host "  - PostgreSQL: localhost:5432"
        Write-Host ""
        Write-ColorOutput "Aguardando inicialização..." $Color_Warning
        Start-Sleep -Seconds 20
        docker-compose -f $COMPOSE_FILE logs --tail 20 app
    }
}

function Stop-Containers {
    Write-Header "Stopping Containers"
    
    $containers = @($CONTAINER_APP, $CONTAINER_APP_DEV, $CONTAINER_POSTGRES, $CONTAINER_PGADMIN)
    
    foreach ($container in $containers) {
        $running = docker ps --filter "name=$container" --format "{{.Names}}"
        if ($running -eq $container) {
            Write-ColorOutput "[INFO] Parando $container..." $Color_Info
            docker stop $container | Out-Null
            docker rm $container | Out-Null
        }
    }
    
    Write-Host ""
    Write-ColorOutput "[SUCCESS] Containers parados" $Color_Success
}

function Stop-Compose {
    Write-Header "Stopping Docker Compose"
    
    if (Test-Path $COMPOSE_FILE) {
        docker-compose -f $COMPOSE_FILE down
        Write-ColorOutput "[SUCCESS] Docker Compose parado" $Color_Success
    }
}

function Show-Logs {
    Write-Header "Container Logs"
    
    $containers = docker ps --format "{{.Names}}" | Where-Object { $_ -match "biblioteca" }
    
    if ($containers.Count -eq 0) {
        Write-ColorOutput "[WARNING] Nenhum container rodando" $Color_Warning
        return
    }
    
    Write-ColorOutput "Containers ativos:" $Color_Info
    foreach ($container in $containers) {
        Write-Host "  - $container"
    }
    Write-Host ""
    
    $container = $containers[0]
    Write-ColorOutput "[INFO] Mostrando logs de: $container" $Color_Info
    Write-ColorOutput "(Ctrl+C para sair)" $Color_Warning
    Write-Host ""
    docker logs -f $container
}

function Show-Status {
    Write-Header "Docker Status"
    
    Write-ColorOutput "[INFO] Containers:" $Color_Info
    docker ps -a --filter "name=biblioteca" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    Write-Host ""
    Write-ColorOutput "[INFO] Imagens:" $Color_Info
    docker images $IMAGE_NAME --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
    
    Write-Host ""
    Write-ColorOutput "[INFO] Networks:" $Color_Info
    docker network ls --filter "name=biblioteca" --format "table {{.Name}}\t{{.Driver}}"
    
    Write-Host ""
    Write-ColorOutput "[INFO] Volumes:" $Color_Info
    docker volume ls --filter "name=biblioteca" --format "table {{.Name}}\t{{.Driver}}"
}

function Clean-Docker {
    Write-Header "Cleaning Docker Resources"
    
    Write-ColorOutput "[WARNING] Esta ação irá remover:" $Color_Warning
    Write-Host "  - Todos os containers da aplicação"
    Write-Host "  - Volumes de dados (PostgreSQL)"
    Write-Host "  - Network"
    Write-Host ""
    
    $confirmation = Read-Host "Continuar? (s/N)"
    if ($confirmation -ne 's' -and $confirmation -ne 'S') {
        Write-ColorOutput "[INFO] Operação cancelada" $Color_Info
        return
    }
    
    # Stop compose
    if (Test-Path $COMPOSE_FILE) {
        docker-compose -f $COMPOSE_FILE down -v
    }
    
    # Stop and remove containers
    $containers = @($CONTAINER_APP, $CONTAINER_APP_DEV, $CONTAINER_POSTGRES, $CONTAINER_PGADMIN)
    foreach ($container in $containers) {
        docker stop $container 2>$null | Out-Null
        docker rm $container 2>$null | Out-Null
    }
    
    # Remove network
    docker network rm $NETWORK_NAME 2>$null | Out-Null
    
    # Remove volumes
    docker volume ls --filter "name=biblioteca" --format "{{.Name}}" | ForEach-Object {
        docker volume rm $_ 2>$null | Out-Null
    }
    
    Write-Host ""
    Write-ColorOutput "[SUCCESS] Limpeza concluída" $Color_Success
}

function Restart-Containers {
    Write-Header "Restarting Containers"
    
    if ($Mode -eq 'compose') {
        docker-compose -f $COMPOSE_FILE restart
    }
    else {
        Stop-Containers
        Start-Sleep -Seconds 2
        if ($Mode -eq 'dev') {
            Start-DevMode
        }
        elseif ($Mode -eq 'postgres') {
            Start-PostgresMode
        }
    }
}

function Show-Help {
    Write-Host ""
    Write-ColorOutput "Docker Manager - Biblioteca API" $Color_Info
    Write-Host ""
    Write-Host "USO:"
    Write-Host "  .\docker-manager.ps1 -Action <action> [-Mode <mode>]"
    Write-Host ""
    Write-Host "ACTIONS:"
    Write-Host "  build      - Construir a imagem Docker"
    Write-Host "  start      - Iniciar containers"
    Write-Host "  stop       - Parar containers"
    Write-Host "  restart    - Reiniciar containers"
    Write-Host "  logs       - Ver logs dos containers"
    Write-Host "  status     - Ver status dos containers"
    Write-Host "  clean      - Limpar todos os recursos Docker"
    Write-Host "  help       - Mostrar esta ajuda"
    Write-Host ""
    Write-Host "MODES (para start/restart):"
    Write-Host "  dev        - H2 Database (padrão)"
    Write-Host "  postgres   - PostgreSQL separado"
    Write-Host "  compose    - Docker Compose (completo)"
    Write-Host ""
    Write-Host "EXEMPLOS:"
    Write-Host "  .\docker-manager.ps1 -Action build"
    Write-Host "  .\docker-manager.ps1 -Action start -Mode dev"
    Write-Host "  .\docker-manager.ps1 -Action start -Mode postgres"
    Write-Host "  .\docker-manager.ps1 -Action start -Mode compose"
    Write-Host "  .\docker-manager.ps1 -Action logs"
    Write-Host "  .\docker-manager.ps1 -Action status"
    Write-Host "  .\docker-manager.ps1 -Action stop"
    Write-Host "  .\docker-manager.ps1 -Action clean"
    Write-Host ""
}

# ================================
# Main Execution
# ================================

# Check Docker installation
if (-not (Test-DockerInstalled)) {
    exit 1
}

if (-not (Test-DockerRunning)) {
    exit 1
}

# Execute action
switch ($Action) {
    'build' {
        Build-DockerImage
    }
    'start' {
        switch ($Mode) {
            'dev' { Start-DevMode }
            'postgres' { Start-PostgresMode }
            'compose' { Start-ComposeMode }
        }
    }
    'stop' {
        if ($Mode -eq 'compose') {
            Stop-Compose
        }
        else {
            Stop-Containers
        }
    }
    'restart' {
        Restart-Containers
    }
    'logs' {
        Show-Logs
    }
    'status' {
        Show-Status
    }
    'clean' {
        Clean-Docker
    }
    'help' {
        Show-Help
    }
}

Write-Host ""

