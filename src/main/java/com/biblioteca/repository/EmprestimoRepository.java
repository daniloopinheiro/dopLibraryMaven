package com.biblioteca.repository;

import com.biblioteca.model.Emprestimo;
import com.biblioteca.model.enums.StatusEmprestimo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface EmprestimoRepository extends JpaRepository<Emprestimo, Integer> {
    
    List<Emprestimo> findByStatus(StatusEmprestimo status);
    
    List<Emprestimo> findByLivroIdLivro(Integer idLivro);
    
    List<Emprestimo> findByCpfUsuario(String cpfUsuario);
    
    List<Emprestimo> findByNomeUsuarioContainingIgnoreCase(String nomeUsuario);
    
    @Query("SELECT e FROM Emprestimo e WHERE e.status = 'EMPRESTADO' AND e.dataPrevistaDevolucao < :dataAtual")
    List<Emprestimo> findEmprestimosAtrasados(LocalDate dataAtual);
    
    @Query("SELECT e FROM Emprestimo e WHERE e.dataEmprestimo BETWEEN :dataInicio AND :dataFim")
    List<Emprestimo> findByPeriodo(LocalDate dataInicio, LocalDate dataFim);
}

