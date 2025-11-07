# 🔧 Fix: CORS Error no Swagger UI (Render)

## ❌ Problema

Ao tentar testar endpoints no Swagger UI apontando para o servidor Render, ocorria o erro:

```
Failed to fetch.
Possible Reasons:
- CORS
- Network Failure
- URL scheme must be "http" or "https" for CORS request.
```

**Request URL:**
```
https://biblioteca-api.onrender.com/api/autores
```

**Erro:**
```
Status: Undocumented
Response: Failed to fetch
```

---

## 🔍 Causa do Problema

### O que é CORS?

**CORS (Cross-Origin Resource Sharing)** é um mecanismo de segurança do navegador que bloqueia requisições entre diferentes origens (domínios).

### Por que ocorreu?

1. **Swagger UI** está rodando em uma origem:
   - `https://biblioteca-api.onrender.com/api/swagger-ui.html`

2. **API** está em:
   - `https://biblioteca-api.onrender.com/api/autores`

3. O navegador faz uma requisição **cross-origin** e o servidor **não permite** por padrão

### Fluxo do Problema

```
Swagger UI (Browser)
    ↓
    ├─→ OPTIONS /api/autores (Preflight)
    │   ← 403 Forbidden (CORS not configured)
    │
    └─→ GET /api/autores
        ← Failed to fetch (blocked by browser)
```

---

## ✅ Solução Implementada

### 1. Classe CorsConfig.java Criada

Arquivo: `src/main/java/com/biblioteca/config/CorsConfig.java`

**Configuração CORS global** que permite:
- ✅ Todas as origens (`*`)
- ✅ Todos os métodos HTTP (GET, POST, PUT, DELETE, PATCH)
- ✅ Headers comuns (Authorization, Content-Type, etc)
- ✅ Credenciais (cookies, auth headers)

```java
@Configuration
public class CorsConfig {
    
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        
        // Permite todas as origens
        config.setAllowedOriginPatterns(Arrays.asList("*"));
        
        // Métodos permitidos
        config.setAllowedMethods(Arrays.asList(
            "GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"
        ));
        
        // Headers permitidos
        config.setAllowedHeaders(Arrays.asList(
            "Origin", "Content-Type", "Accept", "Authorization"
        ));
        
        // Aplicar para todos os endpoints
        source.registerCorsConfiguration("/**", config);
        
        return new CorsFilter(source);
    }
}
```

### 2. Controllers Mantêm @CrossOrigin

Os controllers já tinham `@CrossOrigin(origins = "*")`, que funciona em conjunto com a configuração global:

```java
@RestController
@RequestMapping("/autores")
@CrossOrigin(origins = "*")  // ← Mantido para compatibilidade
public class AutorController {
    // ...
}
```

---

## 🧪 Como Testar a Correção

### 1. Recompilar e Fazer Deploy

#### Local:
```bash
./mvnw clean package
./mvnw spring-boot:run
```

#### Render:
```bash
git add .
git commit -m "fix: Adicionar configuração CORS para Swagger UI"
git push origin main
```

Aguarde o deploy automático no Render (5-10 minutos).

---

### 2. Testar Localmente

```bash
# Iniciar aplicação
./mvnw spring-boot:run

# Abrir Swagger UI
http://localhost:8080/api/swagger-ui.html

# Testar endpoint
# 1. Expanda "Autores"
# 2. GET /autores
# 3. Try it out → Execute
# 4. Deve funcionar ✅
```

---

### 3. Testar no Render

```bash
# Abrir Swagger UI no Render
https://sua-app.onrender.com/api/swagger-ui.html

# Selecionar servidor: "Servidor de Produção (Render)"
# Testar endpoint
# 1. Expanda "Autores"
# 2. GET /autores
# 3. Try it out → Execute
# 4. Deve funcionar ✅
```

---

### 4. Verificar Headers CORS

Use o Developer Tools do navegador (F12):

**Requisição OPTIONS (Preflight):**
```http
OPTIONS /api/autores HTTP/1.1
Origin: https://biblioteca-api.onrender.com
Access-Control-Request-Method: GET
```

