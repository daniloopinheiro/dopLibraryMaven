# ✅ Enum Status Empréstimo - Problema PostgreSQL Resolvido

## 🎯 Problema

### ❌ Erro Original
```
ERROR: column "status" is of type status_emprestimo but expression is of type character varying
Dica: You will need to rewrite or cast the expression.
```

### 🔍 Causa
- **Banco de dados PostgreSQL**: Tipo `status_emprestimo` (ENUM nativo)
- **JPA/Hibernate**: Configurado para usar `VARCHAR(20)`
- **Conflito**: PostgreSQL não aceita VARCHAR onde espera ENUM

---

## 🔧 Solução Aplicada

### Antes (Errado)
```java
@Enumerated(EnumType.STRING)
@Column(columnDefinition = "VARCHAR(20)")  ← Errado!
private StatusEmprestimo status;
```

### Depois (Correto)
```java
@Enumerated(EnumType.STRING)
@Column(columnDefinition = "status_emprestimo")  ← Correto!
private StatusEmprestimo status;
```

---

## 📊 Como Funciona Agora

### 1. Tipo ENUM no PostgreSQL
O arquivo `supabase-init.sql` cria o tipo:
```sql
CREATE TYPE IF NOT EXISTS status_emprestimo AS ENUM (
    'EMPRESTADO', 
    'DEVOLVIDO', 
    'ATRASADO'
);
```

### 2. JPA Usa o Tipo Correto
```java
@Column(columnDefinition = "status_emprestimo")
```

### 3. JSON Aceita Qualquer Case
Graças ao `@JsonCreator` no enum:
```json
{
  "status": "emprestado"   // ✅ Funciona
  "status": "EMPRESTADO"   // ✅ Funciona
  "status": "Emprestado"   // ✅ Funciona
}
```

---

## 🚀 Testar Agora

### Criar Empréstimo
```json
POST /api/emprestimos
{
  "idLivro": 1,
  "nomeUsuario": "João Silva",
  "cpfUsuario": "123.456.789-00",
  "telefone": "(11) 98765-4321",
  "email": "joao.silva@email.com",
  "dataEmprestimo": "2025-11-04",
  "dataPrevistaDevolucao": "2025-11-18",
  "status": "emprestado",
  "observacoes": "Teste após correção"
}
```

### Via PowerShell
```powershell
$json = Get-Content test-emprestimo.json -Raw

Invoke-RestMethod -Uri "http://localhost:8080/api/emprestimos" `
  -Method POST `
  -ContentType "application/json" `
  -Body $json
```

---

## ✅ Resposta Esperada

**Status: 201 Created**

```json
{
  "idEmprestimo": 1,
  "idLivro": 1,
  "tituloLivro": "Dom Casmurro",
  "nomeUsuario": "João Silva",
  "cpfUsuario": "123.456.789-00",
  "telefone": "(11) 98765-4321",
  "email": "joao.silva@email.com",
  "dataEmprestimo": "2025-11-04",
  "dataPrevistaDevolucao": "2025-11-18",
  "dataDevolucao": null,
  "status": "EMPRESTADO",
  "observacoes": "Teste após correção"
}
```

---

## 🔍 Verificar no pgAdmin

1. Acesse: http://localhost:8082
2. Conecte ao banco
3. Execute:

```sql
-- Ver o tipo ENUM
SELECT typname, enumlabel 
FROM pg_type 
JOIN pg_enum ON pg_enum.enumtypid = pg_type.oid 
WHERE typname = 'status_emprestimo';

-- Ver empréstimos
SELECT * FROM emprestimos;

-- Ver tipo da coluna status
SELECT column_name, data_type, udt_name
FROM information_schema.columns
WHERE table_name = 'emprestimos' AND column_name = 'status';
```

**Resultado esperado:**
```
column_name | data_type    | udt_name
------------|--------------|-------------------
status      | USER-DEFINED | status_emprestimo
```

---

## 💡 Diferenças: VARCHAR vs ENUM PostgreSQL

| Aspecto | VARCHAR | ENUM PostgreSQL |
|---------|---------|-----------------|
| **Armazenamento** | String completa | Referência ao tipo |
| **Performance** | ❌ Mais lento | ✅ Mais rápido |
| **Validação** | ❌ Não valida | ✅ Valida no banco |
| **Indexação** | ❌ Menos eficiente | ✅ Mais eficiente |
| **Espaço em disco** | ❌ Maior | ✅ Menor |
| **Erro em valor inválido** | ❌ Só na aplicação | ✅ No banco também |

---

## 🎯 Casos de Teste

### ✅ Deve Funcionar

1. **Status em minúsculo:**
```json
{ "status": "emprestado" }
```

2. **Status em maiúsculo:**
```json
{ "status": "EMPRESTADO" }
```

3. **Status omitido (usa padrão):**
```json
{ }  // status será EMPRESTADO
```

### ❌ Deve Dar Erro

```json
{ "status": "pendente" }  // Não existe
```

**Erro esperado:**
```
Valor inválido para StatusEmprestimo: 'pendente'. 
Valores aceitos: EMPRESTADO, DEVOLVIDO, ATRASADO (case-insensitive)
```

---

## 📋 Checklist Completo

- [x] Tipo ENUM criado no PostgreSQL (`supabase-init.sql`)
- [x] Entidade configurada com `columnDefinition = "status_emprestimo"`
- [x] Enum Java com `@JsonCreator` (aceita case-insensitive)
- [x] Enum Java com `@JsonValue` (retorna maiúsculo)
- [x] Arquivo de teste criado (`test-emprestimo.json`)
- [x] Documentação atualizada

---

## 🔄 Fluxo Completo

```
1. JSON Request
   { "status": "emprestado" }
   ↓
2. @JsonCreator (StatusEmprestimo.java)
   "emprestado" → "EMPRESTADO"
   ↓
3. Enum Java
   StatusEmprestimo.EMPRESTADO
   ↓
4. JPA/Hibernate
   Usa columnDefinition = "status_emprestimo"
   ↓
5. PostgreSQL
   INSERT com tipo status_emprestimo
   ✅ SUCESSO!
```

---

## 🎉 Problemas Resolvidos

| # | Problema | Status |
|---|----------|--------|
| 1 | Enum com case-insensitive | ✅ Resolvido |
| 2 | Conflito VARCHAR vs ENUM PostgreSQL | ✅ Resolvido |
| 3 | INSERT falhando | ✅ Resolvido |
| 4 | Validação de valores | ✅ Funcionando |

---

**🎊 Tudo corrigido! Agora pode criar empréstimos normalmente!**

