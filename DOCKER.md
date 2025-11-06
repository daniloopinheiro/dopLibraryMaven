# 🐳 Guia Docker - Biblioteca API

Este guia explica como construir e executar a Biblioteca API usando Docker.

## 📋 Índice

1. [Pré-requisitos](#pré-requisitos)
2. [Build da Imagem](#build-da-imagem)
3. [Executar Container](#executar-container)
4. [Docker Compose](#docker-compose)
5. [Variáveis de Ambiente](#variáveis-de-ambiente)
6. [Comandos Úteis](#comandos-úteis)
7. [Troubleshooting](#troubleshooting)

---

## Pré-requisitos

- **Docker**: 20.10+
- **Docker Compose**: 2.0+ (opcional)

Verificar instalação:
```bash
docker --version
docker-compose --version
```

---

## Build da Imagem

### Build Básico

```bash
docker build -t biblioteca-api:latest .
```

### Build com Tag de Versão

```bash
docker build -t biblioteca-api:1.0.0 .
```

### Build com Cache Limpo

```bash
docker build --no-cache -t biblioteca-api:latest .
```

### Verificar Imagem Criada

```bash
docker images | grep biblioteca-api
```

---

## Executar Container

### 1️⃣ Com H2 (Banco em Memória)

**Modo mais simples - sem banco externo:**

```bash
docker run -d \
  --name biblioteca-api \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=dev \
  biblioteca-api:latest
```

Acessar:
- **API**: http://localhost:8080/api/autores
- **H2 Console**: http://localhost:8080/h2-console

---

### 2️⃣ Com PostgreSQL (Docker Network)

**Passo 1: Criar rede Docker**

```bash
docker network create biblioteca-network
```

**Passo 2: Iniciar PostgreSQL**

```bash
docker run -d \
  --name biblioteca-postgres \
  --network biblioteca-network \
  -e POSTGRES_DB=biblioteca \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine
```

**Passo 3: Iniciar Aplicação**

```bash
docker run -d \
  --name biblioteca-api \
  --network biblioteca-network \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://biblioteca-postgres:5432/biblioteca \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=postgres \
  biblioteca-api:latest
```

---

### 3️⃣ Com PostgreSQL Externo (Host)

```bash
docker run -d \
  --name biblioteca-api \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/biblioteca \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=sua-senha \
  biblioteca-api:latest
```

---

### 4️⃣ Com Supabase

```bash
docker run -d \
  --name biblioteca-api \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=supabase \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://seu-host.supabase.co:5432/postgres \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=sua-senha \
  biblioteca-api:latest
```

---

## Docker Compose

### Opção Recomendada: Com Docker Compose

Crie um arquivo `docker-compose-app.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: biblioteca-postgres
    environment:
      POSTGRES_DB: biblioteca
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  app:
    build: .
    image: biblioteca-api:latest
    container_name: biblioteca-api
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/biblioteca
      SPRING_DATASOURCE_USERNAME: postgres
      SPRING_DATASOURCE_PASSWORD: postgres
      SPRING_JPA_HIBERNATE_DDL_AUTO: update
    ports:
      - "8080:8080"
    depends_on:
      postgres:
        condition: service_healthy
    restart: unless-stopped

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: biblioteca-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "8082:80"
    depends_on:
      - postgres
    restart: unless-stopped

volumes:
  postgres_data:
```

### Executar com Docker Compose

```bash
# Iniciar todos os serviços
docker-compose -f docker-compose-app.yml up -d

# Rebuild e iniciar
docker-compose -f docker-compose-app.yml up -d --build

# Ver logs
docker-compose -f docker-compose-app.yml logs -f app

# Parar serviços
docker-compose -f docker-compose-app.yml down

# Parar e remover volumes
docker-compose -f docker-compose-app.yml down -v
```

---

## Variáveis de Ambiente

### Variáveis Principais

| Variável | Descrição | Padrão | Exemplo |
|----------|-----------|--------|---------|
| `SPRING_PROFILES_ACTIVE` | Perfil do Spring | `prod` | `dev`, `supabase` |
| `SPRING_DATASOURCE_URL` | URL do banco de dados | - | `jdbc:postgresql://postgres:5432/biblioteca` |
| `SPRING_DATASOURCE_USERNAME` | Usuário do banco | - | `postgres` |
| `SPRING_DATASOURCE_PASSWORD` | Senha do banco | - | `postgres` |
| `SPRING_JPA_HIBERNATE_DDL_AUTO` | Estratégia JPA | `update` | `create`, `validate` |
| `SERVER_PORT` | Porta da aplicação | `8080` | `8080` |
| `JAVA_OPTS` | Opções da JVM | (configurado) | `-Xmx512m` |

### Exemplo com Múltiplas Variáveis

```bash
docker run -d \
  --name biblioteca-api \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/biblioteca \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=postgres \
  -e SPRING_JPA_SHOW_SQL=true \
  -e SPRING_JPA_HIBERNATE_DDL_AUTO=update \
  -e JAVA_OPTS="-Xmx512m -Xms256m" \
  biblioteca-api:latest
```

---

## Comandos Úteis

### Gerenciamento de Containers

```bash
# Listar containers em execução
docker ps

# Listar todos os containers (incluindo parados)
docker ps -a

# Ver logs do container
docker logs -f biblioteca-api

# Ver logs das últimas 100 linhas
docker logs --tail 100 biblioteca-api

# Parar container
docker stop biblioteca-api

# Iniciar container parado
docker start biblioteca-api

# Reiniciar container
docker restart biblioteca-api

# Remover container
docker rm biblioteca-api

# Remover container (forçado)
docker rm -f biblioteca-api
```

### Inspecionar Container

```bash
# Ver detalhes do container
docker inspect biblioteca-api

# Ver estatísticas de uso
docker stats biblioteca-api

# Executar comando dentro do container
docker exec -it biblioteca-api sh

# Ver processos rodando
docker top biblioteca-api
```

### Gerenciamento de Imagens

```bash
# Listar imagens
docker images

# Remover imagem
docker rmi biblioteca-api:latest

# Remover imagens não utilizadas
docker image prune -a

# Ver histórico da imagem
docker history biblioteca-api:latest
```

### Limpeza

```bash
# Remover containers parados
docker container prune

# Remover imagens não utilizadas
docker image prune -a

# Remover volumes não utilizados
docker volume prune

# Limpar tudo (cuidado!)
docker system prune -a --volumes
```

---

## Troubleshooting

### Container não inicia

**Verificar logs:**
```bash
docker logs biblioteca-api
```

**Causas comuns:**
- ❌ Banco de dados não acessível
- ❌ Porta 8080 já em uso
- ❌ Variáveis de ambiente incorretas

**Solução:**
```bash
# Verificar se a porta está em uso
netstat -an | grep 8080

# Usar porta diferente
docker run -p 9090:8080 biblioteca-api:latest
```

---

### Erro de conexão com banco de dados

**Erro:**
```
Connection to localhost:5432 refused
```

**Solução:**
- ✅ Use `host.docker.internal` em vez de `localhost`
- ✅ Crie uma rede Docker e conecte os containers
- ✅ Verifique se o PostgreSQL está rodando

```bash
# Verificar se PostgreSQL está rodando
docker ps | grep postgres

# Testar conexão
docker exec -it biblioteca-postgres psql -U postgres -d biblioteca
```

---

### Health check falha

**Verificar:**
```bash
docker inspect biblioteca-api | grep -A 10 Health
```

**Adicionar Spring Boot Actuator:**

Adicione ao `pom.xml`:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

Em `application.properties`:
```properties
management.endpoints.web.exposure.include=health,info
management.endpoint.health.show-details=always
```

---

### Build lento

**Otimizações:**

1. **Use cache de camadas:**
```bash
docker build -t biblioteca-api:latest .
```

2. **Build multi-stage já está implementado**

3. **Limpe build anterior:**
```bash
docker build --no-cache -t biblioteca-api:latest .
```

---

### Container usando muita memória

**Ajustar limites:**

```bash
docker run -d \
  --name biblioteca-api \
  --memory="512m" \
  --cpus="1.0" \
  -e JAVA_OPTS="-Xmx256m -Xms128m" \
  -p 8080:8080 \
  biblioteca-api:latest
```

---

## 🔒 Segurança

### Práticas Implementadas

- ✅ **Usuário não-root**: Aplicação roda com usuário `spring` (UID 1001)
- ✅ **Multi-stage build**: Reduz superfície de ataque
- ✅ **Imagem Alpine**: Imagem base mínima
- ✅ **Health check**: Monitoramento automático
- ✅ **Signal handling**: Uso de `dumb-init`

### Recomendações Adicionais

```bash
# Escanear vulnerabilidades
docker scan biblioteca-api:latest

# Executar como read-only (exceto volumes necessários)
docker run --read-only \
  --tmpfs /tmp \
  -p 8080:8080 \
  biblioteca-api:latest
```

---

## 📊 Monitoramento

### Ver métricas em tempo real

```bash
docker stats biblioteca-api
```

### Logs estruturados

```bash
# Seguir logs
docker logs -f biblioteca-api

# Filtrar logs
docker logs biblioteca-api 2>&1 | grep ERROR

# Salvar logs em arquivo
docker logs biblioteca-api > app.log 2>&1
```

---

## 🚀 Deploy em Produção

### Docker Hub

```bash
# Tag da imagem
docker tag biblioteca-api:latest seu-usuario/biblioteca-api:1.0.0

# Login
docker login

# Push
docker push seu-usuario/biblioteca-api:1.0.0
```

### Registry Privado

```bash
# Tag
docker tag biblioteca-api:latest registry.empresa.com/biblioteca-api:1.0.0

# Push
docker push registry.empresa.com/biblioteca-api:1.0.0
```

---

## 📝 Exemplos Práticos

### Desenvolvimento Local

```bash
# Build
docker build -t biblioteca-api:dev .

# Run com H2
docker run -d \
  --name biblioteca-dev \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=dev \
  biblioteca-api:dev
```

### Ambiente de Teste

```bash
# Com Docker Compose
docker-compose -f docker-compose-app.yml up -d

# Verificar saúde
docker-compose -f docker-compose-app.yml ps
```

### Produção

```bash
# Build com tag de versão
docker build -t biblioteca-api:1.0.0 .

# Run com configurações de produção
docker run -d \
  --name biblioteca-api \
  --restart unless-stopped \
  --memory="1g" \
  --cpus="2.0" \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://prod-db:5432/biblioteca \
  -e SPRING_DATASOURCE_USERNAME=${DB_USER} \
  -e SPRING_DATASOURCE_PASSWORD=${DB_PASS} \
  biblioteca-api:1.0.0
```

---

## 📞 Suporte

Para problemas ou dúvidas:
- **Issues**: [GitHub Issues](https://github.com/daniloopinheiro/dopLibraryMaven/issues)
- **Email**: [daniloopro@gmail.com](mailto:daniloopro@gmail.com)

---

**🎉 Dockerfile implementado com sucesso!**

Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

