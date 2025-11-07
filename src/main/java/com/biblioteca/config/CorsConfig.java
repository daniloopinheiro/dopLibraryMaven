package com.biblioteca.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;
import java.util.List;

/**
 * Configuração CORS (Cross-Origin Resource Sharing)
 * Permite que o Swagger UI e outras origens acessem a API
 * 
 * @author Danilo O. Pinheiro
 * @version 1.0.0
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        
        // Permitir credenciais (cookies, authorization headers)
        config.setAllowCredentials(true);
        
        // Origens permitidas
        config.setAllowedOriginPatterns(Arrays.asList(
            "*" // Permite todas as origens (desenvolvimento e produção)
            // Para produção, especifique as origens:
            // "https://biblioteca-api.onrender.com",
            // "http://localhost:8080",
            // "http://localhost:3000"
        ));
        
        // Headers permitidos
        config.setAllowedHeaders(Arrays.asList(
            "Origin",
            "Content-Type",
            "Accept",
            "Authorization",
            "X-Requested-With",
            "Access-Control-Request-Method",
            "Access-Control-Request-Headers"
        ));
        
        // Métodos HTTP permitidos
        config.setAllowedMethods(Arrays.asList(
            "GET",
            "POST",
            "PUT",
            "DELETE",
            "PATCH",
            "OPTIONS"
        ));
        
        // Headers expostos
        config.setExposedHeaders(Arrays.asList(
            "Access-Control-Allow-Origin",
            "Access-Control-Allow-Credentials",
            "Authorization"
        ));
        
        // Tempo de cache do preflight (em segundos)
        config.setMaxAge(3600L);
        
        // Aplicar configuração para todos os endpoints
        source.registerCorsConfiguration("/**", config);
        
        return new CorsFilter(source);
    }
}

