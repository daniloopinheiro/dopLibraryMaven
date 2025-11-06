package com.biblioteca.repository;

import com.biblioteca.model.Livro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LivroRepository extends JpaRepository<Livro, Integer> {
    
    List<Livro> findByTituloContainingIgnoreCase(String titulo);
    
    Optional<Livro> findByIsbn(String isbn);
    
    List<Livro> findByAutorIdAutor(Integer idAutor);
    
    List<Livro> findByGenero(String genero);
    
    List<Livro> findByDisponivel(Boolean disponivel);
    
    @Query("SELECT l FROM Livro l WHERE l.disponivel = true AND l.quantidadeEstoque > 0")
    List<Livro> findLivrosDisponiveis();
}

