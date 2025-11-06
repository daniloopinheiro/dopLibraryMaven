# Biblioteca API - Sistema de Gerenciamento de Biblioteca

API REST desenvolvida com Spring Boot para gerenciamento de biblioteca, incluindo controle de autores, livros e empréstimos.

## 🚀 Tecnologias

- Java 17
- Spring Boot 3.2.0
- Spring Data JPA
- PostgreSQL
- Maven
- Lombok

## 📋 Pré-requisitos

- JDK 17 ou superior
- Maven 3.6+
- PostgreSQL 12+

## ⚙️ Configuração e Execução

### 🚀 Início Rápido (Recomendado)

A maneira mais fácil de começar é usar **H2 Database** (banco em memória):

```powershell
# Windows
./run-dev.bat

# Linux/Mac
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

✅ **Pronto!** A aplicação estará rodando em segundos sem precisar instalar nada!

- **API REST**: http://localhost:8080/api/autores
- **Console H2**: http://localhost:8080/api/h2-console

---

### 📋 Perfis Disponíveis

#### 1. DEV (H2 - Desenvolvimento) - **RECOMENDADO**
```powershell
./run-dev.bat
```
- ✅ Sem instalação
- ✅ Funciona offline
- ⚠️ Dados são perdidos ao reiniciar

#### 2. SUPABASE (PostgreSQL Cloud)
```powershell
./run-supabase.bat
```
**ANTES da primeira execução**, execute no Supabase SQL Editor:
```sql
CREATE TYPE status_emprestimo AS ENUM ('EMPRESTADO', 'DEVOLVIDO', 'ATRASADO');
```
- ✅ PostgreSQL real
- ✅ Dados persistem
- ⚠️ Requer internet

#### 3. Docker (PostgreSQL Local) - **NOVO! 🐳**
```powershell
# 1. Iniciar PostgreSQL + pgAdmin com Docker
docker-compose -f docker-compose-pgadmin.yml up -d

# 2. Executar a aplicação
./mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
```
- ✅ PostgreSQL real
- ✅ Dados persistem
- ✅ Fácil de configurar
- ✅ Interface web (pgAdmin) em http://localhost:8082
- ⚠️ Requer Docker instalado

📖 **Ver guia completo:** `QUICK-START.md` ou `WEB-INTERFACES.md`

#### 4. PostgreSQL Local (Instalação Manual)
```powershell
./mvnw.cmd spring-boot:run
```
Requer configuração do PostgreSQL local.

📖 **Ver guia completo:** `README_PROFILES.md`

---

## 🏃 Comandos Úteis

### Compilar
```powershell
./mvnw.cmd clean install
```

### Executar (H2)
```powershell
./run-dev.bat
```

### Executar (Supabase)
```powershell
./run-supabase.bat
```

### Gerar JAR
```powershell
./mvnw.cmd clean package
java -jar target/biblioteca-api-1.0.0.jar
```

### Docker (PostgreSQL + pgAdmin)
```powershell
# Iniciar serviços (PostgreSQL + pgAdmin)
docker-compose -f docker-compose-pgadmin.yml up -d

# Acessar pgAdmin
# URL: http://localhost:8082
# Login: admin@admin.com / admin

# Ver logs
docker-compose -f docker-compose-pgadmin.yml logs -f

# Parar serviços
docker-compose -f docker-compose-pgadmin.yml down

# Parar e remover dados
docker-compose -f docker-compose-pgadmin.yml down -v
```

A aplicação estará disponível em: `http://localhost:8080/api`

## 📚 Endpoints da API

### Autores

- `GET /api/autores` - Listar todos os autores
- `GET /api/autores/{id}` - Buscar autor por ID
- `GET /api/autores/search?name={nome}` - Buscar autores por nome
- `GET /api/autores/nacionalidade/{nacionalidade}` - Buscar autores por nacionalidade
- `POST /api/autores` - Criar novo autor
- `POST /api/autores/batch` - 🆕 **Criar múltiplos autores (Batch)**
- `PUT /api/autores/{id}` - Atualizar autor
- `DELETE /api/autores/{id}` - Deletar autor

### Livros

