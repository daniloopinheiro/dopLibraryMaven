# 📦 Teste de API - Criação em Lote (Batch)

## ✅ Novo Endpoint Implementado

A API agora suporta a criação de **múltiplos autores de uma vez**!

### Endpoint Batch
```
POST /api/autores/batch
Content-Type: application/json
```

### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/autores` | Criar **um** autor |
| `POST` | `/api/autores/batch` | Criar **múltiplos** autores |

---

## 🚀 Como Testar

### 1. Iniciar a Aplicação

```powershell
# Iniciar PostgreSQL + pgAdmin
docker-compose -f docker-compose-pgadmin.yml up -d

# Executar a aplicação
.\mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
```

### 2. Testar com cURL

#### Criar múltiplos autores:

```bash
curl -X POST http://localhost:8080/api/autores/batch \
  -H "Content-Type: application/json" \
  -d @test-autores-batch.json
```

#### Versão PowerShell:

```powershell
$json = Get-Content test-autores-batch.json -Raw

Invoke-RestMethod -Uri "http://localhost:8080/api/autores/batch" `
  -Method POST `
  -ContentType "application/json" `
  -Body $json
```

### 3. Testar com Postman/Insomnia

**URL:** `http://localhost:8080/api/autores/batch`  
**Método:** `POST`  
**Headers:**
```
Content-Type: application/json
```

**Body (raw JSON):**
```json
[
    {
        "nome": "Clarice",
        "sobrenome": "Lispector",
        "nacionalidade": "Brasileira",
        "dataNascimento": "1920-12-10",
        "biografia": "Clarice Lispector foi uma escritora e jornalista nascida na Ucrânia e naturalizada brasileira. É considerada uma das escritoras brasileiras mais importantes do século XX. Sua obra é marcada por um estilo introspectivo e inovador. Principais obras: A Hora da Estrela, A Paixão Segundo G.H., Laços de Família."
    },
    {
        "nome": "Jorge",
        "sobrenome": "Amado",
        "nacionalidade": "Brasileiro",
        "dataNascimento": "1912-08-10",
        "biografia": "Jorge Leal Amado de Faria foi um dos mais famosos e traduzidos escritores brasileiros. Suas obras retratam a cultura baiana, o sincretismo religioso e a vida do povo. Escreveu romances que se tornaram clássicos como Gabriela, Cravo e Canela, Capitães da Areia, Dona Flor e Seus Dois Maridos."
    }
]
```

---

## 📋 Exemplos de Resposta

### Sucesso (201 Created)

```json
{
    "autores": [
        {
            "idAutor": 1,
            "nome": "Clarice",
            "sobrenome": "Lispector",
            "nacionalidade": "Brasileira",
            "dataNascimento": "1920-12-10",
            "biografia": "Clarice Lispector foi uma escritora e jornalista...",
            "dataCadastro": "2025-11-04T17:30:00"
        },
        {
            "idAutor": 2,
            "nome": "Jorge",
            "sobrenome": "Amado",
            "nacionalidade": "Brasileiro",
            "dataNascimento": "1912-08-10",
            "biografia": "Jorge Leal Amado de Faria foi um dos mais famosos...",
            "dataCadastro": "2025-11-04T17:30:00"
        }
    ],
    "totalProcessado": 2,
    "criados": 2,
    "existentes": 0,
    "mensagem": "Total processado: 2 | Criados: 2 | Já existentes: 0"
}
```

### ✨ Resposta com Duplicatas (201 Created)

Se você tentar criar autores que já existem:

```json
{
    "autores": [
        {
            "idAutor": 1,
            "nome": "Clarice",
            "sobrenome": "Lispector",
            ...
        },
        {
            "idAutor": 2,
            "nome": "Jorge",
            "sobrenome": "Amado",
            ...
        }
    ],
    "totalProcessado": 2,
    "criados": 0,
    "existentes": 2,
    "mensagem": "Total processado: 2 | Criados: 0 | Já existentes: 2"
}
```

**💡 A API agora ignora duplicatas automaticamente!**

### Erro de Validação (400 Bad Request)

