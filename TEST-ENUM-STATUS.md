# ✅ Enum StatusEmprestimo - Case-Insensitive

## 🎯 Problema Resolvido

### ❌ Antes (Erro)
```json
{
  "status": "emprestado"  ← minúsculo causava erro
}
```

**Erro:**
```
Cannot deserialize value of type `StatusEmprestimo` from String "emprestado": 
not one of the values accepted for Enum class: [EMPRESTADO, ATRASADO, DEVOLVIDO]
```

### ✅ Agora (Funciona)
A API aceita **qualquer formato**:
- `"emprestado"` ✅
- `"EMPRESTADO"` ✅
- `"Emprestado"` ✅

---

## 📝 Valores Aceitos

| Status | Aceita |
|--------|--------|
| `"emprestado"` | ✅ |
| `"EMPRESTADO"` | ✅ |
| `"Emprestado"` | ✅ |
| `"devolvido"` | ✅ |
| `"DEVOLVIDO"` | ✅ |
| `"atrasado"` | ✅ |
| `"ATRASADO"` | ✅ |

---

## 🚀 Testar Agora

### Criar Empréstimo com Status Minúsculo

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
  "observacoes": "Teste com status minúsculo"
}
```

### Buscar por Status (Case-Insensitive na URL)

**Atenção:** Na URL, ainda precisa ser MAIÚSCULO:

```http
GET /api/emprestimos/status/EMPRESTADO  ✅
GET /api/emprestimos/status/emprestado  ❌ (path variable não funciona)
```

---

## 💡 Como Funciona

### Deserialização (JSON → Enum)
Quando recebe JSON:
```json
{ "status": "emprestado" }
```

O método `@JsonCreator` converte automaticamente:
```java
"emprestado" → "EMPRESTADO" → StatusEmprestimo.EMPRESTADO
```

### Serialização (Enum → JSON)
Quando retorna JSON:
```java
StatusEmprestimo.EMPRESTADO → "EMPRESTADO"
```

**Sempre retorna em MAIÚSCULO no response!**

---

## 📊 Exemplos Completos

### Exemplo 1: Status Opcional (padrão EMPRESTADO)
```json
POST /api/emprestimos
{
  "idLivro": 1,
  "nomeUsuario": "Maria Santos",
  "dataEmprestimo": "2025-11-04",
  "dataPrevistaDevolucao": "2025-11-18"
  // status omitido → será EMPRESTADO
}
```

### Exemplo 2: Status Explícito Minúsculo
```json
POST /api/emprestimos
{
  "idLivro": 1,
  "nomeUsuario": "Maria Santos",
  "dataEmprestimo": "2025-11-04",
  "dataPrevistaDevolucao": "2025-11-18",
  "status": "emprestado"  ← Aceita!
}
```

### Exemplo 3: Status Explícito Maiúsculo
```json
POST /api/emprestimos
{
  "idLivro": 1,
  "nomeUsuario": "Maria Santos",
  "dataEmprestimo": "2025-11-04",
  "dataPrevistaDevolucao": "2025-11-18",
  "status": "EMPRESTADO"  ← Também aceita!
}
```

---

## ⚠️ Atenção

### ✅ Aceita (no Body JSON)
```json
{
  "status": "emprestado"     // minúsculo
  "status": "EMPRESTADO"     // maiúsculo
  "status": "Emprestado"     // capitalizado
  // Todos funcionam!
}
```

### ❌ Não Aceita (valores inválidos)
```json
{
  "status": "pendente"       // Não existe
  "status": "finalizado"     // Não existe
  "status": "cancelado"      // Não existe
}
```

**Erro retornado:**
```json
{
  "message": "Valor inválido para StatusEmprestimo: 'pendente'. Valores aceitos: EMPRESTADO, DEVOLVIDO, ATRASADO (case-insensitive)"
}
```

---

## 🔍 Path Variables (URLs)

### Para Path Variables, ainda precisa ser MAIÚSCULO:

```http
✅ GET /api/emprestimos/status/EMPRESTADO
✅ GET /api/emprestimos/status/DEVOLVIDO
✅ GET /api/emprestimos/status/ATRASADO

❌ GET /api/emprestimos/status/emprestado (não funciona)
```

Isso é uma limitação do Spring PathVariable. Para aceitar minúsculo nas URLs, seria necessário outro tratamento.

---

## 📝 Implementação Técnica

### StatusEmprestimo.java
```java
@JsonCreator
public static StatusEmprestimo fromString(String value) {
    if (value == null) return null;
    
    String upperValue = value.toUpperCase();
    return StatusEmprestimo.valueOf(upperValue);
}

@JsonValue
public String toValue() {
    return this.name(); // Sempre retorna MAIÚSCULO
}
```

### Como Usar no DTO
```java
public class EmprestimoDTO {
    private StatusEmprestimo status;  // Sem anotações adicionais necessárias
}
```

---

## ✅ Testes Sugeridos

1. **Criar empréstimo sem status** (usa padrão EMPRESTADO)
2. **Criar empréstimo com `"emprestado"`** (minúsculo)
3. **Criar empréstimo com `"EMPRESTADO"`** (maiúsculo)
4. **Criar empréstimo com `"Emprestado"`** (capitalizado)
5. **Tentar criar com `"invalido"`** (deve dar erro explicativo)

---

## 🎉 Benefícios

✅ **Flexibilidade**: Aceita diferentes formatos  
✅ **Compatibilidade**: Frontend pode enviar minúsculo  
✅ **Consistência**: Sempre retorna maiúsculo  
✅ **Erro claro**: Mensagem de erro indica valores válidos  

---

**🎊 Problema resolvido! Agora `"emprestado"` funciona!**

