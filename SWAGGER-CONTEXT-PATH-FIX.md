# 🔧 Fix: Swagger UI Context Path

## ❌ Problema

O Swagger UI estava gerando URLs incorretas sem o `/api`:

```bash
# URL Gerada (ERRADO)
curl -X 'GET' 'http://localhost:8080/autores' -H 'accept: */*'

# URL Esperada (CORRETO)
curl -X 'GET' 'http://localhost:8080/api/autores' -H 'accept: */*'
```

---

## ✅ Solução Aplicada

### Causa do Problema

O `context-path=/api` estava configurado no `application.properties`, mas o Swagger não estava incluindo este prefixo nas URLs dos servidores.

```properties
# application.properties
server.servlet.context-path=/api  # ← Swagger não considerava isso
```

### Correção em OpenApiConfig.java

Atualizei a configuração dos servidores para incluir explicitamente o `/api`:

```java
.servers(List.of(
    new Server()
        .url("http://localhost:8080/api")  // ← /api adicionado
        .description("Servidor Local"),
    new Server()
        .url("https://biblioteca-api.onrender.com/api")  // ← /api adicionado
        .description("Servidor de Produção (Render)")
))
```

---

## 🧪 Como Testar

### 1. Recompilar e Reiniciar

```bash
# Parar aplicação (Ctrl+C se rodando)

# Recompilar
./mvnw clean compile

# Iniciar novamente
./mvnw spring-boot:run
```

### 2. Acessar Swagger UI

```
http://localhost:8080/api/swagger-ui.html
```

### 3. Testar Endpoint

1. Expanda **Autores**
2. Clique em `GET /autores`
3. Clique em **"Try it out"**
4. Clique em **"Execute"**

### 4. Verificar Request URL

Agora deve aparecer:

```
Request URL: http://localhost:8080/api/autores ✅
```

**Antes estava:**
```
Request URL: http://localhost:8080/autores ❌
```

---

## 🔍 Verificação Completa

### cURL Gerado pelo Swagger

```bash
# Agora correto:
curl -X 'GET' \
  'http://localhost:8080/api/autores' \
  -H 'accept: */*'
```

### Testar Manualmente

```bash
# Deve funcionar:
curl http://localhost:8080/api/autores

# Deve retornar 404 (sem /api):
curl http://localhost:8080/autores
```

---

## 📋 Configuração Completa

### application.properties

```properties
# Server Configuration
server.port=8080
server.servlet.context-path=/api  # ← Define prefixo da aplicação

# SpringDoc OpenAPI
springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html
```

### OpenApiConfig.java

```java
@Bean
public OpenAPI customOpenAPI() {
    return new OpenAPI()
        .info(new Info()
            .title("Biblioteca API")
            .version("1.0.0"))
        .servers(List.of(
            new Server()
                .url("http://localhost:8080/api")  // ← URL completa com /api
                .description("Servidor Local"),
            new Server()
                .url("https://sua-app.onrender.com/api")  // ← URL completa com /api
                .description("Produção")
        ));
}
```

---

## 🌐 URLs Corretas

### Desenvolvimento Local

| Recurso | URL Correta |
|---------|-------------|
| **Swagger UI** | `http://localhost:8080/api/swagger-ui.html` |
| **OpenAPI JSON** | `http://localhost:8080/api/api-docs` |
| **API Endpoints** | `http://localhost:8080/api/*` |
| **Exemplo - Autores** | `http://localhost:8080/api/autores` |

### Produção (Render)

| Recurso | URL Correta |
|---------|-------------|
| **Swagger UI** | `https://sua-app.onrender.com/api/swagger-ui.html` |
| **OpenAPI JSON** | `https://sua-app.onrender.com/api/api-docs` |
| **API Endpoints** | `https://sua-app.onrender.com/api/*` |

---

## 🎯 Por Que Usar Context Path?

### Vantagens

1. **Organização**: `/api` separa API de outros recursos
2. **Versionamento**: Facilita versões como `/api/v1`, `/api/v2`
3. **Gateway**: Útil em API Gateways e reverse proxies
4. **Padrão**: Segue convenções REST

### Alternativa (Sem Context Path)

Se preferir URLs sem `/api`, remova do `application.properties`:

```properties
# Comentar ou remover:
# server.servlet.context-path=/api
```

E ajuste os servidores no OpenApiConfig:

```java
.servers(List.of(
    new Server()
        .url("http://localhost:8080")  // ← Sem /api
        .description("Servidor Local")
))
```

**URLs ficariam:**
- Swagger: `http://localhost:8080/swagger-ui.html`
- API: `http://localhost:8080/autores`

---

## 🚨 Troubleshooting

### Swagger UI ainda mostra URLs erradas

**Solução:**

