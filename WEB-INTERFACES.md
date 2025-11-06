# 🌐 Interfaces Web para PostgreSQL

## 📦 Opções Disponíveis

### 1. Adminer (Recomendado - Simples e Leve) ⭐

**Usar:** `docker-compose.yml` (padrão)

```powershell
docker-compose up -d
```

**Acesso:**
- **URL:** http://localhost:8081
- **Sistema:** PostgreSQL
- **Servidor:** `postgres`
- **Usuário:** `postgres`
- **Senha:** `postgres`
- **Base de dados:** `postgres`

**Características:**
- ✅ Interface simples e intuitiva
- ✅ Muito leve (< 10MB)
- ✅ Suporta múltiplos bancos
- ✅ Executar queries SQL
- ✅ Importar/Exportar dados
- ✅ Gerenciar tabelas e índices

---

### 2. pgAdmin (Profissional e Completo)

**Usar:** `docker-compose-pgadmin.yml`

```powershell
docker-compose -f docker-compose-pgadmin.yml up -d
```

**Acesso:**
- **URL:** http://localhost:8082
- **Email:** `admin@admin.com`
- **Senha:** `admin`

**Após login, adicionar servidor:**
1. Clique em "Add New Server"
2. **General > Name:** ProjectsAcademy
3. **Connection:**
   - Host: `postgres`
   - Port: `5432`
   - Database: `postgres`
   - Username: `postgres`
   - Password: `postgres`
4. Salvar

**Características:**
- ✅ Interface profissional completa
- ✅ Editor SQL avançado com autocomplete
- ✅ Visualização de dados em grid
- ✅ Backup e restore
- ✅ Monitoramento de performance
- ✅ Query history
- ⚠️ Mais pesado (200MB+)

---

### 3. Ambos (Adminer + pgAdmin)

**Usar:** `docker-compose-full.yml`

```powershell
docker-compose -f docker-compose-full.yml up -d
```

**Acesso:**
- **Adminer:** http://localhost:8081
- **pgAdmin:** http://localhost:8082

---

## 🚀 Exemplos de Uso

### Iniciar com Adminer (padrão)
```powershell
# Iniciar
docker-compose up -d

# Acessar: http://localhost:8081
```

### Iniciar com pgAdmin
```powershell
# Iniciar
docker-compose -f docker-compose-pgadmin.yml up -d

# Acessar: http://localhost:8082
```

### Trocar de interface
```powershell
# Parar a atual
docker-compose down

# Iniciar outra versão
docker-compose -f docker-compose-pgadmin.yml up -d
```

---

## 📊 Comparação

| Recurso | Adminer | pgAdmin |
|---------|---------|---------|
| Tamanho | 🟢 ~10MB | 🟡 ~200MB |
| Velocidade | 🟢 Muito rápido | 🟡 Normal |
| Interface | 🟢 Simples | 🟢 Profissional |
| Editor SQL | ✅ Básico | ✅ Avançado |
| Autocomplete | ❌ | ✅ |
| Export/Import | ✅ | ✅ |
| Backup | ✅ Básico | ✅ Completo |
| Monitoramento | ❌ | ✅ |
| Curva de aprendizado | 🟢 Fácil | 🟡 Média |

---

## 💡 Recomendações

### Use Adminer se:
- ✅ Quer algo rápido e simples
- ✅ Precisa apenas executar queries
- ✅ Quer economizar recursos
- ✅ É para desenvolvimento básico

### Use pgAdmin se:
- ✅ Trabalha profissionalmente com PostgreSQL
- ✅ Precisa de ferramentas avançadas
- ✅ Faz backup/restore frequente
- ✅ Precisa monitorar performance
- ✅ Quer autocomplete no editor SQL

---

## 🎨 Screenshots & Dicas

### Adminer
```
Login: http://localhost:8081
┌────────────────────────────────┐
│ Sistema:    PostgreSQL         │
│ Servidor:   postgres           │
│ Usuário:    postgres           │
│ Senha:      postgres           │
│ Base:       postgres           │
└────────────────────────────────┘
```

### pgAdmin
```
Login: http://localhost:8082
┌────────────────────────────────┐
│ Email:      admin@admin.com    │
│ Senha:      admin              │
└────────────────────────────────┘

Após login, adicionar servidor:
Add New Server → Connection
┌────────────────────────────────┐
│ Host:       postgres           │
│ Port:       5432               │
│ Database:   postgres           │
│ Username:   postgres           │
│ Password:   postgres           │
└────────────────────────────────┘
```

---

## 🔧 Comandos Úteis

### Ver quais containers estão rodando
```powershell
docker ps
```

### Ver logs da interface web
```powershell
# Adminer
docker logs projectsacademy-adminer -f

# pgAdmin
docker logs projectsacademy-pgadmin -f
```

### Reiniciar apenas a interface
```powershell
# Adminer
docker restart projectsacademy-adminer

# pgAdmin
docker restart projectsacademy-pgadmin
```

---

## 🐛 Troubleshooting

### Adminer não conecta no PostgreSQL
```powershell
# Verificar se o PostgreSQL está rodando
docker ps | grep postgres

# Verificar logs
docker logs projectsacademy-db
```

### pgAdmin: "Could not connect to server"
```
Certifique-se de usar "postgres" como hostname, NÃO "localhost"
O hostname é o nome do serviço no docker-compose.yml
```

### Porta já está em uso
```powershell
# Para Adminer (porta 8081)
# Altere no docker-compose.yml:
ports:
  - "8090:8080"  # Mudou para 8090

# Para pgAdmin (porta 8082)
# Altere no docker-compose-pgadmin.yml:
ports:
  - "8083:80"  # Mudou para 8083
```

---

## 📝 Arquivos de Configuração

| Arquivo | Descrição | Interfaces |
|---------|-----------|------------|
| `docker-compose.yml` | ⭐ Padrão | PostgreSQL + Adminer |
| `docker-compose-pgadmin.yml` | Profissional | PostgreSQL + pgAdmin |
| `docker-compose-full.yml` | Completo | PostgreSQL + Adminer + pgAdmin |
| `docker-compose-minimal.yml` | Mínimo | Apenas PostgreSQL |

---

🎉 **Pronto para usar!** Execute `docker-compose up -d` e acesse http://localhost:8081

