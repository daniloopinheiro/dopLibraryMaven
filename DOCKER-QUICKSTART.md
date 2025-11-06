# 🐳 Docker - Início Rápido

Guia rápido para começar a usar a Biblioteca API com Docker.

## ⚡ Início Mais Rápido (3 Passos)

### Windows

```powershell
# 1. Construir a imagem
.\docker-build.bat

# 2. Executar com H2 (mais simples)
.\docker-run-dev.bat

# 3. Testar
curl http://localhost:8080/api/autores
```

### Linux/Mac

```bash
# 1. Construir a imagem
docker build -t biblioteca-api:latest .

# 2. Executar com H2
docker run -d --name biblioteca-api -p 8080:8080 -e SPRING_PROFILES_ACTIVE=dev biblioteca-api:latest

# 3. Testar
curl http://localhost:8080/api/autores
```

---

## 🎯 Cenários Comuns

### 1. Desenvolvimento Local (H2)

**Mais simples - sem banco externo**

```bash
# Build
docker build -t biblioteca-api:latest .

# Run
docker run -d \
  --name biblioteca-api-dev \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=dev \
  biblioteca-api:latest

# Acessar
http://localhost:8080/api/autores
http://localhost:8080/h2-console
```

---

### 2. Com PostgreSQL (Docker Compose) ⭐ RECOMENDADO

**Stack completa: App + PostgreSQL + pgAdmin**

```bash
# Iniciar tudo
docker-compose -f docker-compose-app.yml up -d

# Ver logs
docker-compose -f docker-compose-app.yml logs -f app

# Parar tudo
docker-compose -f docker-compose-app.yml down
```

**Acessos:**
- API: http://localhost:8080/api/autores
- pgAdmin: http://localhost:8082 (admin@admin.com / admin)
- PostgreSQL: localhost:5432 (postgres / postgres)

---

### 3. Usando PowerShell Manager

**Gerenciador completo (Windows)**

```powershell
# Ver ajuda
.\docker-manager.ps1 -Action help

# Build
.\docker-manager.ps1 -Action build

# Start com H2
.\docker-manager.ps1 -Action start -Mode dev

# Start com PostgreSQL
.\docker-manager.ps1 -Action start -Mode postgres

# Start com Docker Compose
.\docker-manager.ps1 -Action start -Mode compose

# Ver status
.\docker-manager.ps1 -Action status

# Ver logs
.\docker-manager.ps1 -Action logs

# Parar
.\docker-manager.ps1 -Action stop

# Limpar tudo
.\docker-manager.ps1 -Action clean
```

---

## 📋 Comandos Essenciais

### Build

```bash
# Build básico
docker build -t biblioteca-api:latest .

# Build sem cache
docker build --no-cache -t biblioteca-api:latest .
```

### Run

```bash
# H2 (Dev)
docker run -d --name biblioteca-api -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=dev \
  biblioteca-api:latest

# PostgreSQL
docker run -d --name biblioteca-api -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host:5432/biblioteca \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=postgres \
  biblioteca-api:latest
```

### Logs

```bash
# Ver logs
docker logs -f biblioteca-api

# Últimas 50 linhas
docker logs --tail 50 biblioteca-api
```

### Status

```bash
# Containers rodando
docker ps

# Todos os containers
docker ps -a

# Estatísticas
docker stats biblioteca-api
```

### Stop/Remove

```bash
# Parar
docker stop biblioteca-api

# Remover
docker rm biblioteca-api

# Parar e remover
docker rm -f biblioteca-api
```

---

## 🔧 Troubleshooting

### Container não inicia

```bash
# Ver erro nos logs
docker logs biblioteca-api

# Verificar porta
netstat -an | grep 8080
```

### Porta já em uso

```bash
# Usar porta diferente
docker run -p 9090:8080 biblioteca-api:latest
```

### Erro de conexão com banco

```bash
# Verificar se PostgreSQL está rodando
docker ps | grep postgres

# Verificar network
docker network ls

# Usar host.docker.internal (Windows/Mac)
-e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/biblioteca
```

### Rebuild limpo

```bash
# Parar tudo
docker stop $(docker ps -aq)

# Limpar
docker system prune -a

# Rebuild
docker build -t biblioteca-api:latest .
```

---

## 🎓 Fluxo Recomendado

### Para Desenvolvimento

1. **Primeira vez:**
   ```bash
   docker-compose -f docker-compose-app.yml up -d
   ```

2. **Após mudanças no código:**
   ```bash
   docker-compose -f docker-compose-app.yml up -d --build app
   ```

3. **Ver logs:**
   ```bash
   docker-compose -f docker-compose-app.yml logs -f app
   ```

4. **Reiniciar apenas a app:**
   ```bash
   docker-compose -f docker-compose-app.yml restart app
   ```

5. **Parar tudo (manter dados):**
   ```bash
   docker-compose -f docker-compose-app.yml down
   ```

6. **Limpar tudo (remover dados):**
   ```bash
   docker-compose -f docker-compose-app.yml down -v
   ```

---

## 📚 Recursos Adicionais

- **Documentação Completa**: [DOCKER.md](DOCKER.md)
- **Docker Compose**: [docker-compose-app.yml](docker-compose-app.yml)
- **Scripts Windows**:
  - `docker-build.bat` - Build da imagem
  - `docker-run-dev.bat` - Run com H2
  - `docker-run-postgres.bat` - Run com PostgreSQL
  - `docker-stop.bat` - Parar containers
  - `docker-manager.ps1` - Gerenciador completo

---

## 💡 Dicas

### Performance

```bash
# Limitar recursos
docker run -d \
  --memory="512m" \
  --cpus="1.0" \
  biblioteca-api:latest
```

### Variáveis de Ambiente

```bash
# Arquivo .env
docker run -d --env-file .env biblioteca-api:latest

# Múltiplas variáveis
docker run -d \
  -e VAR1=value1 \
  -e VAR2=value2 \
  biblioteca-api:latest
```

### Health Check

```bash
# Verificar saúde
docker inspect biblioteca-api | grep -A 5 Health
```

---

## 🆘 Ajuda

Se encontrar problemas:

1. **Verifique os logs:** `docker logs biblioteca-api`
2. **Verifique o status:** `docker ps -a`
3. **Limpe e tente novamente:** `docker system prune -a`
4. **Consulte a documentação:** [DOCKER.md](DOCKER.md)

---

## 🔗 Links Úteis

- [Docker Documentation](https://docs.docker.com/)
- [Spring Boot Docker Guide](https://spring.io/guides/gs/spring-boot-docker/)
- [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)

---

**Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)**

