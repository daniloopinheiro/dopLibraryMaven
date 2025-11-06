package com.biblioteca.model;

import com.biblioteca.model.enums.StatusEmprestimo;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "emprestimos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Emprestimo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_emprestimo")
    private Integer idEmprestimo;

    @ManyToOne
    @JoinColumn(name = "id_livro", nullable = false)
    private Livro livro;

    @Column(name = "nome_usuario", nullable = false)
    private String nomeUsuario;

    @Column(name = "cpf_usuario")
    private String cpfUsuario;

    private String telefone;

    private String email;

    @Column(name = "data_emprestimo", nullable = false)
    private LocalDate dataEmprestimo;

    @Column(name = "data_prevista_devolucao", nullable = false)
    private LocalDate dataPrevistaDevolucao;

    @Column(name = "data_devolucao")
    private LocalDate dataDevolucao;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private StatusEmprestimo status = StatusEmprestimo.EMPRESTADO;

    @Column(columnDefinition = "TEXT")
    private String observacoes;
}