```json
{
    "timestamp": "2025-11-04T17:30:00",
    "status": 400,
    "error": "Bad Request",
    "message": "Validation failed",
    "path": "/api/autores/batch"
}
```

---

## 🔍 Verificar os Dados

### Listar todos os autores:
```bash
curl http://localhost:8080/api/autores
```

### PowerShell:
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/api/autores"
```

### Via pgAdmin:

1. Acesse: http://localhost:8082
2. Login: `admin@admin.com` / `admin`
3. Execute a query:

```sql
SELECT * FROM autores ORDER BY data_cadastro DESC;
```

---

## 💡 Validações

Os seguintes campos são obrigatórios:
- ✅ `nome` (não pode ser nulo ou vazio)
- ✅ `sobrenome` (não pode ser nulo ou vazio)

Campos opcionais:
- `nacionalidade`
- `dataNascimento`
- `biografia`

---

## 🎯 Casos de Uso

### Caso 1: Importação de Dados
Perfeito para importar múltiplos autores de uma planilha ou arquivo JSON.

### Caso 2: Seed de Dados
Útil para popular o banco de dados com dados de teste.

### Caso 3: Performance
Criar múltiplos registros em uma única transação é mais eficiente que múltiplas chamadas individuais.

---

## 🔧 Scripts PowerShell de Teste

### Criar autores em lote:
```powershell
# test-batch-create.ps1
$json = @"
[
    {
        "nome": "Clarice",
        "sobrenome": "Lispector",
        "nacionalidade": "Brasileira",
        "dataNascimento": "1920-12-10",
        "biografia": "Clarice Lispector foi uma escritora e jornalista..."
    },
    {
        "nome": "Jorge",
        "sobrenome": "Amado",
        "nacionalidade": "Brasileiro",
        "dataNascimento": "1912-08-10",
        "biografia": "Jorge Leal Amado de Faria foi um dos mais famosos..."
    }
]
"@

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/autores/batch" `
                                  -Method POST `
                                  -ContentType "application/json" `
                                  -Body $json
    
    Write-Host "✅ Sucesso! Autores criados:" -ForegroundColor Green
    $response | ForEach-Object {
        Write-Host "  - ID: $($_.idAutor) | Nome: $($_.nome) $($_.sobrenome)" -ForegroundColor Cyan
    }
}
catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}
```

### Listar todos os autores:
```powershell
# test-list-autores.ps1
try {
    $autores = Invoke-RestMethod -Uri "http://localhost:8080/api/autores"
    
    Write-Host "`n📚 Total de autores: $($autores.Count)" -ForegroundColor Yellow
    Write-Host "`nLista de Autores:" -ForegroundColor Cyan
    Write-Host "─────────────────────────────────────────" -ForegroundColor Gray
    
    $autores | ForEach-Object {
        Write-Host "ID: $($_.idAutor)" -ForegroundColor White
        Write-Host "Nome: $($_.nome) $($_.sobrenome)" -ForegroundColor Green
        Write-Host "Nacionalidade: $($_.nacionalidade)" -ForegroundColor Yellow
        Write-Host "Data Nascimento: $($_.dataNascimento)" -ForegroundColor Magenta
        Write-Host "─────────────────────────────────────────" -ForegroundColor Gray
    }
}
catch {
    Write-Host "❌ Erro: $_" -ForegroundColor Red
}
```

---

## 📊 Comparação de Performance

| Método | Requisições | Transações | Performance |
|--------|-------------|------------|-------------|
| Individual | 100 autores = 100 requests | 100 | ❌ Lento |
| Batch | 100 autores = 1 request | 1 | ✅ Rápido |

---

## ✅ Checklist de Teste

- [ ] Aplicação Spring Boot está rodando
- [ ] PostgreSQL está rodando (Docker)
- [ ] Arquivo `test-autores-batch.json` existe
- [ ] Endpoint `/api/autores/batch` retorna 201 Created
- [ ] Autores aparecem em `/api/autores`
- [ ] Dados estão visíveis no pgAdmin

---

🎉 **Pronto para testar!** Execute a aplicação e use o endpoint `/api/autores/batch`

