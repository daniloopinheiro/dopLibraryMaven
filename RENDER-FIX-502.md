# 🔧 Solução: Erro 502 no Render

## 📋 Problema

```
[ERROR] Failed to execute goal on project biblioteca-api: 
Could not resolve dependencies...
status code: 502, reason phrase: Bad Gateway (502)
```

O erro 502 ocorre quando o Maven Central está temporariamente indisponível durante o build no Render.

---

## ✅ Soluções Implementadas

### 1. Dockerfile.render (PRINCIPAL) ⭐

Criado `Dockerfile.render` otimizado especificamente para o Render com:

#### Características:
- ✅ **Retry automático** (3 tentativas) para download de dependências
- ✅ **Maven Wrapper** (./mvnw) ao invés do Maven do sistema
- ✅ **Timeouts aumentados** via MAVEN_OPTS
- ✅ **Resolução gradual** de dependências (resolve + resolve-plugins)
- ✅ **Imagem base não-Alpine** para build (melhor compatibilidade)
- ✅ **Variável PORT** dinâmica para Render

#### Como Usar:

**No Render Dashboard:**
1. Settings → **Dockerfile Path** → `Dockerfile.render`
2. Save Changes
3. Manual Deploy

---

### 2. Dockerfile Principal Atualizado

O `Dockerfile` original também foi atualizado com:
- ✅ Retry logic (3 tentativas)
- ✅ Delays progressivos (10s, 20s, 30s)
- ✅ Maven settings configurado
- ✅ Melhor cache de dependências

---

### 3. render.yaml (Blueprint)

Arquivo de configuração automática para Render:

```yaml
services:
  - type: web
    name: biblioteca-api
    dockerfilePath: ./Dockerfile.render  # ← Importante
    # ... demais configurações
```

#### Como Usar:
1. Commit `render.yaml` no repositório
2. Render Dashboard → New → **Blueprint**
3. Conectar repositório
4. Apply

---

### 4. Scripts de Teste

#### Windows (Batch):
```bash
.\test-render-dockerfile.bat
```

#### PowerShell:
```bash
.\test-render-dockerfile.ps1
```

**O que faz:**
- Build com `Dockerfile.render`
- Executa container localmente
- Testa API automaticamente
- Mostra logs em tempo real

**Se funcionar localmente = funcionará no Render!** ✅

---

## 🚀 Passo a Passo para Deploy

### Opção A: Via Dashboard (Recomendado)

1. **Render Dashboard** → New Web Service
2. Conectar seu repositório GitHub
3. **Configurar:**
   ```
   Name: biblioteca-api
   Runtime: Docker
   Dockerfile Path: Dockerfile.render  ← IMPORTANTE
   Branch: main
   ```

4. **Environment Variables:**
   ```
   SPRING_PROFILES_ACTIVE=dev
   ```

5. **Advanced Settings:**
   ```
   Health Check Path: /api/autores
   Build Timeout: 20 minutes
   Auto-Deploy: Yes
   ```

6. **Create Web Service** → Aguardar build (10-15 min)

---

### Opção B: Via render.yaml (Automático)

1. **Commit arquivos:**
   ```bash
   git add render.yaml Dockerfile.render
   git commit -m "chore: Configurar deploy no Render"
   git push origin main
   ```

2. **Render Dashboard** → New → **Blueprint**

3. **Conectar repositório** → Apply

4. **Pronto!** Render cria tudo automaticamente

---

## 🔧 Se o Erro 502 Persistir

### Solução 1: Retry Manual
```
Aguarde 5-10 minutos
→ Render Dashboard → Manual Deploy
```

O Maven Central pode estar temporariamente indisponível. Esperar e tentar novamente geralmente resolve.

---

### Solução 2: Aumentar Timeout
```
Settings → Advanced
→ Build Timeout: 20 minutes
→ Save Changes → Manual Deploy
```

---

### Solução 3: Build Limpo
```
Settings → Advanced
→ Clear Build Cache
→ Manual Deploy
```

---

### Solução 4: Testar Localmente Primeiro
```bash
# Windows
.\test-render-dockerfile.bat

# PowerShell
.\test-render-dockerfile.ps1
```

Se funcionar localmente, o problema é temporário no Render.

---

## 📊 Diferenças entre Dockerfiles

| Característica | Dockerfile | Dockerfile.render |
|----------------|------------|-------------------|
| Imagem base build | Alpine | Debian (padrão) |
| Maven | Do sistema | Wrapper (./mvnw) |
| Retry logic | Sim (3x) | Sim (3x + plugins) |
| Otimizado para | Local/CI genérico | Render.com |
| Variável PORT | Hardcoded 8080 | Dinâmica ${PORT} |
| Recomendado para | Docker local/compose | Deploy no Render |