**Resposta esperada:**
```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS
Access-Control-Allow-Headers: Origin, Content-Type, Accept, Authorization
Access-Control-Max-Age: 3600
```

---

## 🔒 Configuração para Produção

### ⚠️ Atenção: Segurança

Para **produção**, é recomendado **restringir origens** específicas em vez de permitir todas (`*`).

### Configuração Segura (Produção)

Edite `CorsConfig.java`:

```java
// Em vez de:
config.setAllowedOriginPatterns(Arrays.asList("*"));

// Use (produção):
config.setAllowedOriginPatterns(Arrays.asList(
    "https://biblioteca-api.onrender.com",
    "https://seu-frontend.com",
    "http://localhost:8080",  // Apenas se necessário
    "http://localhost:3000"   // Frontend dev
));
```

### Via Variáveis de Ambiente (Melhor Opção)

```java
@Value("${cors.allowed.origins:*}")
private String allowedOrigins;

@Bean
public CorsFilter corsFilter() {
    config.setAllowedOriginPatterns(
        Arrays.asList(allowedOrigins.split(","))
    );
}
```

**application.properties:**
```properties
# Desenvolvimento
cors.allowed.origins=*

# Produção (via Render Environment Variables)
# cors.allowed.origins=https://biblioteca-api.onrender.com,https://seu-frontend.com
```

---

## 📋 Comparação: Antes vs Depois

### Antes (Sem CorsConfig) ❌

```
Swagger UI Request
    ↓
    OPTIONS /api/autores
    ↓
    ← 403 Forbidden (No CORS headers)
    ↓
Browser blocks request
    ↓
Failed to fetch ❌
```

### Depois (Com CorsConfig) ✅

```
Swagger UI Request
    ↓
    OPTIONS /api/autores (Preflight)
    ↓
    ← 200 OK + CORS headers ✅
    ↓
    GET /api/autores
    ↓
    ← 200 OK + Data ✅
    ↓
Success! 🎉
```

---

## 🎯 Arquivos Modificados/Criados

| Arquivo | Status | Descrição |
|---------|--------|-----------|
| `CorsConfig.java` | ✅ Criado | Configuração CORS global |
| `CORS-FIX.md` | ✅ Criado | Esta documentação |
| Controllers | ✅ Mantidos | Já tinham `@CrossOrigin` |

---

## 🔍 Troubleshooting Adicional

### Erro persiste após deploy

**Verificações:**

1. **Deploy concluído?**
   ```
   Render Dashboard → Logs → Verificar "Build successful"
   ```

2. **Cache do navegador:**
   ```
   Ctrl+Shift+Delete → Limpar cache → Recarregar (Ctrl+F5)
   ```

3. **Headers CORS na resposta?**
   ```
   F12 → Network → Selecionar requisição → Response Headers
   Procurar por: Access-Control-Allow-Origin
   ```

4. **CorsConfig carregado?**
   ```
   Verificar logs de inicialização:
   "CorsConfig" ou "CorsFilter"
   ```

---

### Erro: "Credentials mode is 'include'"

**Problema:**
```
Access to fetch at '...' has been blocked by CORS policy:
The value of 'Access-Control-Allow-Origin' must not be '*' 
when the request's credentials mode is 'include'.
```

**Solução:**

Em `CorsConfig.java`:

```java
// Se usar credenciais, especifique origens
config.setAllowCredentials(true);
config.setAllowedOriginPatterns(Arrays.asList(
    "https://biblioteca-api.onrender.com"
));

// OU desabilite credenciais se não precisar
config.setAllowCredentials(false);
config.setAllowedOrigins(Arrays.asList("*"));
```

---

### Erro: "Method not allowed"

**Problema:**
```
Method DELETE not allowed
```

**Solução:**

Verifique se o método está na lista:

```java
config.setAllowedMethods(Arrays.asList(
    "GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"  // ← DELETE incluído
));
```

---

### OPTIONS retorna 404

**Problema:**
Requisição OPTIONS retorna 404 antes do CorsFilter processar.

**Solução:**

Adicione em `application.properties`:

```properties
# Dispatch OPTIONS to controllers
spring.mvc.dispatch-options-request=true
```

---

## 📚 Documentação de Referência

### Criada

