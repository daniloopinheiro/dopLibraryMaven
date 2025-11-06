package com.biblioteca.dto;

import com.biblioteca.model.enums.StatusEmprestimo;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmprestimoDTO {

    private Integer idEmprestimo;

    @NotNull(message = "Livro é obrigatório")
    private Integer idLivro;

    private String tituloLivro;

    @NotBlank(message = "Nome do usuário é obrigatório")
    private String nomeUsuario;

    private String cpfUsuario;

    private String telefone;

    @Email(message = "Email inválido")
    private String email;

    @NotNull(message = "Data de empréstimo é obrigatória")
    private LocalDate dataEmprestimo;

    @NotNull(message = "Data prevista de devolução é obrigatória")
    @FutureOrPresent(message = "Data prevista de devolução deve ser hoje ou no futuro")
    private LocalDate dataPrevistaDevolucao;

    private LocalDate dataDevolucao;

    private StatusEmprestimo status;

    private String observacoes;
}

