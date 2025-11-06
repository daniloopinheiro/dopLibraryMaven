package com.biblioteca.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Past;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AutorDTO {

    private Integer idAutor;

    @NotBlank(message = "Nome é obrigatório")
    private String nome;

    @NotBlank(message = "Sobrenome é obrigatório")
    private String sobrenome;

    private String nacionalidade;

    @Past(message = "Data de nascimento deve estar no passado")
    private LocalDate dataNascimento;

    private String biografia;

    private LocalDateTime dataCadastro;
}