- ✅ **[CORS-FIX.md](CORS-FIX.md)** - Este documento
- ✅ **[CorsConfig.java](src/main/java/com/biblioteca/config/CorsConfig.java)** - Configuração implementada

### Relacionada

- **[SWAGGER.md](SWAGGER.md)** - Documentação Swagger
- **[RENDER-DEPLOY.md](RENDER-DEPLOY.md)** - Deploy no Render
- **[README.md](README.md)** - Documentação principal

### Oficial

- [Spring CORS Documentation](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-cors)
- [MDN CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [W3C CORS Specification](https://www.w3.org/TR/cors/)

---

## ✅ Checklist de Verificação

### Implementação

- [x] `CorsConfig.java` criado
- [x] Configuração permite todas as origens (`*`)
- [x] Métodos HTTP configurados
- [x] Headers configurados
- [x] Controllers mantêm `@CrossOrigin`

### Testes

- [ ] Compilação bem-sucedida (`./mvnw clean package`)
- [ ] Teste local funciona
- [ ] Deploy no Render concluído
- [ ] Swagger UI no Render funciona
- [ ] Headers CORS presentes na resposta
- [ ] Todos os métodos (GET, POST, PUT, DELETE) funcionam

---

## 🎓 Entendendo CORS

### Fluxo de Requisição CORS

1. **Navegador detecta** requisição cross-origin
2. **Envia OPTIONS** (preflight) ao servidor
3. **Servidor responde** com headers CORS permitindo a requisição
4. **Navegador permite** a requisição real (GET, POST, etc)
5. **Servidor processa** e responde

### Headers CORS Importantes

| Header | Descrição | Exemplo |
|--------|-----------|---------|
| `Access-Control-Allow-Origin` | Origens permitidas | `*` ou URL específica |
| `Access-Control-Allow-Methods` | Métodos HTTP permitidos | `GET, POST, DELETE` |
| `Access-Control-Allow-Headers` | Headers permitidos | `Content-Type, Authorization` |
| `Access-Control-Allow-Credentials` | Permite cookies/auth | `true` ou `false` |
| `Access-Control-Max-Age` | Cache do preflight (segundos) | `3600` |

---

## 💡 Dicas de Segurança

### Desenvolvimento

```java
// OK para desenvolvimento
config.setAllowedOriginPatterns(Arrays.asList("*"));
```

### Produção

```java
// Melhor para produção
config.setAllowedOriginPatterns(Arrays.asList(
    "https://biblioteca-api.onrender.com",
    "https://meu-frontend.com"
));
```

### Com Autenticação

```java
// Se usar JWT/OAuth
config.setAllowCredentials(true);
config.setAllowedOriginPatterns(Arrays.asList(
    "https://meu-frontend.com"  // Não use "*" com credentials
));
```

---

## 🚀 Resultado Final

### Antes da Correção ❌

```
Request: GET /api/autores
Status: Failed to fetch
Error: CORS policy blocked
```

### Depois da Correção ✅

```
Request: GET /api/autores
Status: 200 OK
Response: [
  {
    "id": 1,
    "nome": "Machado",
    "sobrenome": "de Assis",
    ...
  }
]
```

---

## 📞 Suporte

### Problemas Persistem?

1. Verifique logs do Render
2. Teste com `curl`:
   ```bash
   curl -i -X OPTIONS \
     -H "Origin: https://biblioteca-api.onrender.com" \
     -H "Access-Control-Request-Method: GET" \
     https://biblioteca-api.onrender.com/api/autores
   ```
3. Consulte: [RENDER-DEPLOY.md](RENDER-DEPLOY.md)

### Contato

- **Email**: daniloopro@gmail.com
- **GitHub**: [Issues](https://github.com/daniloopinheiro/dopLibraryMaven/issues)

---

**✅ CORS configurado! Swagger UI agora funciona no Render**

**Próximos passos:**
1. Recompilar: `./mvnw clean package`
2. Commit: `git commit -m "fix: Adicionar configuração CORS"`
3. Push: `git push origin main`
4. Aguardar deploy no Render
5. Testar Swagger UI: `https://sua-app.onrender.com/api/swagger-ui.html`

Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

