# 🚀 Quick Start - PostgreSQL + pgAdmin

## ✅ Containers Rodando

Você tem **PostgreSQL + pgAdmin** funcionando!

```
✓ PostgreSQL (bitnami/postgresql:latest) - Porta 5432
✓ pgAdmin 4 (dpage/pgadmin4:latest) - Porta 8082
```

---

## 🌐 Acessar pgAdmin

### 1. Abra no navegador:
```
http://localhost:8082
```

### 2. Faça login:
- **Email:** `admin@admin.com`
- **Senha:** `admin`

### 3. Adicionar o servidor PostgreSQL:

Após o login, clique em **"Add New Server"** e preencha:

#### Aba "General":
- **Name:** `ProjectsAcademy`

#### Aba "Connection":
- **Host name/address:** `postgres`
- **Port:** `5432`
- **Maintenance database:** `postgres`
- **Username:** `postgres`
- **Password:** `postgres`
- ✅ Marque: **Save password**

Clique em **Save** e pronto!

---

## 📊 Usar o pgAdmin

### Navegar nas tabelas:
```
Servers → ProjectsAcademy → Databases → postgres → Schemas → public → Tables
```

### Executar queries SQL:
1. Clique com botão direito em `postgres`
2. Selecione **Query Tool**
3. Digite seu SQL:
```sql
SELECT * FROM autor;
SELECT * FROM livro;
SELECT * FROM emprestimo;
```

### Ver dados de uma tabela:
1. Expanda: `Tables`
2. Clique com botão direito na tabela (ex: `autor`)
3. Selecione **View/Edit Data → All Rows**

---

## 🏃 Executar a Aplicação Spring Boot

```powershell
# Opção 1: Script automático
.\run-docker-app.bat

# Opção 2: Comando direto
.\mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
```

Depois acesse: **http://localhost:8080/api/autores**

---

## 🔧 Comandos Docker Úteis

### Ver status
```powershell
docker ps
```

### Ver logs
```powershell
# PostgreSQL
docker logs projectsacademy-db -f

# pgAdmin
docker logs projectsacademy-pgadmin -f
```

### Reiniciar
```powershell
docker-compose -f docker-compose-pgadmin.yml restart
```

### Parar
```powershell
docker-compose -f docker-compose-pgadmin.yml down
```

### Parar e limpar dados
```powershell
docker-compose -f docker-compose-pgadmin.yml down -v
```

---

## 🎯 Próximos Passos

1. ✅ Acesse pgAdmin: http://localhost:8082
2. ✅ Adicione o servidor PostgreSQL
3. ✅ Execute a aplicação Spring Boot
4. ✅ Teste os endpoints da API
5. ✅ Visualize os dados no pgAdmin

---

## 💡 Dicas

### Problema: "Could not connect to server"
- Certifique-se de usar `postgres` como hostname (não localhost)
- Verifique se o container PostgreSQL está rodando: `docker ps`

### Problema: pgAdmin muito lento
- Feche abas não utilizadas
- Limpe o histórico: File → Preferences → Query History

### Alternativa leve: Adminer
Se o pgAdmin estiver muito pesado, você pode tentar o Adminer:
```powershell
# Parar atual
docker-compose -f docker-compose-pgadmin.yml down

# Tentar baixar Adminer
docker pull adminer:latest

# Se funcionar, usar:
docker-compose up -d
```

---

## 📝 Arquivos de Configuração

| Arquivo | Descrição |
|---------|-----------|
| `docker-compose-pgadmin.yml` | ⭐ Atual (PostgreSQL + pgAdmin) |
| `docker-compose.yml` | PostgreSQL + Adminer (se baixar) |
| `docker-compose-minimal.yml` | Apenas PostgreSQL |

---

🎉 **Tudo pronto!** Acesse http://localhost:8082 e comece a usar!

