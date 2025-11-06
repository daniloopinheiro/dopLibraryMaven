# 📘 Documentação Swagger/OpenAPI - Biblioteca API

Guia completo da documentação interativa da API com Swagger UI.

---

## 📑 Índice

1. [O que é Swagger](#o-que-é-swagger)
2. [Instalação](#instalação)
3. [Acessar Swagger UI](#acessar-swagger-ui)
4. [Recursos Implementados](#recursos-implementados)
5. [Como Usar](#como-usar)
6. [Endpoints Documentados](#endpoints-documentados)
7. [Exemplos de Uso](#exemplos-de-uso)
8. [Personalização](#personalização)
9. [Troubleshooting](#troubleshooting)

---

## O que é Swagger?

**Swagger** (OpenAPI) é uma ferramenta de documentação interativa para APIs REST que permite:

- 📖 **Documentação automática** de endpoints
- 🧪 **Testar APIs** diretamente no navegador
- 📝 **Validação** de requisições e respostas
- 🔄 **Exportar** especificação OpenAPI (JSON/YAML)
- 🌐 **Padrão universal** de documentação de APIs

---

## Instalação

### ✅ Já Implementado!

O Swagger já está totalmente configurado no projeto. Para verificar:

#### 1. Dependência no pom.xml

```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.3.0</version>
</dependency>
```

#### 2. Configuração em application.properties

```properties
# SpringDoc OpenAPI (Swagger) Configuration
springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.swagger-ui.operationsSorter=method
springdoc.swagger-ui.tagsSorter=alpha
springdoc.swagger-ui.tryItOutEnabled=true
springdoc.swagger-ui.filter=true
springdoc.swagger-ui.syntaxHighlight.activated=true
springdoc.show-actuator=false
springdoc.version=1.0.0
```

#### 3. Classe de Configuração

Localizada em: `src/main/java/com/biblioteca/config/OpenApiConfig.java`

---

## Acessar Swagger UI

### 🌐 URLs de Acesso

#### Desenvolvimento Local

```bash
# Swagger UI (Interface Interativa)
http://localhost:8080/api/swagger-ui.html

# OpenAPI JSON
http://localhost:8080/api/api-docs

# OpenAPI YAML
http://localhost:8080/api/api-docs.yaml
```

#### Docker

```bash
# Se usando Docker
http://localhost:8080/api/swagger-ui.html
```

#### Render (Produção)

```bash
# Substitua pela sua URL do Render
https://sua-app.onrender.com/api/swagger-ui.html
```

---

## Recursos Implementados

### ✅ Funcionalidades

- 📚 **Todos os endpoints documentados**
  - Autores (8 endpoints)
  - Livros (10 endpoints)
  - Empréstimos (10 endpoints)

- 📝 **Descrições completas**
  - Summary e Description para cada endpoint
  - Parâmetros documentados
  - Exemplos de valores

- ✅ **Respostas HTTP documentadas**
  - 200 (Success)
  - 201 (Created)
  - 204 (No Content)
  - 400 (Bad Request)
  - 404 (Not Found)
  - 409 (Conflict)
  - 500 (Internal Server Error)

- 🎨 **Interface Amigável**
  - Agrupamento por tags (Autores, Livros, Empréstimos)
  - Ordenação alfabética
  - Filtros de busca
  - Syntax highlighting
  - Try it out habilitado

- 📦 **Schemas de Dados**
  - AutorDTO
  - LivroDTO
  - EmprestimoDTO
  - BatchResultDTO
  - StatusEmprestimo

---

## Como Usar

### 1. Iniciar a Aplicação

```bash
# Local com H2
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# Docker
docker-compose -f docker-compose-app.yml up -d

# Script Windows
.\docker-run-dev.bat
```

### 2. Abrir Swagger UI

Acesse no navegador:
```
http://localhost:8080/api/swagger-ui.html
```

### 3. Explorar a Documentação

1. **Ver todos os endpoints**: Expanda as tags (Autores, Livros, Empréstimos)
2. **Ver detalhes**: Clique em qualquer endpoint
3. **Testar**: Clique em "Try it out"
4. **Executar**: Preencha parâmetros e clique em "Execute"
5. **Ver resposta**: Veja a resposta HTTP completa

---

## Endpoints Documentados

### 📚 Autores (8 endpoints)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/autores` | Listar todos os autores |
| `GET` | `/api/autores/{id}` | Buscar autor por ID |
| `GET` | `/api/autores/search?name=` | Buscar autores por nome |
| `GET` | `/api/autores/nacionalidade/{nacionalidade}` | Buscar por nacionalidade |
| `POST` | `/api/autores` | Criar novo autor |
| `POST` | `/api/autores/batch` | Criar múltiplos autores |
| `PUT` | `/api/autores/{id}` | Atualizar autor |
| `DELETE` | `/api/autores/{id}` | Deletar autor |

### 📖 Livros (10 endpoints)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/livros` | Listar todos os livros |
| `GET` | `/api/livros/{id}` | Buscar livro por ID |
| `GET` | `/api/livros/search?titulo=` | Buscar livros por título |
| `GET` | `/api/livros/isbn/{isbn}` | Buscar livro por ISBN |
| `GET` | `/api/livros/autor/{idAutor}` | Listar livros por autor |
| `GET` | `/api/livros/genero/{genero}` | Listar livros por gênero |
| `GET` | `/api/livros/disponiveis` | Listar livros disponíveis |
| `POST` | `/api/livros` | Criar novo livro |
| `PUT` | `/api/livros/{id}` | Atualizar livro |
| `DELETE` | `/api/livros/{id}` | Deletar livro |

### 🔄 Empréstimos (10 endpoints)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/emprestimos` | Listar todos os empréstimos |
| `GET` | `/api/emprestimos/{id}` | Buscar empréstimo por ID |
| `GET` | `/api/emprestimos/status/{status}` | Listar por status |
| `GET` | `/api/emprestimos/livro/{idLivro}` | Listar por livro |
| `GET` | `/api/emprestimos/cpf/{cpf}` | Listar por CPF |
| `GET` | `/api/emprestimos/search?nome=` | Buscar por nome |
| `GET` | `/api/emprestimos/atrasados` | Listar atrasados |
| `POST` | `/api/emprestimos` | Criar novo empréstimo |
| `PATCH` | `/api/emprestimos/{id}/devolver` | Devolver livro |
| `PUT` | `/api/emprestimos/{id}` | Atualizar empréstimo |

---

## Exemplos de Uso

### 1. Testar GET /api/autores

1. Acesse: http://localhost:8080/api/swagger-ui.html
2. Expanda a tag **"Autores"**
3. Clique em `GET /api/autores`
4. Clique em **"Try it out"**
5. Clique em **"Execute"**
6. Veja a resposta:

```json
[
  {
    "id": 1,
    "nome": "Machado",
    "sobrenome": "de Assis",
    "nacionalidade": "Brasileiro",
    "dataNascimento": "1839-06-21"
  }
]
```

---

### 2. Criar Autor via Swagger

1. Expanda `POST /api/autores`
2. Clique em **"Try it out"**
3. Edite o JSON de exemplo:

```json
{
  "nome": "Clarice",
  "sobrenome": "Lispector",
  "nacionalidade": "Brasileira",
  "dataNascimento": "1920-12-10",
  "biografia": "Escritora e jornalista brasileira"
}
```

4. Clique em **"Execute"**
5. Veja o resultado (201 Created)

---

### 3. Buscar Autores por Nome

1. Expanda `GET /api/autores/search`
2. Clique em **"Try it out"**
3. No campo `name`, digite: `Machado`
4. Clique em **"Execute"**
5. Veja os resultados filtrados

---

### 4. Criar Livro

1. Expanda `POST /api/livros`
2. Clique em **"Try it out"**
3. Edite o JSON:

```json
{
  "titulo": "Dom Casmurro",
  "idAutor": 1,
  "isbn": "978-8535911664",
  "editora": "Penguin",
  "anoPublicacao": 1899,
  "genero": "Romance",
  "numeroPaginas": 256,
  "quantidadeEstoque": 5,
  "disponivel": true
}
```

4. Execute e veja o resultado

---

### 5. Criar Empréstimo

1. Expanda `POST /api/emprestimos`
2. Clique em **"Try it out"**
3. Edite o JSON:

```json
{
  "idLivro": 1,
  "nomeUsuario": "João Silva",
  "cpfUsuario": "123.456.789-00",
  "telefone": "(11) 98765-4321",
  "email": "joao@email.com",
  "dataEmprestimo": "2025-11-06",
  "dataPrevistaDevolucao": "2025-11-20"
}
```

4. Execute e veja o empréstimo criado

---

## Personalização

### Modificar Informações da API

Edite: `src/main/java/com/biblioteca/config/OpenApiConfig.java`

```java
@Bean
public OpenAPI customOpenAPI() {
    return new OpenAPI()
        .info(new Info()
            .title("Sua API")  // ← Altere aqui
            .version("2.0.0")  // ← Versão
            .description("Sua descrição")
            .contact(new Contact()
                .name("Seu Nome")
                .email("seu@email.com")))
        .servers(List.of(
            new Server()
                .url("https://sua-url.com")
                .description("Seu servidor")
        ));
}
```

---

### Adicionar Novo Endpoint

1. **Adicione anotações** no controller:

```java
@Operation(
    summary = "Seu endpoint",
    description = "Descrição detalhada"
)
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "Sucesso"),
    @ApiResponse(responseCode = "404", description = "Não encontrado")
})
@GetMapping("/seu-endpoint")
public ResponseEntity<Tipo> seuMetodo() {
    // código
}
```

2. **Reinicie** a aplicação
3. **Acesse** o Swagger UI
4. **Veja** o novo endpoint documentado

---

### Adicionar Autenticação (Futuro)

Para adicionar autenticação JWT/OAuth2 no Swagger:

```java
@Bean
public OpenAPI customOpenAPI() {
    return new OpenAPI()
        .components(new Components()
            .addSecuritySchemes("bearer-jwt", 
                new SecurityScheme()
                    .type(SecurityScheme.Type.HTTP)
                    .scheme("bearer")
                    .bearerFormat("JWT")
                    .in(SecurityScheme.In.HEADER)
                    .name("Authorization")))
        .addSecurityItem(new SecurityRequirement()
            .addList("bearer-jwt"));
}
```

---

## Troubleshooting

### Swagger UI não carrega

**Problema**: Página em branco ou 404

**Soluções**:

1. **Verifique a URL**:
   ```
   http://localhost:8080/api/swagger-ui.html
   ```
   (Note o `/api` no caminho)

2. **Verifique se a aplicação está rodando**:
   ```bash
   curl http://localhost:8080/api/autores
   ```

3. **Verifique dependência** no `pom.xml`:
   ```xml
   <dependency>
       <groupId>org.springdoc</groupId>
       <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
   </dependency>
   ```

4. **Limpe e recompile**:
   ```bash
   ./mvnw clean install
   ./mvnw spring-boot:run
   ```

---

### Endpoints não aparecem

**Problema**: Swagger UI carrega mas não mostra endpoints

**Soluções**:

1. **Verifique anotações** nos controllers:
   ```java
   @RestController
   @RequestMapping("/endpoint")
   @Tag(name = "Nome")  // ← Necessário
   public class Controller {
   ```

2. **Verifique scan** no `OpenApiConfig`:
   ```java
   @Configuration
   public class OpenApiConfig {  // ← Deve ter @Configuration
   ```

3. **Reinicie** a aplicação completamente

---

### "Try it out" não funciona

**Problema**: Botão "Execute" não envia requisição

**Soluções**:

1. **Verifique CORS** no controller:
   ```java
   @CrossOrigin(origins = "*")  // ← Necessário para desenvolvimento
   ```

2. **Verifique firewall/antivírus**

3. **Tente em navegador anônimo**

4. **Verifique console** do navegador (F12) para erros

---

### Schema não aparece corretamente

**Problema**: Campos do DTO não são exibidos

**Soluções**:

1. **Adicione @Schema** nos DTOs:
   ```java
   @Schema(description = "Dados do autor")
   public class AutorDTO {
       
       @Schema(description = "ID do autor", example = "1")
       private Integer id;
   }
   ```

2. **Use @Parameter** nos controllers:
   ```java
   @Parameter(description = "ID", example = "1")
   @PathVariable Integer id
   ```

---

### Erro ao compilar

**Problema**: Imports do Swagger não encontrados

**Solução**:

1. **Baixe dependências**:
   ```bash
   ./mvnw clean install -U
   ```

2. **Verifique versão** Java (21+):
   ```bash
   java -version
   ```

3. **Reimporte** projeto na IDE

---

## 📊 Estatísticas do Projeto

### Documentação Implementada

- ✅ **28 endpoints** documentados
- ✅ **3 controllers** completos
- ✅ **4 DTOs** documentados
- ✅ **1 enum** (StatusEmprestimo)
- ✅ **Exemplos** em todos os endpoints
- ✅ **Respostas HTTP** completas

---

## 🔗 Links Úteis

### Documentação Oficial

- [SpringDoc OpenAPI](https://springdoc.org/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [Swagger UI](https://swagger.io/tools/swagger-ui/)

### Tutoriais

- [SpringDoc com Spring Boot 3](https://www.baeldung.com/spring-doc-openapi-3)
- [Anotações OpenAPI](https://github.com/swagger-api/swagger-core/wiki/Swagger-2.X---Annotations)

---

## 📝 Próximos Passos

### Melhorias Futuras

1. **Autenticação**:
   - Adicionar JWT/OAuth2
   - Documentar tokens de autenticação

2. **Exemplos Completos**:
   - Adicionar mais exemplos de requisição/resposta
   - Casos de erro documentados

3. **Validações**:
   - Documentar todas as validações
   - Exemplos de erros de validação

4. **Pagination**:
   - Adicionar paginação nos endpoints GET
   - Documentar parâmetros de paginação

5. **Filtering**:
   - Filtros avançados
   - Ordenação customizada

---

## 🎓 Como Contribuir

### Adicionar Documentação em Novo Endpoint

1. **Adicione imports**:
```java
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
```

2. **Anote o método**:
```java
@Operation(
    summary = "Título curto",
    description = "Descrição detalhada do que o endpoint faz"
)
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "Sucesso"),
    @ApiResponse(responseCode = "404", description = "Não encontrado")
})
@GetMapping("/novo-endpoint")
public ResponseEntity<Tipo> novoMetodo(
    @Parameter(description = "Descrição do parâmetro", example = "exemplo")
    @PathVariable String parametro
) {
    // implementação
}
```

3. **Teste no Swagger UI**

---

## 📞 Suporte

### Issues

Para problemas ou sugestões:
- [GitHub Issues](https://github.com/daniloopinheiro/dopLibraryMaven/issues)

### Contato

- **Email**: daniloopro@gmail.com
- **LinkedIn**: [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

---

## ✅ Checklist de Implementação

- [x] Dependência SpringDoc adicionada
- [x] Configuração OpenAPI criada
- [x] Properties configuradas
- [x] AutorController documentado (8 endpoints)
- [x] LivroController documentado (10 endpoints)
- [x] EmprestimoController documentado (10 endpoints)
- [x] Tags configuradas
- [x] Servers configurados
- [x] Documentação criada (SWAGGER.md)
- [x] README atualizado

---

## 🎉 Conclusão

O Swagger está totalmente implementado e pronto para uso!

**Acesse agora:**
```
http://localhost:8080/api/swagger-ui.html
```

**Recursos disponíveis:**
- ✅ 28 endpoints documentados
- ✅ Interface interativa
- ✅ Try it out habilitado
- ✅ Exportação OpenAPI (JSON/YAML)
- ✅ Exemplos completos
- ✅ Schemas de dados

---

**Desenvolvido com ❤️ por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)**

**📘 Documentação automática da API funcionando!** 🚀

