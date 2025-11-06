# Script para limpar dados de empréstimos com status inválido
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Corrigindo dados de empréstimos no banco" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Verificando dados atuais..." -ForegroundColor Yellow

$query1 = "SELECT id_emprestimo, nome_usuario, status FROM emprestimos ORDER BY id_emprestimo;"

try {
    $result = docker exec -e PGPASSWORD=postgres projectsacademy-db `
                    psql -U postgres -d postgres -c $query1 2>&1
    
    Write-Host $result
    Write-Host ""
}
catch {
    Write-Host "Erro ao verificar dados" -ForegroundColor Red
}

Write-Host "[2/3] Corrigindo status (minúsculo → MAIÚSCULO)..." -ForegroundColor Yellow

$query2 = "UPDATE emprestimos SET status = UPPER(status::text)::status_emprestimo WHERE status IS NOT NULL;"

try {
    $result = docker exec -e PGPASSWORD=postgres projectsacademy-db `
                    psql -U postgres -d postgres -c $query2 2>&1
    
    if ($result -match "UPDATE") {
        Write-Host "      ✓ Status corrigidos!" -ForegroundColor Green
    } else {
        Write-Host $result
    }
}
catch {
    Write-Host "      ✗ Erro ao corrigir" -ForegroundColor Red
    Write-Host ""
    Write-Host "      Tente manualmente no pgAdmin:" -ForegroundColor Yellow
    Write-Host "      UPDATE emprestimos SET status = UPPER(status::text)::status_emprestimo;" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host ""
Write-Host "[3/3] Verificando resultado..." -ForegroundColor Yellow

try {
    $result = docker exec -e PGPASSWORD=postgres projectsacademy-db `
                    psql -U postgres -d postgres -c $query1 2>&1
    
    Write-Host $result
    Write-Host ""
    
    if ($result -match "EMPRESTADO|DEVOLVIDO|ATRASADO") {
        Write-Host "================================================" -ForegroundColor Green
        Write-Host "  ✅ SUCESSO! Dados corrigidos!" -ForegroundColor Green
        Write-Host "================================================" -ForegroundColor Green
    }
}
catch {
    Write-Host "Erro ao verificar resultado" -ForegroundColor Red
}

Write-Host ""
Write-Host "Agora teste novamente:" -ForegroundColor Cyan
Write-Host "  http://localhost:8080/api/emprestimos" -ForegroundColor White
Write-Host ""

