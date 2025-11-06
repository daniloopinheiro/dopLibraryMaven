# Docker Setup - ProjectsAcademy

## 🐳 Como usar o Docker Compose

### Iniciar os serviços

```bash
docker-compose up -d
```

### Parar os serviços

```bash
docker-compose down
```

### Parar e remover volumes (apaga os dados)

```bash
docker-compose down -v
```

### Ver logs

```bash
docker-compose logs -f
```

## 📦 Serviços incluídos

### PostgreSQL (Bitnami)
- **Porta:** 5432
- **Database:** postgres
- **Usuário:** postgres
- **Senha:** postgres
- **Volume:** Os dados são persistidos em um volume Docker
- **Imagem:** bitnami/postgresql:15

### Adminer (Interface Web - Opcional)
Para incluir o Adminer, use:
```bash
docker-compose -f docker-compose-with-adminer.yml up -d
```

- **URL:** http://localhost:8081
- **Sistema:** PostgreSQL
- **Servidor:** postgres
- **Usuário:** postgres
- **Senha:** postgres
- **Base de dados:** postgres

## 🚀 Executar a aplicação Spring Boot

### Opção 1: Via Maven (recomendado)

```bash
# Linux/Mac
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# Windows (PowerShell)
.\mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
```

### Opção 2: Via IDE
Configure o profile ativo como `dev` nas configurações de execução:
- **VM Options:** `-Dspring.profiles.active=dev`
- Ou **Environment Variable:** `SPRING_PROFILES_ACTIVE=dev`

### Opção 3: Via JAR compilado

```bash
# Compilar
./mvnw clean package -DskipTests

# Executar com profile dev
java -jar -Dspring.profiles.active=dev target/*.jar
```

## 🔧 Configurações

As configurações de desenvolvimento estão em `src/main/resources/application-dev.properties` e apontam para o banco de dados local do Docker.

As configurações de produção (Supabase) permanecem em `application.properties`.

## 📝 Script de inicialização

O arquivo `supabase-init.sql` é executado automaticamente quando o container PostgreSQL é criado pela primeira vez, criando as tabelas necessárias.

## 🐛 Troubleshooting

### Porta 5432 já está em uso
Se você já tem PostgreSQL instalado localmente, pode alterar a porta no `docker-compose.yml`:
```yaml
ports:
  - "5433:5432"  # Mudou de 5432 para 5433
```
E também no `application-dev.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5433/postgres
```

### Verificar se o container está rodando
```bash
docker ps
```

### Acessar o PostgreSQL via linha de comando
```bash
# Windows PowerShell
docker exec -e PGPASSWORD=postgres -it projectsacademy-db psql -U postgres -d postgres

# Listar databases
docker exec -e PGPASSWORD=postgres projectsacademy-db psql -U postgres -d postgres -c "\l"

# Listar tabelas
docker exec -e PGPASSWORD=postgres projectsacademy-db psql -U postgres -d postgres -c "\dt"
```

### Resetar o banco de dados
```bash
docker-compose down -v
docker-compose up -d
```

