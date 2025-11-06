# Biblioteca API

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-12+-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**API REST completa** para gerenciamento de biblioteca com Spring Boot, incluindo controle de autores, livros e empréstimos.
Suporte para múltiplos perfis de banco de dados (H2, PostgreSQL, Supabase) e deploy com Docker.

## 📑 Índice

1. [Visão Geral](#visão-geral)
2. [Tecnologias](#tecnologias)
3. [Início Rápido](#início-rápido)
4. [Perfis e Configuração](#perfis-e-configuração)
5. [Endpoints da API](#endpoints-da-api)
6. [Exemplos de Uso](#exemplos-de-uso)
7. [Docker](#docker)
8. [Deploy (Render)](#deploy-render)
9. [Estrutura do Projeto](#estrutura-do-projeto)
10. [Regras de Negócio](#regras-de-negócio)
11. [Contribuições](#contribuições)
12. [Licença](#licença)
13. [Contato](#contato)

---

## Visão Geral

A **Biblioteca API** é uma solução completa para gerenciamento de bibliotecas, oferecendo funcionalidades de cadastro e controle de autores, livros e empréstimos. Desenvolvida com Spring Boot e seguindo as melhores práticas de desenvolvimento, a API é escalável, segura e fácil de implantar.

### ✨ Recursos Principais

- 📚 **Gestão de Autores**: CRUD completo com busca por nome e nacionalidade
- 📖 **Controle de Livros**: Gerenciamento de estoque, ISBN único e busca avançada
- 🔄 **Empréstimos**: Sistema completo com controle de status e prazos
- 🆕 **Batch Operations**: Criação em lote de autores
- 🔒 **Segurança**: Validações robustas e prevenção de SQL Injection
- 🎯 **Multi-ambiente**: Suporte para H2, PostgreSQL local e Supabase
- 🐳 **Docker Ready**: Deploy facilitado com Docker Compose
- 🌐 **Interface Web**: pgAdmin integrado para gerenciamento visual

---

## Tecnologias

### 🚀 Stack Principal

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| **Java** | 17 | Linguagem base |
| **Spring Boot** | 3.2.0 | Framework principal |
| **Spring Data JPA** | - | Persistência de dados |
| **PostgreSQL** | 12+ | Banco de dados principal |
| **H2 Database** | - | Banco em memória (dev) |
| **Maven** | 3.6+ | Gerenciamento de dependências |
| **Lombok** | - | Redução de boilerplate |
| **Docker** | - | Containerização |

### 📋 Pré-requisitos

- ☕ **JDK 17** ou superior
- 📦 **Maven 3.6+**
- 🐘 **PostgreSQL 12+** (opcional - pode usar H2)
- 🐳 **Docker** (opcional - para ambiente containerizado)

---

## Início Rápido

### ⚡ Modo Mais Rápido (H2 - Recomendado para Dev)

A maneira mais fácil de começar é usar **H2 Database** (banco em memória):

```powershell
# Windows
./run-dev.bat

# Linux/Mac
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

✅ **Pronto em segundos!** Não precisa instalar nada.

- **API REST**: http://localhost:8080/api/autores
- **Console H2**: http://localhost:8080/api/h2-console
  - JDBC URL: `jdbc:h2:mem:biblioteca`
  - Username: `sa`
  - Password: *(vazio)*

### 🔧 Comandos Essenciais

```powershell
# Compilar projeto
./mvnw.cmd clean install

# Executar testes
./mvnw.cmd test

# Gerar JAR
./mvnw.cmd clean package

# Executar JAR
java -jar target/biblioteca-api-1.0.0.jar
```

---

## Perfis e Configuração

### 📋 Perfis Disponíveis

#### 1️⃣ **DEV (H2)** - Desenvolvimento ⭐ RECOMENDADO

```powershell
./run-dev.bat
```

**Características:**
- ✅ Banco em memória (H2)
- ✅ Funciona offline
- ✅ Zero configuração
- ✅ Console web incluído
- ⚠️ Dados perdidos ao reiniciar

**Ideal para:** Desenvolvimento local, testes rápidos

---

#### 2️⃣ **SUPABASE** - PostgreSQL na Nuvem ☁️

```powershell
./run-supabase.bat
```

**⚠️ IMPORTANTE:** Execute ANTES da primeira execução no Supabase SQL Editor:

```sql
CREATE TYPE status_emprestimo AS ENUM ('EMPRESTADO', 'DEVOLVIDO', 'ATRASADO');
```

**Características:**
- ✅ PostgreSQL real
- ✅ Dados persistem
- ✅ Acesso remoto
- ⚠️ Requer internet
- ⚠️ Requer configuração de credenciais

**Ideal para:** Testes em produção, demos, acesso remoto

**Configuração:**
```properties
# application-supabase.properties
spring.datasource.url=jdbc:postgresql://[SEU-HOST].supabase.co:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=[SUA-SENHA]
```

---

#### 3️⃣ **DOCKER** - PostgreSQL + pgAdmin Local 🐳

```powershell
# 1. Iniciar PostgreSQL + pgAdmin
docker-compose -f docker-compose-pgadmin.yml up -d

# 2. Executar a aplicação
./mvnw.cmd spring-boot:run -D"spring-boot.run.profiles=dev"
```

**Características:**
- ✅ PostgreSQL real
- ✅ Dados persistem
- ✅ Interface web (pgAdmin)
- ✅ Fácil reset de dados
- ⚠️ Requer Docker instalado

**Acessos:**
- **pgAdmin**: http://localhost:8082
  - Email: `admin@admin.com`
  - Password: `admin`
- **PostgreSQL**: `localhost:5432`
  - Username: `postgres`
  - Password: `postgres`
  - Database: `biblioteca`

**Comandos Docker:**
```powershell
# Ver logs
docker-compose -f docker-compose-pgadmin.yml logs -f

# Parar serviços
docker-compose -f docker-compose-pgadmin.yml down

# Parar e remover dados
docker-compose -f docker-compose-pgadmin.yml down -v
```

**Ideal para:** Desenvolvimento com persistência, testes de integração

---

#### 4️⃣ **PROD (PostgreSQL Local)** - Produção

```powershell
./mvnw.cmd spring-boot:run
```

**Características:**
- ✅ PostgreSQL instalado localmente
- ✅ Dados persistem
- ✅ Performance máxima
- ⚠️ Requer instalação e configuração manual

**Ideal para:** Produção, performance crítica

**Configuração:**
```properties
# application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/biblioteca
spring.datasource.username=postgres
spring.datasource.password=sua-senha
```

---

### 📖 Documentação Adicional

- 📘 **Guia Completo de Perfis**: `README_PROFILES.md`
- 🚀 **Quick Start Guide**: `QUICK-START.md`
- 🌐 **Interfaces Web**: `WEB-INTERFACES.md`

---

## Endpoints da API

### 👤 Autores

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/autores` | Listar todos os autores |
| `GET` | `/api/autores/{id}` | Buscar autor por ID |
| `GET` | `/api/autores/search?name={nome}` | Buscar autores por nome |
| `GET` | `/api/autores/nacionalidade/{nacionalidade}` | Buscar por nacionalidade |
| `POST` | `/api/autores` | Criar novo autor |
| `POST` | `/api/autores/batch` | 🆕 Criar múltiplos autores |
| `PUT` | `/api/autores/{id}` | Atualizar autor |
| `DELETE` | `/api/autores/{id}` | Deletar autor |

### 📚 Livros

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/livros` | Listar todos os livros |
| `GET` | `/api/livros/{id}` | Buscar livro por ID |
| `GET` | `/api/livros/search?titulo={titulo}` | Buscar livros por título |
| `GET` | `/api/livros/isbn/{isbn}` | Buscar livro por ISBN |
| `GET` | `/api/livros/autor/{idAutor}` | Listar livros por autor |
| `GET` | `/api/livros/genero/{genero}` | Listar livros por gênero |
| `GET` | `/api/livros/disponiveis` | Listar livros disponíveis |
| `POST` | `/api/livros` | Criar novo livro |
| `PUT` | `/api/livros/{id}` | Atualizar livro |
| `PATCH` | `/api/livros/{id}/disponibilidade` | Atualizar disponibilidade |
| `DELETE` | `/api/livros/{id}` | Deletar livro |

### 🔄 Empréstimos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/emprestimos` | Listar todos os empréstimos |
| `GET` | `/api/emprestimos/{id}` | Buscar empréstimo por ID |
| `GET` | `/api/emprestimos/status/{status}` | Listar por status |
| `GET` | `/api/emprestimos/livro/{idLivro}` | Listar por livro |
| `GET` | `/api/emprestimos/cpf/{cpf}` | Listar por CPF do usuário |
| `GET` | `/api/emprestimos/search?nome={nome}` | Buscar por nome |
| `GET` | `/api/emprestimos/atrasados` | Listar empréstimos atrasados |
| `GET` | `/api/emprestimos/periodo` | Listar por período |
| `POST` | `/api/emprestimos` | Criar novo empréstimo |
| `PATCH` | `/api/emprestimos/{id}/devolver` | Devolver livro |
| `PUT` | `/api/emprestimos/{id}` | Atualizar empréstimo |
| `DELETE` | `/api/emprestimos/{id}` | Deletar empréstimo |
| `POST` | `/api/emprestimos/atualizar-atrasados` | Atualizar status atrasados |

---

## Exemplos de Uso

### 📝 Criar Autor

**Request:**
```http
POST /api/autores
Content-Type: application/json

{
  "nome": "Machado",
  "sobrenome": "de Assis",
  "nacionalidade": "Brasileiro",
  "dataNascimento": "1839-06-21",
  "biografia": "Joaquim Maria Machado de Assis foi um escritor brasileiro..."
}
```

**Response:**
```json
{
  "id": 1,
  "nome": "Machado",
  "sobrenome": "de Assis",
  "nacionalidade": "Brasileiro",
  "dataNascimento": "1839-06-21",
  "biografia": "Joaquim Maria Machado de Assis foi um escritor brasileiro..."
}
```

---

### 🆕 Criar Múltiplos Autores (Batch)

**Request:**
```http
POST /api/autores/batch
Content-Type: application/json

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

**Response:**
```json
{
  "autores": [
    {
      "id": 2,
      "nome": "Clarice",
      "sobrenome": "Lispector",
      ...
    },
    {
      "id": 3,
      "nome": "Jorge",
      "sobrenome": "Amado",
      ...
    }
  ],
  "totalProcessado": 2,
  "criados": 2,
  "existentes": 0,
  "mensagem": "Total processado: 2 | Criados: 2 | Já existentes: 0"
}
```

**✨ Recursos:**
- Ignora duplicatas automaticamente
- Retorna autores existentes sem erro
- Processa em lote para melhor performance

**💡 Testar:** Execute o script `.\test-batch-create.ps1`

---

### 📖 Criar Livro

**Request:**
```http
POST /api/livros
Content-Type: application/json

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

---

### 🔄 Criar Empréstimo

**Request:**
```http
POST /api/emprestimos
Content-Type: application/json

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

**Response:**
```json
{
  "id": 1,
  "livro": {
    "id": 1,
    "titulo": "Dom Casmurro"
  },
  "nomeUsuario": "João Silva",
  "cpfUsuario": "123.456.789-00",
  "status": "EMPRESTADO",
  "dataEmprestimo": "2025-11-03",
  "dataPrevistaDevolucao": "2025-11-17"
}
```

---

## Docker

### 🐳 Configuração Completa com Docker Compose

O projeto inclui configuração Docker com PostgreSQL e pgAdmin:

**Arquivo:** `docker-compose-pgadmin.yml`

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: biblioteca-postgres
    environment:
      POSTGRES_DB: biblioteca
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: biblioteca-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "8082:80"
    depends_on:
      - postgres

volumes:
  postgres_data:
```

### 🚀 Comandos Docker

```powershell
# Iniciar serviços
docker-compose -f docker-compose-pgadmin.yml up -d

# Ver status
docker-compose -f docker-compose-pgadmin.yml ps

# Ver logs
docker-compose -f docker-compose-pgadmin.yml logs -f

# Parar serviços
docker-compose -f docker-compose-pgadmin.yml down

# Remover dados e volumes
docker-compose -f docker-compose-pgadmin.yml down -v
```

### 🌐 Acessos

- **API**: http://localhost:8080/api
- **pgAdmin**: http://localhost:8082
  - Email: `admin@admin.com`
  - Password: `admin`
- **PostgreSQL**: `localhost:5432`

---

## Deploy (Render)

### 🚀 Deploy Rápido no Render.com

A aplicação está pronta para deploy no [Render.com](https://render.com) com configuração otimizada.

#### Passo a Passo

1. **Fork/Clone** este repositório
2. **Criar conta** no [Render](https://render.com)
3. **New Web Service** > Conectar repositório
4. **Configurar**:
   - **Dockerfile Path**: `Dockerfile.render` ⚠️ IMPORTANTE
   - **Environment Variables**:
     ```
     SPRING_PROFILES_ACTIVE=dev
     ```

5. **Deploy!** 🚀

#### Arquivos para Deploy

| Arquivo | Descrição |
|---------|-----------|
| `Dockerfile.render` | Dockerfile otimizado para Render |
| `render.yaml` | Configuração Blueprint (opcional) |
| `RENDER-DEPLOY.md` | Guia completo de deploy |

#### Documentação Completa

- 📘 **[RENDER-DEPLOY.md](RENDER-DEPLOY.md)** - Guia completo com:
  - Solução para erro 502 (Maven Central)
  - Deploy passo a passo
  - Configuração de variáveis
  - Troubleshooting detalhado
  - Integração com PostgreSQL
  - Monitoramento e logs

#### Testar Localmente Antes

```bash
# Windows
.\test-render-dockerfile.bat

# Linux/Mac ou PowerShell
.\test-render-dockerfile.ps1
```

Se funcionar localmente, funcionará no Render! ✅

#### Quick Links

- 🌐 **Deploy**: [render.com](https://render.com)
- 📚 **Docs**: [RENDER-DEPLOY.md](RENDER-DEPLOY.md)
- 🐳 **Docker**: [DOCKER.md](DOCKER.md)

---

## Estrutura do Projeto

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/biblioteca/
│   │   │   ├── controller/          # 🎮 Controladores REST
│   │   │   ├── dto/                 # 📦 Data Transfer Objects
│   │   │   ├── exception/           # ⚠️ Tratamento de exceções
│   │   │   ├── model/               # 🗄️ Entidades JPA
│   │   │   │   └── enums/           # 📋 Enumerações
│   │   │   ├── repository/          # 🔍 Repositórios JPA
│   │   │   ├── service/             # ⚙️ Lógica de negócio
│   │   │   └── BibliotecaApplication.java
│   │   └── resources/
│   │       ├── application.properties           # 🔧 Config PROD
│   │       ├── application-dev.properties       # 🔧 Config DEV (H2)
│   │       └── application-supabase.properties  # 🔧 Config Supabase
│   └── test/                        # 🧪 Testes
├── scripts/                         # 📜 Scripts úteis
│   ├── run-dev.bat
│   ├── run-supabase.bat
│   └── test-batch-create.ps1
├── docker-compose-pgadmin.yml       # 🐳 Docker config
├── pom.xml                          # 📦 Maven config
└── README.md                        # 📖 Este arquivo
```

---

## Regras de Negócio

### 📚 Livros

- ✅ **ISBN único**: Cada livro deve ter um ISBN único no sistema
- ✅ **Controle de estoque**: Livro só fica indisponível quando estoque = 0
- ✅ **Validações**: Título, autor e ISBN são obrigatórios
- ✅ **Relacionamento**: Todo livro deve estar vinculado a um autor existente

### 🔄 Empréstimos

- ✅ **Disponibilidade**: Livro deve estar disponível (estoque > 0)
- ✅ **Datas**: Data de devolução deve ser posterior à data de empréstimo
- ✅ **Estoque automático**:
  - Ao emprestar: estoque é decrementado
  - Ao devolver: estoque é incrementado
- ✅ **Status automático**:
  - `EMPRESTADO`: Quando criado
  - `DEVOLVIDO`: Quando devolvido
  - `ATRASADO`: Quando passa da data prevista
- ✅ **Validações**: CPF, email e telefone são validados

### 👤 Autores

- ✅ **Dados completos**: Nome, sobrenome e nacionalidade obrigatórios
- ✅ **Batch creation**: Suporte para criação em lote
- ✅ **Duplicatas**: Sistema ignora autores duplicados em batch
- ✅ **Busca flexível**: Busca por nome parcial e nacionalidade

---

## 🔒 Segurança

### Funcionalidades Implementadas

- ✅ **Validação de entrada**: Todos os endpoints validam dados de entrada
- ✅ **Tratamento global de exceções**: Respostas consistentes de erro
- ✅ **SQL Injection**: Prevenção automática via JPA/Hibernate
- ✅ **Regras de negócio**: Validações no service layer
- ✅ **CORS**: Configurado para desenvolvimento (ajustar para produção)

### Recomendações para Produção

- 🔐 Implementar autenticação (JWT/OAuth2)
- 🔐 Adicionar autorização baseada em roles
- 🔐 Configurar HTTPS
- 🔐 Implementar rate limiting
- 🔐 Adicionar logging de auditoria

---

## Contribuições

Contribuições são bem-vindas! Para contribuir:

1. **Fork** o projeto
2. **Crie uma branch** para sua feature
   ```bash
   git checkout -b feature/MinhaFeature
   ```
3. **Commit** suas mudanças
   ```bash
   git commit -m 'feat: Adiciona nova funcionalidade'
   ```
4. **Push** para a branch
   ```bash
   git push origin feature/MinhaFeature
   ```
5. Abra um **Pull Request**

### 📝 Convenções de Commit

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `refactor:` Refatoração de código
- `test:` Testes
- `chore:` Tarefas de manutenção

---

## Configuração

Se o seu software requer configuração adicional além da instalação padrão, explique aqui como configurá-lo.
Isso pode incluir variáveis de ambiente, arquivos de configuração ou qualquer ajuste necessário para personalizar o comportamento do software.

---

## Contribuições

Explique se você está aberto para contribuições e como outros desenvolvedores podem ajudar.
Inclua orientações para quem deseja reportar bugs, enviar solicitações de novos recursos ou fazer alterações no código.

---

## Artigos & Conteúdos

* 💼 [LinkedIn](https://www.linkedin.com/in/daniloopinheiro)
* ✍️ [Medium](https://medium.com/@daniloopinheiro)
* 💻 [Dev.to](https://dev.to/daniloopinheiro)

---

## Licença

MIT License © 2025 [LICENSE.md](https://github.com/daniloopinheiro/dopBase/blob/main/LICENSE.md) — por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

---

## Contato

### 💬 Suporte Técnico
Para questões técnicas, problemas ou sugestões:
- **Issues**: [GitHub Issues](https://github.com/daniloopinheiro/dopNetHL7/issues)
- **Discussions**: [GitHub Discussions](https://github.com/daniloopinheiro/dopNetHL7/discussions)

### 👨‍💻 Autor
**Danilo O. Pinheiro**
Especialista em .NET, Clean Architecture e Interoperabilidade em Saúde

- **Email Pessoal**: [daniloopro@gmail.com](mailto:daniloopro@gmail.com)
- **Email Empresarial**: [devsfree@devsfree.com.br](mailto:devsfree@devsfree.com.br)
- **Consultoria**: [contato@dopme.io](mailto:contato@dopme.io)
- **LinkedIn**: [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

### 🏢 Empresas
- **[DevsFree](https://devsfree.com.br)**: Desenvolvimento de Software
- **[dopme.io](https://dopme.io)**: Consultoria e Soluções Tecnológicas

---

<div align="center">

**⭐ Se este projeto foi útil, deixe uma estrela no GitHub! ⭐**