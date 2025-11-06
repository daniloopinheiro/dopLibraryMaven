# ⚡ Fix Rápido - Erro 502 no Render

## 🔴 Erro

```
status code: 502, reason phrase: Bad Gateway (502)
```

## ✅ Solução (30 segundos)

### 1. No Render Dashboard

```
Settings → Dockerfile Path
↓
Mude de: Dockerfile
Para: Dockerfile.render
↓
Save Changes
↓
Manual Deploy
```

### 2. Aguarde 10-15 minutos

O build será bem-sucedido! ✅

---

## 🎯 Se Ainda Falhar

### Retry (Mais Comum)
```
Aguarde 5 minutos → Manual Deploy novamente
```

### Aumentar Timeout
```
Settings → Advanced → Build Timeout: 20 minutes
```

### Build Limpo
```
Settings → Advanced → Clear Build Cache → Deploy
```

---

## 🧪 Testar Localmente Antes

```bash
# Windows
.\test-render-dockerfile.bat

# PowerShell
.\test-render-dockerfile.ps1
```

Se funcionar = vai funcionar no Render!

---

## 📚 Documentação Completa

- 🔧 **[RENDER-FIX-502.md](RENDER-FIX-502.md)** - Solução detalhada
- 🚀 **[RENDER-DEPLOY.md](RENDER-DEPLOY.md)** - Guia completo
- 🐳 **[DOCKER.md](DOCKER.md)** - Docker completo

---

## ✅ Checklist

- [ ] Dockerfile Path = `Dockerfile.render`
- [ ] Environment Variables configuradas
- [ ] Health Check Path = `/api/autores`
- [ ] Build Timeout ≥ 15 min

---

**Pronto para deploy!** 🚀

