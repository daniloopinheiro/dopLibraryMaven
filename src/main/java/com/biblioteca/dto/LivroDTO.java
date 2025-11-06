package com.biblioteca.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LivroDTO {

    private Integer idLivro;

    @NotBlank(message = "Título é obrigatório")
    private String titulo;

    @NotNull(message = "Autor é obrigatório")
    private Integer idAutor;

    private String nomeAutor;

    private String isbn;

    private String editora;

    @Min(value = 1000, message = "Ano de publicação deve ser maior que 999")
    private Integer anoPublicacao;

    private String genero;

    @Min(value = 1, message = "Número de páginas deve ser maior que 0")
    private Integer numeroPaginas;

    @Min(value = 0, message = "Quantidade em estoque não pode ser negativa")
    private Integer quantidadeEstoque;

    private Boolean disponivel;

    private LocalDateTime dataCadastro;
}

