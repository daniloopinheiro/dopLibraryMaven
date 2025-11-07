# ✅ Configuração Render PostgreSQL - Atualizada

## 📋 Credenciais Atualizadas

### Banco de Dados Render PostgreSQL

| Parâmetro | Valor |
|-----------|-------|
| **User** | `admin` |
| **Password** | `VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c` |
| **External Host** | `dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com` |
| **Port** | `5432` |
| **Database** | `doplibrarymaven` |

---

## ✅ Arquivos Atualizados

### 1. application.properties ✅

```properties
# Database Configuration - Render PostgreSQL (External Host)
spring.datasource.url=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
spring.datasource.username=admin
spring.datasource.password=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

### 2. application-render.properties ✅

```properties
# Database Configuration - Render PostgreSQL (External Host)
spring.datasource.url=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
spring.datasource.username=admin
spring.datasource.password=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

### 3. render.yaml ✅

```yaml
env:
  - key: SPRING_DATASOURCE_URL
    value: jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
  - key: SPRING_DATASOURCE_USERNAME
    value: admin
  - key: SPRING_DATASOURCE_PASSWORD
    value: VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

### 4. docker.env.example ✅

```properties
# SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
# SPRING_DATASOURCE_USERNAME=admin
# SPRING_DATASOURCE_PASSWORD=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

---

## 🔄 Diferença: Internal vs External Host

### External Host (Atual - Configurado)

```
dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com
```

**Características:**
- ✅ Acessível de **qualquer lugar** (internet)
- ✅ Funciona para **conexões externas** (pgAdmin, DBeaver, etc)
- ✅ Funciona para **aplicações fora do Render**
- ⚠️ Requer **SSL** para segurança
- ⚠️ Pode ter **latência** maior se app estiver no Render

**Uso:**
- Desenvolvimento local
- Ferramentas externas (pgAdmin, DBeaver)
- Apps hospedados fora do Render
- Deploy inicial no Render

### Internal Host (Alternativa)

```
dpg-d46j4c0dl3ps73bo34t0-a
```

**Características:**
- ✅ **Mais rápido** (rede interna do Render)
- ✅ **Mais seguro** (não exposto à internet)
- ✅ **Melhor performance** entre serviços Render
- ❌ Só funciona **dentro do Render**
- ❌ Não acessível de ferramentas externas

**Uso:**
- Apps em produção no Render
- Serviços comunicando dentro do Render
- Melhor performance em produção

---

## 🚀 Como Usar

### Desenvolvimento Local

```bash
# Iniciar aplicação
./mvnw spring-boot:run

# A aplicação conectará ao Render PostgreSQL (External Host)
# URL: http://localhost:8080/api/autores
# Swagger: http://localhost:8080/api/swagger-ui.html
```

### Docker Local

```bash
# Build
docker build -t biblioteca-api:latest .

# Run conectando ao Render
docker run -d \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven \
  -e SPRING_DATASOURCE_USERNAME=admin \
  -e SPRING_DATASOURCE_PASSWORD=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c \
  biblioteca-api:latest
```

### Deploy no Render

**Opção 1: Via Dashboard (Variáveis de Ambiente)**

```properties
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
SPRING_DATASOURCE_USERNAME=admin
SPRING_DATASOURCE_PASSWORD=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

**Opção 2: Via render.yaml (Blueprint)**

Já configurado! Basta fazer push do código.

```bash
git add .
git commit -m "chore: Atualizar configuração banco Render"
git push origin main
```

---

## 🔗 Conectar via pgAdmin

### Configuração pgAdmin

1. **Add New Server**
2. **General Tab:**
   - Name: `Render - dopLibraryMaven`
3. **Connection Tab:**
   - Host: `dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com`
   - Port: `5432`
   - Database: `doplibrarymaven`
   - Username: `admin`
   - Password: `VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c`
4. **SSL Tab:**
   - SSL Mode: `Prefer` ou `Require`

### Conectar via Terminal (psql)

```bash
psql -h dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com \
     -p 5432 \
     -U admin \
     -d doplibrarymaven
```

Quando solicitar senha, digite:
```
VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

---

## 🧪 Testar Conexão

### 1. Via Aplicação

```bash
# Iniciar aplicação
./mvnw spring-boot:run

# Verificar logs - procurar por:
# - "HikariPool-1 - Start completed"
# - "Started BibliotecaApplication"

# Testar endpoint
curl http://localhost:8080/api/autores
```

