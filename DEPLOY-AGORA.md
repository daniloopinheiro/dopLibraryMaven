# 🚀 Deploy Imediato - Correções CORS + URL

## ✅ Correções Aplicadas

### 1. URL do Render Corrigida
- ❌ **Antes**: `https://biblioteca-api.onrender.com/api`
- ✅ **Agora**: `https://doplibrarymaven.onrender.com/api`

### 2. CORS Configurado
- ✅ `CorsConfig.java` criado
- ✅ Permite requisições cross-origin do Swagger UI

---

## 🚀 Comandos para Deploy

### Execute Agora:

```bash
# 1. Ver o que mudou
git status

# 2. Adicionar todas as mudanças
git add .

# 3. Commit
git commit -m "fix: Corrigir URL Render e adicionar configuração CORS"

# 4. Push (dispara deploy automático)
git push origin main
```

---

## ⏳ Aguardar Deploy

### No Render Dashboard:

1. Acesse: https://dashboard.render.com
2. Clique no seu serviço: **doplibrarymaven**
3. Veja os logs em tempo real
4. Aguarde mensagem: **"Your service is live 🎉"**
5. Tempo estimado: **5-10 minutos**

---

## 🧪 Testar Após Deploy

### 1. Acessar Swagger UI

```
https://doplibrarymaven.onrender.com/api/swagger-ui.html
```

### 2. Selecionar Servidor Correto

No dropdown de servidores, selecione:
```
Servidor de Produção (Render)
https://doplibrarymaven.onrender.com/api
```

### 3. Testar Endpoint

1. Expanda **"Autores"**
2. Clique em `GET /autores`
3. Clique em **"Try it out"**
4. Clique em **"Execute"**
5. ✅ **Deve funcionar agora!**

---

## ✅ O Que Será Corrigido

### Problema 1: URL Incorreta ❌
```
Request URL: https://biblioteca-api.onrender.com/api/autores
Error: ERR_NAME_NOT_RESOLVED
```

### Solução 1: URL Corrigida ✅
```
Request URL: https://doplibrarymaven.onrender.com/api/autores
Status: 200 OK
```

### Problema 2: CORS Error ❌
```
Failed to fetch.
Possible Reasons: CORS
```

### Solução 2: CORS Configurado ✅
```
Headers: Access-Control-Allow-Origin: *
Status: 200 OK
Response: [{ "id": 1, ... }]
```

---

## 📋 Arquivos que Serão Atualizados no Deploy

| Arquivo | Mudança |
|---------|---------|
| `OpenApiConfig.java` | URL corrigida para `doplibrarymaven.onrender.com` |
| `CorsConfig.java` | Novo arquivo - configuração CORS |
| `render.yaml` | Nome do serviço corrigido |

---

## 🔍 Verificar se Funcionou

### Via cURL (Terminal)

```bash
# Deve retornar JSON com autores
curl https://doplibrarymaven.onrender.com/api/autores
```

### Via Navegador

```
https://doplibrarymaven.onrender.com/api/autores
```

Deve exibir JSON:
```json
[
  {
    "id": 1,
    "nome": "...",
    ...
  }
]
```

### Via Swagger UI

```
https://doplibrarymaven.onrender.com/api/swagger-ui.html
```

1. Selecione servidor Render
2. Teste qualquer endpoint
3. Deve retornar 200 OK

---

## 🚨 Se Ainda Não Funcionar

### 1. Verificar Logs do Render

```
Dashboard → doplibrarymaven → Logs
```

Procurar por:
- ✅ "Your service is live"
- ✅ "Started BibliotecaApplication"
- ❌ Erros de inicialização

### 2. Verificar Headers CORS

F12 (Developer Tools) → Network → Selecionar requisição → Response Headers

Deve ter:
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS
```

### 3. Limpar Cache do Navegador

```
Ctrl+Shift+Delete
→ Limpar cache
→ Recarregar: Ctrl+F5
```

### 4. Testar Diretamente (sem Swagger)

```bash
curl https://doplibrarymaven.onrender.com/api/autores
```

Se funcionar via curl mas não no Swagger = problema de cache do navegador.

---

## 📊 Timeline Esperada

| Tempo | Ação |
|-------|------|
| **Agora** | `git push origin main` |
| **+1 min** | Render detecta push e inicia build |
| **+5 min** | Build do Docker concluído |
| **+8 min** | Deploy em andamento |
| **+10 min** | "Your service is live 🎉" |
| **+11 min** | Swagger UI funcionando ✅ |

---

## 🎯 URLs Corretas (Final)

### Produção (Render)

| Recurso | URL |
|---------|-----|
| **Swagger UI** | `https://doplibrarymaven.onrender.com/api/swagger-ui.html` |
| **OpenAPI JSON** | `https://doplibrarymaven.onrender.com/api/api-docs` |
| **API Autores** | `https://doplibrarymaven.onrender.com/api/autores` |
| **API Livros** | `https://doplibrarymaven.onrender.com/api/livros` |
| **API Empréstimos** | `https://doplibrarymaven.onrender.com/api/emprestimos` |

### Desenvolvimento (Local)

| Recurso | URL |
|---------|-----|
| **Swagger UI** | `http://localhost:8080/api/swagger-ui.html` |
| **API** | `http://localhost:8080/api/*` |

---

## ✅ Checklist Final

Antes de fazer push:

- [x] URL corrigida no OpenApiConfig.java
- [x] CorsConfig.java criado
- [x] render.yaml atualizado
- [ ] **git add .**
- [ ] **git commit**
- [ ] **git push origin main**
- [ ] Aguardar deploy no Render
- [ ] Testar Swagger UI
- [ ] Testar endpoints

---

## 💡 Comandos Rápidos

```bash
# Deploy completo (copie e cole)
git add . && \
git commit -m "fix: Corrigir URL Render e adicionar CORS" && \
git push origin main && \
echo "✅ Push realizado! Aguarde 10 minutos e teste:"
echo "https://doplibrarymaven.onrender.com/api/swagger-ui.html"
```

---

## 📞 Se Precisar de Ajuda

### Logs do Deploy

```
Render Dashboard → doplibrarymaven → Logs
```

### Documentação

- **CORS**: [CORS-FIX.md](CORS-FIX.md)
- **Swagger**: [SWAGGER.md](SWAGGER.md)
- **Render**: [RENDER-DEPLOY.md](RENDER-DEPLOY.md)

---

**🚀 Execute os comandos acima e aguarde o deploy!**

**Em 10 minutos o Swagger UI estará funcionando perfeitamente! ✅**

Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

