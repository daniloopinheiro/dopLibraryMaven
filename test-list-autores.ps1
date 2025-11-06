# Script para listar todos os autores
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Listando Autores da API" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

try {
    $autores = Invoke-RestMethod -Uri "http://localhost:8080/api/autores"
    
    Write-Host "📚 Total de autores: $($autores.Count)" -ForegroundColor Yellow
    Write-Host ""
    
    if ($autores.Count -eq 0) {
        Write-Host "⚠️  Nenhum autor cadastrado ainda." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Para criar autores em lote, execute:" -ForegroundColor Cyan
        Write-Host "  .\test-batch-create.ps1" -ForegroundColor Green
        Write-Host ""
    }
    else {
        Write-Host "Lista de Autores:" -ForegroundColor Cyan
        Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
        Write-Host ""
        
        $autores | ForEach-Object {
            Write-Host "📖 ID: $($_.idAutor)" -ForegroundColor White
            Write-Host "   Nome: $($_.nome) $($_.sobrenome)" -ForegroundColor Green
            Write-Host "   Nacionalidade: $($_.nacionalidade)" -ForegroundColor Yellow
            Write-Host "   Data Nascimento: $($_.dataNascimento)" -ForegroundColor Magenta
            if ($_.biografia) {
                $bio = $_.biografia
                if ($bio.Length -gt 100) {
                    $bio = $bio.Substring(0, 100) + "..."
                }
                Write-Host "   Biografia: $bio" -ForegroundColor Gray
            }
            Write-Host "   Cadastrado em: $($_.dataCadastro)" -ForegroundColor DarkGray
            Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
            Write-Host ""
        }
    }
}
catch {
    Write-Host "❌ Erro ao listar autores!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifique se a aplicação está rodando:" -ForegroundColor Yellow
    Write-Host "  http://localhost:8080/api/autores" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Para iniciar a aplicação:" -ForegroundColor Yellow
    Write-Host "  .\run-docker-app.bat" -ForegroundColor Green
    Write-Host ""
    Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

