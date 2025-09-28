# Pecinhas Installer Script
# Instala automaticamente a versão mais recente do Pecinhas

param(
    [switch]$Portable,
    [string]$InstallPath = "$env:LOCALAPPDATA\Pecinhas"
)

$ErrorActionPreference = "Stop"

# Cores para output
$Red = "`e[31m"
$Green = "`e[32m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Magenta = "`e[35m"
$Cyan = "`e[36m"
$Reset = "`e[0m"

function Write-ColorText {
    param([string]$Text, [string]$Color = $Reset)
    Write-Host "$Color$Text$Reset"
}

function Show-Banner {
    Write-Host ""
    Write-ColorText "  ██████╗ ███████╗ ██████╗██╗███╗   ██╗██╗  ██╗ █████╗ ███████╗" $Magenta
    Write-ColorText "  ██╔══██╗██╔════╝██╔════╝██║████╗  ██║██║  ██║██╔══██╗██╔════╝" $Magenta  
    Write-ColorText "  ██████╔╝█████╗  ██║     ██║██╔██╗ ██║███████║███████║███████╗" $Magenta
    Write-ColorText "  ██╔═══╝ ██╔══╝  ██║     ██║██║╚██╗██║██╔══██║██╔══██║╚════██║" $Magenta
    Write-ColorText "  ██║     ███████╗╚██████╗██║██║ ╚████║██║  ██║██║  ██║███████║" $Magenta
    Write-ColorText "  ╚═╝     ╚══════╝ ╚═════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝" $Magenta
    Write-Host ""
    Write-ColorText "  🚀 Instalador Automático do Pecinhas" $Cyan
    Write-ColorText "  📦 Otimizador e Debloater para Windows" $Blue
    Write-Host ""
}

function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Request-AdminRights {
    if (-not (Test-AdminRights)) {
        Write-ColorText "⚠️  Executando como administrador..." $Yellow
        $arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"& {irm https://raw.githubusercontent.com/PecinhasFPS/Pecinhas-V2/main/get.ps1 | iex}`""
        Start-Process powershell -Verb RunAs -ArgumentList $arguments
        exit
    }
}

function Get-LatestRelease {
    try {
        Write-ColorText "🔍 Buscando última versão..." $Blue
        $apiUrl = "https://api.github.com/repos/PecinhasFPS/Pecinhas-V2/releases/latest"
        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{"User-Agent" = "Pecinhas-Installer"}
        
        $setupAsset = $release.assets | Where-Object { $_.name -like "*setup.exe" }
        $portableAsset = $release.assets | Where-Object { $_.name -like "*win.zip" }
        
        if ($Portable -and $portableAsset) {
            return @{
                Version = $release.tag_name
                DownloadUrl = $portableAsset.browser_download_url
                FileName = $portableAsset.name
                IsPortable = $true
            }
        } elseif ($setupAsset) {
            return @{
                Version = $release.tag_name
                DownloadUrl = $setupAsset.browser_download_url
                FileName = $setupAsset.name
                IsPortable = $false
            }
        } else {
            throw "Nenhum arquivo de instalação encontrado na última release"
        }
    } catch {
        Write-ColorText "❌ Erro ao buscar release: $($_.Exception.Message)" $Red
        exit 1
    }
}

function Download-File {
    param([string]$Url, [string]$OutputPath)
    
    try {
        Write-ColorText "⬇️  Baixando: $(Split-Path $OutputPath -Leaf)" $Blue
        
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Pecinhas-Installer")
        
        # Progress callback
        $webClient.add_DownloadProgressChanged({
            param($sender, $e)
            $percent = [math]::Round($e.ProgressPercentage, 1)
            Write-Progress -Activity "Baixando Pecinhas" -Status "$percent% completo" -PercentComplete $e.ProgressPercentage
        })
        
        $webClient.DownloadFile($Url, $OutputPath)
        $webClient.Dispose()
        Write-Progress -Activity "Baixando Pecinhas" -Completed
        
        Write-ColorText "✅ Download concluído!" $Green
    } catch {
        Write-ColorText "❌ Erro no download: $($_.Exception.Message)" $Red
        exit 1
    }
}

function Install-Pecinhas {
    param($ReleaseInfo)
    
    $tempPath = Join-Path $env:TEMP $ReleaseInfo.FileName
    
    # Download
    Download-File -Url $ReleaseInfo.DownloadUrl -OutputPath $tempPath
    
    if ($ReleaseInfo.IsPortable) {
        Write-ColorText "📦 Extraindo versão portable..." $Blue
        
        # Criar diretório de instalação
        if (-not (Test-Path $InstallPath)) {
            New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
        }
        
        # Extrair ZIP
        Expand-Archive -Path $tempPath -DestinationPath $InstallPath -Force
        
        # Encontrar executável
        $exePath = Get-ChildItem -Path $InstallPath -Name "*.exe" -Recurse | Select-Object -First 1
        if ($exePath) {
            $fullExePath = Join-Path $InstallPath $exePath
            
            # Criar atalho na área de trabalho
            $desktop = [Environment]::GetFolderPath("Desktop")
            $shortcutPath = Join-Path $desktop "Pecinhas.lnk"
            
            $shell = New-Object -ComObject WScript.Shell
            $shortcut = $shell.CreateShortcut($shortcutPath)
            $shortcut.TargetPath = $fullExePath
            $shortcut.WorkingDirectory = Split-Path $fullExePath
            $shortcut.Save()
            
            Write-ColorText "✅ Pecinhas instalado em: $InstallPath" $Green
            Write-ColorText "🖥️  Atalho criado na área de trabalho" $Green
        }
    } else {
        Write-ColorText "🚀 Executando instalador..." $Blue
        Start-Process -FilePath $tempPath -Wait
        Write-ColorText "✅ Instalação concluída!" $Green
    }
    
    # Limpar arquivo temporário
    Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
}

function Main {
    Show-Banner
    
    # Verificar se precisa de admin (apenas para instalador)
    if (-not $Portable) {
        Request-AdminRights
    }
    
    # Obter informações da release
    $releaseInfo = Get-LatestRelease
    Write-ColorText "📋 Versão encontrada: $($releaseInfo.Version)" $Green
    
    # Instalar
    Install-Pecinhas -ReleaseInfo $releaseInfo
    
    Write-Host ""
    Write-ColorText "🎉 Pecinhas instalado com sucesso!" $Green
    Write-ColorText "💡 Execute o Pecinhas para começar a otimizar seu PC" $Cyan
    Write-Host ""
    
    # Perguntar se quer executar
    $response = Read-Host "Deseja executar o Pecinhas agora? (s/N)"
    if ($response -eq 's' -or $response -eq 'S') {
        if ($ReleaseInfo.IsPortable) {
            $exePath = Get-ChildItem -Path $InstallPath -Name "*.exe" -Recurse | Select-Object -First 1
            if ($exePath) {
                Start-Process (Join-Path $InstallPath $exePath)
            }
        } else {
            # Tentar encontrar o executável instalado
            $possiblePaths = @(
                "$env:LOCALAPPDATA\Programs\pecinhas\sparkle.exe",
                "$env:PROGRAMFILES\pecinhas\sparkle.exe",
                "$env:PROGRAMFILES(X86)\pecinhas\sparkle.exe"
            )
            
            foreach ($path in $possiblePaths) {
                if (Test-Path $path) {
                    Start-Process $path
                    break
                }
            }
        }
    }
}

# Executar
Main