# ⚠️ IMPORTANTE: Reiniciar a Aplicação

## 🔴 O erro persiste?

Você precisa **REINICIAR** a aplicação Spring Boot para aplicar as alterações!

---

## 🔄 Como Reiniciar

### Opção 1: Parar e Iniciar Novamente

1. **Parar a aplicação** (CTRL+C no terminal)
2. **Iniciar novamente:**

```powershell
.\mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
```

### Opção 2: Script Completo

```powershell
# Para tudo e inicia limpo
.\run-docker-app.bat
```

---

## ✅ Verificar se Aplicou

Após reiniciar, você deve ver nos logs:

```
Hibernate: 
    insert into emprestimos (...status...) 
    values (?,?,?,?,?,?,?,?,?,?)
```

E **NÃO** deve ver mais o erro:
```
ERROR: column "status" is of type status_emprestimo 
but expression is of type character varying
```

---

## 🔍 Ainda não funciona?

Se após reiniciar o erro persistir, use a **Solução Alternativa** abaixo.

---

## 🛠️ Solução Alternativa (se persistir)

### Opção A: Alterar o Tipo no Banco

Execute no pgAdmin:

```sql
-- Mudar de ENUM para VARCHAR
ALTER TABLE emprestimos 
ALTER COLUMN status TYPE VARCHAR(20);

-- Verificar
SELECT column_name, data_type, udt_name
FROM information_schema.columns
WHERE table_name = 'emprestimos' AND column_name = 'status';
```

Depois altere o código de volta:

```java
@Enumerated(EnumType.STRING)
@Column(columnDefinition = "VARCHAR(20)")  // Volta ao VARCHAR
private StatusEmprestimo status = StatusEmprestimo.EMPRESTADO;
```

### Opção B: Usar Hibernate Types (Avançado)

Adicionar ao `pom.xml`:

```xml
<dependency>
    <groupId>com.vladmihalcea</groupId>
    <artifactId>hibernate-types-60</artifactId>
    <version>2.21.1</version>
</dependency>
```

E no modelo:

```java
@Type(PostgreSQLEnumType.class)
@Enumerated(EnumType.STRING)
@Column(columnDefinition = "status_emprestimo")
private StatusEmprestimo status = StatusEmprestimo.EMPRESTADO;
```

---

## 🎯 Checklist de Troubleshooting

- [ ] Salvei as alterações no código?
- [ ] Reiniciei a aplicação Spring Boot?
- [ ] Aguardei a aplicação inicializar completamente?
- [ ] Testei criar um empréstimo novamente?
- [ ] Verifiquei os logs da aplicação?

---

## 📝 Passos Completos

1. **Parar aplicação** (CTRL+C)
2. **Salvar arquivos** (CTRL+S em todos)
3. **Iniciar aplicação:**
   ```powershell
   .\mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
   ```
4. **Aguardar mensagem:**
   ```
   Started BibliotecaApiApplication in X.XXX seconds
   ```
5. **Testar novamente:**
   ```powershell
   $json = Get-Content test-emprestimo.json -Raw
   Invoke-RestMethod -Uri "http://localhost:8080/api/emprestimos" `
     -Method POST `
     -ContentType "application/json" `
     -Body $json
   ```

---

## ⚡ Atalho Rápido

```powershell
# 1. Para a aplicação (CTRL+C)
# 2. Execute:
.\mvnw.cmd clean spring-boot:run -D"spring-boot.run.profiles=dev"
```

O `clean` garante que recompila tudo!

---

**🚨 LEMBRE-SE: Alterações no código Java só funcionam após REINICIAR a aplicação!**