### 2. Via psql

```bash
psql -h dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com \
     -p 5432 -U admin -d doplibrarymaven

# Listar tabelas
\dt

# Ver autores
SELECT * FROM autor;

# Sair
\q
```

### 3. Via API REST

```bash
# Health check (se configurado)
curl http://localhost:8080/actuator/health

# Listar autores
curl http://localhost:8080/api/autores

# Swagger UI
http://localhost:8080/api/swagger-ui.html
```

---

## ⚙️ Configurações Recomendadas

### Para Desenvolvimento Local

```properties
# application.properties (atual)
spring.datasource.url=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
```

✅ **Vantagens:**
- Testa com banco real de produção
- Dados persistem entre execuções
- Mesmo ambiente que produção

### Para Produção no Render

**Recomendação:** Use **Internal Host** para melhor performance

```properties
# Via Variáveis de Ambiente no Render Dashboard
SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a:5432/doplibrarymaven
```

✅ **Vantagens:**
- Mais rápido (rede interna)
- Mais seguro
- Sem latência externa

### Para Ferramentas Externas (pgAdmin, DBeaver)

```
Host: dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com
```

✅ Sempre use **External Host**

---

## 📝 Checklist

### Configuração Atual

- [x] External Host configurado
- [x] Username: `admin`
- [x] Password atualizado
- [x] Database: `doplibrarymaven`
- [x] Port: `5432`
- [x] `application.properties` atualizado
- [x] `application-render.properties` atualizado
- [x] `render.yaml` atualizado
- [x] `docker.env.example` atualizado

### Testes

- [ ] Conexão via psql
- [ ] Conexão via pgAdmin
- [ ] Aplicação local conecta
- [ ] Deploy no Render funciona

---

## 🔒 Segurança

### ⚠️ Importante

1. **Não commite credenciais** em repositórios públicos
   - Considere usar `.env` local (gitignored)
   - Use variáveis de ambiente no Render

2. **Rotação de senha**
   - Mude a senha periodicamente
   - Atualize em todos os lugares

3. **SSL/TLS**
   - External Host suporta SSL
   - Adicione `?sslmode=require` se necessário

4. **Firewall**
   - Render gerencia automaticamente
   - Configure IP allowlist se necessário

---

## 📊 Connection String Completa

### Formato JDBC (Java/Spring Boot)

```
jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
```

### Formato Standard (psql, pgAdmin)

```
postgresql://admin:VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c@dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
```

### Com SSL

```
jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven?sslmode=require
```

---

## 🚨 Troubleshooting

### Erro: Connection timeout

**Problema:**
```
Connection timed out
```

**Soluções:**
1. Verificar firewall/antivírus
2. Verificar conectividade internet
3. Testar com `ping` ou `telnet`:
   ```bash
   telnet dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com 5432
   ```

### Erro: Authentication failed

**Problema:**
```
FATAL: password authentication failed for user "admin"
```

**Soluções:**
1. Verificar senha (copiar/colar para evitar erros)
2. Verificar username (`admin` não `postgres`)
3. Resetar senha no Render Dashboard

### Erro: SSL connection required

**Problema:**
```
SSL connection is required
```

**Solução:**

Adicionar parâmetro SSL:
```properties
spring.datasource.url=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven?sslmode=require
```

---

## 📚 Documentação Adicional

- **[DATABASE-CONFIG.md](DATABASE-CONFIG.md)** - Guia completo de configuração
- **[RENDER-DEPLOY.md](RENDER-DEPLOY.md)** - Guia de deploy no Render
- **[README.md](README.md)** - Documentação principal

---

## ✅ Resumo

### Configuração Aplicada

```properties
Host: dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com
Port: 5432
Database: doplibrarymaven
Username: admin
Password: VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

### Arquivos Atualizados

- ✅ `application.properties`
- ✅ `application-render.properties`
- ✅ `render.yaml`
- ✅ `docker.env.example`

### Próximos Passos

1. **Testar localmente:**
   ```bash
   ./mvnw spring-boot:run
   curl http://localhost:8080/api/autores
   ```

2. **Commit mudanças:**
   ```bash
   git add .
   git commit -m "chore: Atualizar configuração banco Render"
   git push
   ```

3. **Deploy no Render** (automático se auto-deploy ativo)

---

**✅ Configuração do banco de dados Render PostgreSQL atualizada com sucesso!**

**🔗 Connection String:**
```
jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com:5432/doplibrarymaven
```

Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