1. **Limpar cache do Maven:**
   ```bash
   ./mvnw clean
   ```

2. **Limpar cache do navegador:**
   - Ctrl+Shift+Delete
   - Limpar cache
   - Recarregar página (Ctrl+F5)

3. **Verificar OpenApiConfig:**
   ```bash
   grep -n "url(\"" src/main/java/com/biblioteca/config/OpenApiConfig.java
   ```

4. **Reiniciar aplicação completamente:**
   ```bash
   # Parar (Ctrl+C)
   ./mvnw clean compile
   ./mvnw spring-boot:run
   ```

---

### 404 Not Found ao testar

**Problema:**
```
GET http://localhost:8080/api/autores → 404 Not Found
```

**Verificações:**

1. **Aplicação está rodando?**
   ```bash
   curl http://localhost:8080/api/actuator/health
   # ou
   curl http://localhost:8080/api/autores
   ```

2. **Context path correto?**
   ```bash
   # Ver logs de inicialização
   # Procurar por: "Tomcat started on port(s): 8080"
   ```

3. **Controller está no package correto?**
   ```java
   package com.biblioteca.controller;  // ← Deve estar aqui
   
   @RestController
   @RequestMapping("/autores")  // ← Path relativo
   ```

---

### Endpoints aparecem duplicados

**Problema:**
Swagger mostra `/api/autores` e `/autores`

**Solução:**

Certifique-se de ter **apenas uma** configuração de server no OpenApiConfig:

```java
// ❌ NÃO faça isso:
.servers(List.of(
    new Server().url("http://localhost:8080"),      // Errado
    new Server().url("http://localhost:8080/api")   // Certo
))

// ✅ Faça isso:
.servers(List.of(
    new Server().url("http://localhost:8080/api")   // Apenas este
))
```

---

## 📝 Checklist de Verificação

Após a correção:

- [x] `OpenApiConfig.java` atualizado com `/api` nas URLs
- [ ] Aplicação recompilada (`./mvnw clean compile`)
- [ ] Aplicação reiniciada
- [ ] Swagger UI recarregado (Ctrl+F5)
- [ ] Request URL mostra `http://localhost:8080/api/autores`
- [ ] Teste "Try it out" funciona
- [ ] cURL gerado está correto

---

## 🎓 Entendendo a Configuração

### Hierarquia de URLs

```
http://localhost:8080          ← Host + Porta
    └── /api                   ← Context Path (application.properties)
        ├── /swagger-ui.html   ← Swagger UI
        ├── /api-docs          ← OpenAPI JSON
        └── /autores           ← Endpoint do Controller
            ├── /{id}
            ├── /search
            └── /nacionalidade/{nac}
```

### Como o Spring Constrói URLs

1. **Base**: `server.port=8080`
2. **Context**: `server.servlet.context-path=/api`
3. **Mapping**: `@RequestMapping("/autores")`
4. **Resultado**: `http://localhost:8080/api/autores`

### Como o Swagger Constrói URLs

1. **Server Base**: `.url("http://localhost:8080/api")` (OpenApiConfig)
2. **Endpoint Path**: `/autores` (do @RequestMapping)
3. **Resultado**: `http://localhost:8080/api/autores`

---

## ✅ Resultado Final

### Antes da Correção ❌

```bash
Request URL: http://localhost:8080/autores
Status: 404 Not Found
```

### Depois da Correção ✅

```bash
Request URL: http://localhost:8080/api/autores
Status: 200 OK
Response: [{ "id": 1, "nome": "Machado", ... }]
```

---

## 📚 Documentação Relacionada

- **[SWAGGER.md](SWAGGER.md)** - Guia completo do Swagger
- **[README.md](README.md#swaggeropenapi)** - Seção Swagger no README
- **[OpenAPI Specification](https://swagger.io/specification/)** - Docs oficiais

---

## 💡 Dicas Adicionais

### Desenvolvimento

Se você frequentemente alterna entre com e sem context path, crie profiles:

```properties
# application.properties (prod com /api)
server.servlet.context-path=/api

# application-dev.properties (dev sem /api)
server.servlet.context-path=
```

E ajuste servers no OpenApiConfig dinamicamente:

```java
@Value("${server.servlet.context-path:}")
private String contextPath;

@Bean
public OpenAPI customOpenAPI() {
    String baseUrl = "http://localhost:8080" + contextPath;
    return new OpenAPI()
        .servers(List.of(
            new Server().url(baseUrl).description("Local")
        ));
}
```

---

**✅ Context path corrigido! URLs do Swagger agora incluem `/api`**

**Reinicie a aplicação para ver as mudanças:**
```bash
./mvnw clean spring-boot:run
```

**Acesse:**
```
http://localhost:8080/api/swagger-ui.html
```

Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