---

## 🎯 Checklist de Deploy no Render

Antes de fazer deploy, verifique:

- [x] `Dockerfile.render` existe no repositório
- [x] Código commitado e pushed
- [x] **Dockerfile Path** = `Dockerfile.render` no Render
- [x] Environment Variables configuradas
- [x] Health Check Path = `/api/autores`
- [x] Build Timeout ≥ 15 minutos

---

## 🧪 Testar Antes do Deploy

### Local (Docker)

```bash
# Build
docker build -f Dockerfile.render -t biblioteca-api:render .

# Run
docker run -d -p 8080:8080 -e SPRING_PROFILES_ACTIVE=dev biblioteca-api:render

# Test
curl http://localhost:8080/api/autores
```

### Script Automatizado

```bash
# Windows
.\test-render-dockerfile.bat

# PowerShell/Linux
.\test-render-dockerfile.ps1
```

---

## 📚 Arquivos Criados

### Para Deploy no Render:

| Arquivo | Descrição |
|---------|-----------|
| `Dockerfile.render` | Dockerfile otimizado para Render |
| `render.yaml` | Configuração Blueprint (opcional) |
| `RENDER-DEPLOY.md` | Guia completo de deploy |
| `RENDER-FIX-502.md` | Este documento |

### Scripts de Teste:

| Arquivo | Descrição |
|---------|-----------|
| `test-render-dockerfile.bat` | Teste Windows (Batch) |
| `test-render-dockerfile.ps1` | Teste PowerShell |

### Documentação:

| Arquivo | Descrição |
|---------|-----------|
| `DOCKER.md` | Guia completo Docker |
| `DOCKER-QUICKSTART.md` | Quick start Docker |
| `RENDER-DEPLOY.md` | Guia completo Render |

---

## 🔍 Logs e Debugging

### Ver Logs no Render

```
Dashboard → Logs
→ Filtrar por "ERROR" ou "502"
```

### Logs Locais

```bash
# Durante build
docker build -f Dockerfile.render -t test . 2>&1 | tee build.log

# Durante execução
docker logs -f container-name
```

---

## 💡 Dicas Importantes

### ✅ Boas Práticas

1. **Sempre use `Dockerfile.render`** para deploy no Render
2. **Teste localmente** antes de fazer deploy
3. **Configure health check** corretamente
4. **Aumente timeout** se build for lento
5. **Use retry manual** se falhar (problema geralmente é temporário)

### ⚠️ Evite

1. ❌ Não use `Dockerfile` padrão no Render (não otimizado)
2. ❌ Não force porta 8080 (use variável PORT)
3. ❌ Não desista na primeira falha 502 (tente novamente)
4. ❌ Não use Alpine para build no Render (problemas de compatibilidade)

---

## 📞 Ajuda Adicional

### Documentação Completa

- 📘 **[RENDER-DEPLOY.md](RENDER-DEPLOY.md)** - Guia completo de deploy
- 🐳 **[DOCKER.md](DOCKER.md)** - Documentação Docker completa
- ⚡ **[DOCKER-QUICKSTART.md](DOCKER-QUICKSTART.md)** - Quick start Docker

### Links Úteis

- [Render Documentation](https://render.com/docs)
- [Docker on Render](https://render.com/docs/docker)
- [Maven Repository Status](https://status.maven.org/)

### Suporte

- **GitHub Issues**: Para bugs/problemas
- **Email**: daniloopro@gmail.com
- **LinkedIn**: [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

---

## ✅ Resumo Executivo

### Problema:
Erro 502 ao baixar dependências Maven durante build no Render

### Solução:
1. Usar `Dockerfile.render` otimizado
2. Retry automático implementado
3. Timeouts aumentados
4. Scripts de teste criados

### Como Aplicar:
```
Render Dashboard
→ Settings
→ Dockerfile Path: Dockerfile.render
→ Save
→ Manual Deploy
```

### Resultado Esperado:
✅ Build bem-sucedido
✅ Deploy completo
✅ API funcionando

---

## 🎉 Conclusão

O erro 502 foi resolvido com:

- ✅ Dockerfile otimizado (`Dockerfile.render`)
- ✅ Retry logic implementado
- ✅ Scripts de teste criados
- ✅ Documentação completa
- ✅ Configuração Render (render.yaml)

**Próximo passo:**
```bash
# Testar localmente
.\test-render-dockerfile.bat

# Se funcionar, fazer deploy
Render Dashboard → Manual Deploy (usando Dockerfile.render)
```

---

**🚀 Deploy com sucesso!**

Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

