package com.biblioteca.repository;

import com.biblioteca.model.Autor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AutorRepository extends JpaRepository<Autor, Integer> {
    
    List<Autor> findByNomeContainingIgnoreCaseOrSobrenomeContainingIgnoreCase(String nome, String sobrenome);
    
    List<Autor> findByNacionalidade(String nacionalidade);
    
    Optional<Autor> findByNomeAndSobrenome(String nome, String sobrenome);
    
    boolean existsByNomeAndSobrenome(String nome, String sobrenome);
}

