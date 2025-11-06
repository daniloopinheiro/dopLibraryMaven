package com.biblioteca.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.tags.Tag;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Configuração do OpenAPI (Swagger) para documentação da API
 * 
 * @author Danilo O. Pinheiro
 * @version 1.0.0
 */
@Configuration
public class OpenApiConfig {

    @Value("${springdoc.version:1.0.0}")
    private String apiVersion;

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Biblioteca API")
                        .version(apiVersion)
                        .description("""
                                **API REST completa** para gerenciamento de biblioteca com Spring Boot.
                                
                                ## Funcionalidades
                                
                                - 📚 **Gestão de Autores**: CRUD completo com busca por nome e nacionalidade
                                - 📖 **Controle de Livros**: Gerenciamento de estoque, ISBN único e busca avançada
                                - 🔄 **Empréstimos**: Sistema completo com controle de status e prazos
                                - 🆕 **Batch Operations**: Criação em lote de autores
                                
                                ## Tecnologias
                                
                                - Java 21
                                - Spring Boot 3.2.0
                                - PostgreSQL / H2
                                - Docker Ready
                                
                                ## Autenticação
                                
                                Esta versão não requer autenticação. Para produção, implemente JWT/OAuth2.
                                
                                ## Repositório
                                
                                [GitHub - dopLibraryMaven](https://github.com/daniloopinheiro/dopLibraryMaven)
                                """)
                        .contact(new Contact()
                                .name("Danilo O. Pinheiro")
                                .email("daniloopro@gmail.com")
                                .url("https://www.linkedin.com/in/daniloopinheiro/"))
                        .license(new License()
                                .name("MIT License")
                                .url("https://github.com/daniloopinheiro/dopLibraryMaven/blob/main/LICENSE.md")))
                .servers(List.of(
                        new Server()
                                .url("http://localhost:8080")
                                .description("Servidor Local"),
                        new Server()
                                .url("https://biblioteca-api.onrender.com")
                                .description("Servidor de Produção (Render)")
                ))
                .tags(List.of(
                        new Tag()
                                .name("Autores")
                                .description("Endpoints para gerenciamento de autores"),
                        new Tag()
                                .name("Livros")
                                .description("Endpoints para gerenciamento de livros"),
                        new Tag()
                                .name("Empréstimos")
                                .description("Endpoints para gerenciamento de empréstimos")
                ));
    }
}

