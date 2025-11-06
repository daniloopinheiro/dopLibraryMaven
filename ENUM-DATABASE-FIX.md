# ✅ Corrigir Dados de Empréstimos no Banco

## 🔍 Problema

```
No enum constant com.biblioteca.model.enums.StatusEmprestimo.devolvido
```

**Causa:** O banco de dados tem registros com status em **minúsculo** (`"devolvido"`), mas o Hibernate espera **MAIÚSCULO** (`"DEVOLVIDO"`).

---

## ⚡ Solução Rápida (Script PowerShell)

```powershell
.\limpar-emprestimos.ps1
```

Este script:
1. ✅ Mostra os dados atuais
2. ✅ Converte todos os status para MAIÚSCULO
3. ✅ Verifica se funcionou

---

## 🛠️ Solução Manual (pgAdmin)

### 1. Acessar pgAdmin
```
http://localhost:8082
```

### 2. Executar Query

```sql
-- Ver dados atuais
SELECT id_emprestimo, nome_usuario, status 
FROM emprestimos 
ORDER BY id_emprestimo;

-- Corrigir: converter para MAIÚSCULO
UPDATE emprestimos 
SET status = UPPER(status::text)::status_emprestimo
WHERE status IS NOT NULL;

-- Verificar
SELECT id_emprestimo, nome_usuario, status 
FROM emprestimos 
ORDER BY id_emprestimo;
```

---

## 🗑️ Alternativa: Limpar Tudo (se forem dados de teste)

```sql
-- Deletar todos os empréstimos
DELETE FROM emprestimos;

-- Verificar
SELECT COUNT(*) FROM emprestimos;
```

---

## 🔍 Por que aconteceu?

| Contexto | Como funciona |
|----------|---------------|
| **JSON Request** | `@JsonCreator` aceita minúsculo ✅ |
| **JSON Response** | `@JsonValue` retorna maiúsculo ✅ |
| **Banco de Dados** | Hibernate usa `valueOf()` direto ❌ |

O `@JsonCreator` **só funciona para JSON**, não para leitura do banco!

---

## ✅ Testar Após Corrigir

```powershell
# Listar empréstimos
Invoke-RestMethod -Uri "http://localhost:8080/api/emprestimos"
```

Não deve ter mais o erro!

---

## 🎯 Prevenção Futura

Para evitar esse problema:

### Opção 1: Sempre use MAIÚSCULO no JSON
```json
{
  "status": "EMPRESTADO"  ← Sempre maiúsculo
}
```

### Opção 2: Criar AttributeConverter (Avançado)

```java
@Converter(autoApply = true)
public class StatusEmprestimoConverter 
        implements AttributeConverter<StatusEmprestimo, String> {
    
    @Override
    public String convertToDatabaseColumn(StatusEmprestimo status) {
        return status == null ? null : status.name();
    }
    
    @Override
    public StatusEmprestimo convertToEntityAttribute(String dbData) {
        if (dbData == null) return null;
        return StatusEmprestimo.valueOf(dbData.toUpperCase());
    }
}
```

Depois, no modelo:
```java
@Convert(converter = StatusEmprestimoConverter.class)
@Column(columnDefinition = "status_emprestimo")
private StatusEmprestimo status;
```

---

## 📋 Checklist

- [ ] Executei `.\limpar-emprestimos.ps1` OU
- [ ] Executei UPDATE manual no pgAdmin OU  
- [ ] Deletei todos os empréstimos
- [ ] Testei listar empréstimos: `GET /api/emprestimos`
- [ ] Não aparece mais o erro
- [ ] Posso criar novos empréstimos

---

**🎉 Execute o script e pronto!**

```powershell
.\limpar-emprestimos.ps1
```

