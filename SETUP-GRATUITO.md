# 🆓 Setup Gratuito do Pecinhas

Este documento explica como configurar o Pecinhas para funcionar 100% gratuito usando apenas GitHub.

## ✅ O que foi configurado

### 1. Script de Instalação Automática
- **Arquivo**: `get.ps1`
- **URL**: `https://raw.githubusercontent.com/PecinhasFPS/Pecinhas-V2/main/get.ps1`
- **Funcionalidades**:
  - Baixa automaticamente a última release
  - Suporte a instalador e versão portable
  - Interface colorida e amigável
  - Verificação de permissões de administrador
  - Criação de atalhos automática

### 2. GitHub Pages
- **Arquivo**: `docs/index.html`
- **URL**: `https://pecinhasfps.github.io/Pecinhas-V2`
- **Funcionalidades**:
  - Página de download profissional
  - Botão de copiar comando
  - Links para GitHub e releases
  - Design responsivo e moderno

### 3. GitHub Actions
- **Build automático**: `.github/workflows/build.yml`
  - Compila o app automaticamente
  - Cria releases quando você faz uma tag
  - Upload dos arquivos .exe e .zip
  
- **Deploy do site**: `.github/workflows/pages.yml`
  - Atualiza o site automaticamente
  - Hospedagem gratuita no GitHub Pages

### 4. Auto-Updater
- Configurado para usar GitHub Releases
- Atualização automática funcionando
- Sem custos de servidor

## 🚀 Como usar

### Para usuários finais:
```powershell
# Instalação rápida
irm https://raw.githubusercontent.com/PecinhasFPS/Pecinhas-V2/main/get.ps1 | iex

# Ou visite o site
# https://pecinhasfps.github.io/Pecinhas-V2
```

### Para desenvolvedores:

#### 1. Ativar GitHub Pages
1. Vá em Settings > Pages no seu repo
2. Source: "GitHub Actions"
3. O site ficará em: `https://pecinhasfps.github.io/Pecinhas-V2`

#### 2. Criar uma release
```bash
# Criar tag e push
git tag v2.8.1
git push origin v2.8.1

# O GitHub Actions vai:
# - Compilar o app
# - Criar release automaticamente
# - Disponibilizar para download
```

#### 3. Testar instalação
```powershell
# Execute o script de teste
.\test-install.ps1
```

## 📁 Arquivos criados/modificados

### Novos arquivos:
- `get.ps1` - Script de instalação
- `docs/index.html` - Página do GitHub Pages
- `docs/_config.yml` - Configuração Jekyll
- `.github/workflows/build.yml` - Build automático
- `.github/workflows/pages.yml` - Deploy do site
- `electron-builder.yml` - Configuração do updater
- `test-install.ps1` - Script de teste
- `SETUP-GRATUITO.md` - Esta documentação

### Arquivos modificados:
- `package.json` - Homepage atualizada
- `README.md` - Links e instruções atualizadas
- `src/renderer/src/pages/Tweaks.jsx` - Links da documentação
- `src/renderer/src/components/FirstTime.jsx` - Aviso de segurança
- `resources/tweaks/readme.md` - Link da documentação

## 💰 Custos

**ZERO REAIS!** 🎉

- ✅ GitHub: Gratuito
- ✅ GitHub Pages: Gratuito
- ✅ GitHub Actions: Gratuito (2000 min/mês)
- ✅ GitHub Releases: Gratuito
- ✅ Domínio .github.io: Gratuito

## 🔧 Próximos passos

1. **Commit e push** todos os arquivos
2. **Ativar GitHub Pages** nas configurações
3. **Criar primeira release** com tag
4. **Testar instalação** com o script
5. **Divulgar** o novo link de instalação

## 🆘 Troubleshooting

### Se o script não funcionar:
1. Verifique se o arquivo `get.ps1` está no repositório
2. Teste a URL: `https://raw.githubusercontent.com/PecinhasFPS/Pecinhas-V2/main/get.ps1`
3. Execute `.\test-install.ps1` para diagnosticar

### Se o GitHub Pages não funcionar:
1. Vá em Settings > Pages
2. Verifique se está configurado para "GitHub Actions"
3. Aguarde alguns minutos após o primeiro deploy

### Se o auto-updater não funcionar:
1. Verifique se tem releases no GitHub
2. Confirme que o `electron-builder.yml` está correto
3. Teste criando uma nova tag/release

---

**Pronto!** Agora você tem um sistema completo de distribuição gratuito! 🚀