- `GET /api/livros` - Listar todos os livros
- `GET /api/livros/{id}` - Buscar livro por ID
- `GET /api/livros/search?titulo={titulo}` - Buscar livros por título
- `GET /api/livros/isbn/{isbn}` - Buscar livro por ISBN
- `GET /api/livros/autor/{idAutor}` - Listar livros por autor
- `GET /api/livros/genero/{genero}` - Listar livros por gênero
- `GET /api/livros/disponiveis` - Listar livros disponíveis
- `POST /api/livros` - Criar novo livro
- `PUT /api/livros/{id}` - Atualizar livro
- `PATCH /api/livros/{id}/disponibilidade?disponivel={true|false}` - Atualizar disponibilidade
- `DELETE /api/livros/{id}` - Deletar livro

### Empréstimos

- `GET /api/emprestimos` - Listar todos os empréstimos
- `GET /api/emprestimos/{id}` - Buscar empréstimo por ID
- `GET /api/emprestimos/status/{status}` - Listar empréstimos por status
- `GET /api/emprestimos/livro/{idLivro}` - Listar empréstimos por livro
- `GET /api/emprestimos/cpf/{cpf}` - Listar empréstimos por CPF do usuário
- `GET /api/emprestimos/search?nome={nome}` - Buscar empréstimos por nome do usuário
- `GET /api/emprestimos/atrasados` - Listar empréstimos atrasados
- `GET /api/emprestimos/periodo?dataInicio={data}&dataFim={data}` - Listar empréstimos por período
- `POST /api/emprestimos` - Criar novo empréstimo
- `PATCH /api/emprestimos/{id}/devolver` - Devolver livro
- `PUT /api/emprestimos/{id}` - Atualizar empréstimo
- `DELETE /api/emprestimos/{id}` - Deletar empréstimo
- `POST /api/emprestimos/atualizar-atrasados` - Atualizar status dos empréstimos atrasados

## 📝 Exemplos de Requisições

### Criar Autor

```json
POST /api/autores
{
  "nome": "Machado",
  "sobrenome": "de Assis",
  "nacionalidade": "Brasileiro",
  "dataNascimento": "1839-06-21",
  "biografia": "Joaquim Maria Machado de Assis foi um escritor brasileiro..."
}
```

### 🆕 Criar Múltiplos Autores (Batch)

```json
POST /api/autores/batch
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
```

**Resposta:**
```json
{
  "autores": [...],
  "totalProcessado": 2,
  "criados": 2,
  "existentes": 0,
  "mensagem": "Total processado: 2 | Criados: 2 | Já existentes: 0"
}
```

**✨ Ignora duplicatas automaticamente!** Se um autor já existir, ele será retornado sem erro.

**💡 Testar:** `.\test-batch-create.ps1`

### Criar Livro

```json
POST /api/livros
{
  "titulo": "Dom Casmurro",
  "idAutor": 1,
  "isbn": "978-8535911664",
  "editora": "Penguin Companhia",
  "anoPublicacao": 1899,
  "genero": "Romance",
  "numeroPaginas": 256,
  "quantidadeEstoque": 5,
  "disponivel": true
}
```

### Criar Empréstimo

```json
POST /api/emprestimos
{
  "idLivro": 1,
  "nomeUsuario": "João Silva",
  "cpfUsuario": "123.456.789-00",
  "telefone": "(11) 98765-4321",
  "email": "joao.silva@email.com",
  "dataEmprestimo": "2025-11-03",
  "dataPrevistaDevolucao": "2025-11-17",
  "observacoes": "Cliente regular"
}
```

## 🔒 Funcionalidades de Segurança

- Validação de entrada em todos os endpoints
- Tratamento global de exceções
- Prevenção de SQL Injection através de JPA/Hibernate
- Validação de regras de negócio (ex: livro disponível antes de emprestar)

## 📦 Estrutura do Projeto

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/biblioteca/
│   │   │   ├── controller/      # Controladores REST
│   │   │   ├── dto/              # Data Transfer Objects
│   │   │   ├── exception/        # Tratamento de exceções
│   │   │   ├── model/            # Entidades JPA
│   │   │   │   └── enums/        # Enumerações
│   │   │   ├── repository/       # Repositórios JPA
│   │   │   ├── service/          # Lógica de negócio
│   │   │   └── BibliotecaApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── pom.xml
└── README.md
```

## 🎯 Regras de Negócio

1. **Livros**: 
   - ISBN deve ser único
   - Livro só fica indisponível quando estoque chega a zero
   
2. **Empréstimos**:
   - Livro deve estar disponível e com estoque > 0
   - Data de devolução deve ser posterior à data de empréstimo
   - Ao emprestar, estoque é decrementado
   - Ao devolver, estoque é incrementado
   - Status atrasado é definido automaticamente

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

