# Script de teste para verificar a instalação
Write-Host "🧪 Testando instalador do Pecinhas..." -ForegroundColor Cyan
Write-Host ""

# Testar se o script existe no GitHub
try {
    Write-Host "📡 Verificando se o script está disponível no GitHub..." -ForegroundColor Yellow
    $response = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PecinhasFPS/Pecinhas-V2/main/get.ps1" -Method Head
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Script encontrado no GitHub!" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Erro ao acessar o script: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Testar API do GitHub
try {
    Write-Host "📡 Verificando releases no GitHub..." -ForegroundColor Yellow
    $releases = Invoke-RestMethod -Uri "https://api.github.com/repos/PecinhasFPS/Pecinhas-V2/releases"
    if ($releases.Count -gt 0) {
        $latest = $releases[0]
        Write-Host "✅ Última release encontrada: $($latest.tag_name)" -ForegroundColor Green
        Write-Host "📅 Publicada em: $($latest.published_at)" -ForegroundColor Gray
        
        # Verificar se tem assets
        if ($latest.assets.Count -gt 0) {
            Write-Host "📦 Assets disponíveis:" -ForegroundColor Yellow
            foreach ($asset in $latest.assets) {
                $sizeMB = [math]::Round($asset.size / 1MB, 2)
                Write-Host "   - $($asset.name) ($sizeMB MB)" -ForegroundColor Gray
            }
        } else {
            Write-Host "⚠️  Nenhum asset encontrado na release" -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠️  Nenhuma release encontrada" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Erro ao verificar releases: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 Para testar a instalação completa, execute:" -ForegroundColor Cyan
Write-Host "irm https://raw.githubusercontent.com/PecinhasFPS/Pecinhas-V2/main/get.ps1 | iex" -ForegroundColor White
Write-Host ""
Write-Host "📝 Ou visite: https://pecinhasfps.github.io/Pecinhas-V2" -ForegroundColor Cyan