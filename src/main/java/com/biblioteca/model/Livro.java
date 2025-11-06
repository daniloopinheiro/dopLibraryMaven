package com.biblioteca.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "livros")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Livro {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_livro")
    private Integer idLivro;

    @Column(nullable = false)
    private String titulo;

    @ManyToOne
    @JoinColumn(name = "id_autor", nullable = false)
    private Autor autor;

    @Column(unique = true)
    private String isbn;

    private String editora;

    @Column(name = "ano_publicacao")
    private Integer anoPublicacao;

    private String genero;

    @Column(name = "numero_paginas")
    private Integer numeroPaginas;

    @Column(name = "quantidade_estoque")
    private Integer quantidadeEstoque = 1;

    @Column(nullable = false)
    private Boolean disponivel = true;

    @CreationTimestamp
    @Column(name = "data_cadastro", updatable = false)
    private LocalDateTime dataCadastro;
}

