# 🗄️ Configuração de Banco de Dados - Biblioteca API

Guia completo para configurar diferentes bancos de dados no projeto.

---

## 📋 Índice

1. [Render PostgreSQL (Produção)](#render-postgresql-produção)
2. [PostgreSQL Local](#postgresql-local)
3. [H2 Database (Desenvolvimento)](#h2-database-desenvolvimento)
4. [Supabase PostgreSQL](#supabase-postgresql)
5. [Como Alternar Entre Ambientes](#como-alternar-entre-ambientes)
6. [Variáveis de Ambiente](#variáveis-de-ambiente)
7. [Troubleshooting](#troubleshooting)

---

## Render PostgreSQL (Produção)

### ✅ Configuração Atual (Atualizada)

**Credenciais do Render Database:**

| Parâmetro | Valor |
|-----------|-------|
| **Hostname** (Internal) | `dpg-d46j4c0dl3ps73bo34t0-a` |
| **Port** | `5432` |
| **Database** | `doplibrarymaven` |
| **Username** | `admin` |
| **Password** | `VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c` |

### 📝 Configurações Atualizadas

#### 1. application.properties (Padrão/Produção)

Já atualizado com as novas credenciais:

```properties
# Database Configuration - Render PostgreSQL
spring.datasource.url=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a:5432/doplibrarymaven
spring.datasource.username=admin
spring.datasource.password=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

#### 2. application-render.properties (Específico)

Arquivo criado para profile Render:

```bash
# Usar profile render
java -jar app.jar --spring.profiles.active=render
```

### 🚀 Deploy no Render

#### Opção 1: Via Variáveis de Ambiente (Recomendado)

No **Render Dashboard** → **Environment Variables**:

```properties
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a:5432/doplibrarymaven
SPRING_DATASOURCE_USERNAME=admin
SPRING_DATASOURCE_PASSWORD=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

#### Opção 2: Via Profile Render

```properties
SPRING_PROFILES_ACTIVE=render
```

O arquivo `application-render.properties` já contém as credenciais.

### 🔒 Segurança

**⚠️ IMPORTANTE:**

1. **Não commite credenciais** no Git para repositórios públicos
2. **Use variáveis de ambiente** no Render
3. **Rotacione passwords** periodicamente
4. **Use Internal Hostname** (mais seguro) dentro do Render

### 🌐 Hostnames do Render

| Tipo | Hostname | Uso |
|------|----------|-----|
| **Internal** | `dpg-d46j4c0dl3ps73bo34t0-a` | Conexões entre serviços Render (recomendado) |
| **External** | `dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com` | Conexões externas (pgAdmin, etc) |

**No Render, use sempre o Internal Hostname** para melhor performance e segurança.

---

## PostgreSQL Local

### 🐳 Docker (Recomendado)

```bash
# Iniciar PostgreSQL com Docker Compose
docker-compose -f docker-compose-app.yml up -d postgres
```

**Configuração:**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/biblioteca
spring.datasource.username=postgres
spring.datasource.password=postgres
```

### 🖥️ PostgreSQL Instalado Localmente

**Criar banco:**
```sql
CREATE DATABASE biblioteca;
CREATE USER admin WITH PASSWORD 'sua-senha';
GRANT ALL PRIVILEGES ON DATABASE biblioteca TO admin;
```

**Configurar:**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/biblioteca
spring.datasource.username=admin
spring.datasource.password=sua-senha
```

---

## H2 Database (Desenvolvimento)

### 💡 Mais Fácil para Desenvolvimento

```bash
# Usar profile dev
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

**Configuração (application-dev.properties):**
```properties
spring.datasource.url=jdbc:h2:mem:biblioteca
spring.datasource.username=sa
spring.datasource.password=
```

**Acessar Console H2:**
```
http://localhost:8080/api/h2-console
```

**Login:**
- JDBC URL: `jdbc:h2:mem:biblioteca`
- Username: `sa`
- Password: (vazio)

---

## Supabase PostgreSQL

### ☁️ Banco na Nuvem (Alternativa)

```properties
spring.datasource.url=jdbc:postgresql://seu-projeto.supabase.co:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=sua-senha-supabase
```

**⚠️ Importante no Supabase:**

Execute antes da primeira inicialização:
```sql
CREATE TYPE status_emprestimo AS ENUM ('EMPRESTADO', 'DEVOLVIDO', 'ATRASADO');
```

---

## Como Alternar Entre Ambientes

### Método 1: Profiles do Spring

```bash
# H2 (Desenvolvimento)
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# PostgreSQL Local
./mvnw spring-boot:run -Dspring-boot.run.profiles=default

# Render
./mvnw spring-boot:run -Dspring-boot.run.profiles=render

# Supabase
./mvnw spring-boot:run -Dspring-boot.run.profiles=supabase
```

### Método 2: Variáveis de Ambiente

```bash
# Linux/Mac
export SPRING_PROFILES_ACTIVE=dev
./mvnw spring-boot:run

# Windows PowerShell
$env:SPRING_PROFILES_ACTIVE="dev"
.\mvnw.cmd spring-boot:run

# Windows CMD
set SPRING_PROFILES_ACTIVE=dev
mvnw.cmd spring-boot:run
```

### Método 3: Docker

```bash
# Com variáveis de ambiente
docker run -d \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host:5432/db \
  -e SPRING_DATASOURCE_USERNAME=admin \
  -e SPRING_DATASOURCE_PASSWORD=senha \
  biblioteca-api:latest
```

### Método 4: application.properties

Edite diretamente o arquivo `application.properties` (não recomendado para produção).

---

## Variáveis de Ambiente

### 🔧 Principais Variáveis

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `SPRING_PROFILES_ACTIVE` | Profile ativo | `dev`, `render`, `prod` |
| `SPRING_DATASOURCE_URL` | URL do banco | `jdbc:postgresql://host:5432/db` |
| `SPRING_DATASOURCE_USERNAME` | Usuário | `admin` |
| `SPRING_DATASOURCE_PASSWORD` | Senha | `senha-segura` |
| `SPRING_JPA_HIBERNATE_DDL_AUTO` | Estratégia JPA | `update`, `create`, `validate` |

### 📋 Configuração Completa (Render)

```bash
# Render Environment Variables
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a:5432/doplibrarymaven
SPRING_DATASOURCE_USERNAME=admin
SPRING_DATASOURCE_PASSWORD=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_JPA_SHOW_SQL=false
```

---

## Troubleshooting

### ❌ Erro: Connection refused

**Problema:**
```
Connection to localhost:5432 refused
```

**Soluções:**

1. **Verificar se PostgreSQL está rodando:**
   ```bash
   # Docker
   docker ps | grep postgres
   
   # Local (Linux)
   sudo systemctl status postgresql
   
   # Local (Windows)
   services.msc # Procurar PostgreSQL
   ```

2. **Verificar hostname:**
   - Local: `localhost`
   - Docker interno: `postgres` (nome do serviço)
   - Render: `dpg-d46j4c0dl3ps73bo34t0-a`

3. **Verificar porta:**
   ```bash
   netstat -an | grep 5432
   ```

---

### ❌ Erro: Authentication failed

**Problema:**
```
FATAL: password authentication failed for user "admin"
```

**Soluções:**

1. **Verificar credenciais:**
   - Username correto?
   - Password correto?
   - Copiar/colar para evitar erros de digitação

2. **Verificar variáveis de ambiente:**
   ```bash
   # Linux/Mac
   echo $SPRING_DATASOURCE_USERNAME
   echo $SPRING_DATASOURCE_PASSWORD
   
   # Windows PowerShell
   $env:SPRING_DATASOURCE_USERNAME
   $env:SPRING_DATASOURCE_PASSWORD
   ```

3. **Resetar password no Render:**
   - Render Dashboard → Database → Settings → Reset Password

---

### ❌ Erro: Database does not exist

**Problema:**
```
FATAL: database "doplibrarymaven" does not exist
```

**Soluções:**

1. **Verificar nome do banco:**
   ```properties
   # Deve ser exatamente:
   spring.datasource.url=jdbc:postgresql://...5432/doplibrarymaven
   ```

2. **Criar banco (se local):**
   ```sql
   CREATE DATABASE doplibrarymaven;
   ```

3. **Verificar no Render:**
   - Dashboard → Database → Info → Database Name

---

### ❌ Erro: Too many connections

**Problema:**
```
FATAL: too many connections for role "admin"
```

**Soluções:**

1. **Reduzir pool de conexões:**
   ```properties
   spring.datasource.hikari.maximum-pool-size=3
   spring.datasource.hikari.minimum-idle=1
   ```

2. **Fechar conexões antigas:**
   ```sql
   SELECT pg_terminate_backend(pid)
   FROM pg_stat_activity
   WHERE datname = 'doplibrarymaven'
   AND pid <> pg_backend_pid();
   ```

3. **Upgrade plano no Render** (Free tier tem limite de conexões)

---

### ❌ Erro: SSL connection required

**Problema:**
```
FATAL: SSL connection is required
```

**Solução:**

Adicionar `?sslmode=require` na URL:
```properties
spring.datasource.url=jdbc:postgresql://host:5432/db?sslmode=require
```

---

### ❌ Erro: Timezone

**Problema:**
```
The server's time zone value is unknown
```

**Solução:**

Adicionar timezone na URL:
```properties
spring.datasource.url=jdbc:postgresql://host:5432/db?serverTimezone=America/Sao_Paulo
```

---

## 🔍 Verificação de Conexão

### Testar Conexão Manualmente

#### Via psql (Terminal)

```bash
# Local
psql -h localhost -p 5432 -U admin -d biblioteca

# Render (External - para teste)
psql -h dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com -p 5432 -U admin -d doplibrarymaven
```

#### Via pgAdmin

1. **Add New Server**
2. **Connection:**
   - Host: `dpg-d46j4c0dl3ps73bo34t0-a.oregon-postgres.render.com` (External)
   - Port: `5432`
   - Database: `doplibrarymaven`
   - Username: `admin`
   - Password: `VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c`

#### Via Aplicação

```bash
# Iniciar aplicação e ver logs
./mvnw spring-boot:run

# Procurar por:
# - "HikariPool-1 - Start completed"
# - "Started BibliotecaApplication"
```

---

## 📝 Checklist de Configuração

### Render (Produção)

- [x] Hostname interno: `dpg-d46j4c0dl3ps73bo34t0-a`
- [x] Database: `doplibrarymaven`
- [x] Username: `admin`
- [x] Password atualizado
- [x] `application.properties` atualizado
- [x] `application-render.properties` criado
- [x] Variáveis de ambiente no Render configuradas

### Local (Desenvolvimento)

- [ ] PostgreSQL rodando (Docker ou local)
- [ ] Database criada
- [ ] Credenciais corretas
- [ ] Profile correto (`dev` para H2, `default` para PostgreSQL)

---

## 🎯 Recomendações

### Desenvolvimento

1. **Use H2** (`profile=dev`) para desenvolvimento rápido
2. **Use Docker** para testar com PostgreSQL real
3. **Não commite** credenciais no Git

### Produção

1. **Use variáveis de ambiente** no Render
2. **Use Internal Hostname** (`dpg-d46j4c0dl3ps73bo34t0-a`)
3. **Configure SSL** se usando External Hostname
4. **Monitore** conexões e pool
5. **Faça backup** regular do banco

---

## 📚 Arquivos de Configuração

| Arquivo | Ambiente | Status |
|---------|----------|--------|
| `application.properties` | Produção (Render) | ✅ Atualizado |
| `application-dev.properties` | Desenvolvimento (H2) | ✅ OK |
| `application-render.properties` | Render específico | ✅ Criado |
| `docker.env.example` | Template Docker | ✅ Atualizado |

---

## 🔗 Links Úteis

- [Render PostgreSQL Docs](https://render.com/docs/databases)
- [Spring Boot Database Config](https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#appendix.application-properties.data)
- [HikariCP Configuration](https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby)

---

## 📞 Suporte

### Problemas de Conexão

1. Verifique logs da aplicação
2. Teste conexão manual com `psql`
3. Verifique firewall/rede
4. Consulte Render Status: https://status.render.com

### Contato

- **Email**: daniloopro@gmail.com
- **GitHub**: [Issues](https://github.com/daniloopinheiro/dopLibraryMaven/issues)

---

## ✅ Resumo

### Configuração Atual (Render)

```properties
# Produção (application.properties)
spring.datasource.url=jdbc:postgresql://dpg-d46j4c0dl3ps73bo34t0-a:5432/doplibrarymaven
spring.datasource.username=admin
spring.datasource.password=VRE9dZvXjas0sq31sCgdXTMJ3Yldyk1c
```

### Quick Commands

```bash
# Desenvolvimento (H2)
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# Produção (Render config)
./mvnw spring-boot:run

# Docker local
docker-compose -f docker-compose-app.yml up -d

# Testar conexão
curl http://localhost:8080/api/autores
```

---

**✅ Configuração do banco de dados atualizada e funcionando!**

Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

