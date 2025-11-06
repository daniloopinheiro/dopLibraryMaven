package com.biblioteca.controller;

import com.biblioteca.dto.EmprestimoDTO;
import com.biblioteca.model.enums.StatusEmprestimo;
import com.biblioteca.service.EmprestimoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/emprestimos")
@CrossOrigin(origins = "*")
public class EmprestimoController {

    @Autowired
    private EmprestimoService emprestimoService;

    @GetMapping
    public ResponseEntity<List<EmprestimoDTO>> findAll() {
        List<EmprestimoDTO> emprestimos = emprestimoService.findAll();
        return ResponseEntity.ok(emprestimos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EmprestimoDTO> findById(@PathVariable Integer id) {
        EmprestimoDTO emprestimo = emprestimoService.findById(id);
        return ResponseEntity.ok(emprestimo);
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<EmprestimoDTO>> findByStatus(@PathVariable StatusEmprestimo status) {
        List<EmprestimoDTO> emprestimos = emprestimoService.findByStatus(status);
        return ResponseEntity.ok(emprestimos);
    }

    @GetMapping("/livro/{idLivro}")
    public ResponseEntity<List<EmprestimoDTO>> findByLivro(@PathVariable Integer idLivro) {
        List<EmprestimoDTO> emprestimos = emprestimoService.findByLivro(idLivro);
        return ResponseEntity.ok(emprestimos);
    }

    @GetMapping("/cpf/{cpf}")
    public ResponseEntity<List<EmprestimoDTO>> findByCpfUsuario(@PathVariable String cpf) {
        List<EmprestimoDTO> emprestimos = emprestimoService.findByCpfUsuario(cpf);
        return ResponseEntity.ok(emprestimos);
    }

    @GetMapping("/search")
    public ResponseEntity<List<EmprestimoDTO>> searchByNomeUsuario(@RequestParam String nome) {
        List<EmprestimoDTO> emprestimos = emprestimoService.searchByNomeUsuario(nome);
        return ResponseEntity.ok(emprestimos);
    }

    @GetMapping("/atrasados")
    public ResponseEntity<List<EmprestimoDTO>> findEmprestimosAtrasados() {
        List<EmprestimoDTO> emprestimos = emprestimoService.findEmprestimosAtrasados();
        return ResponseEntity.ok(emprestimos);
    }

    @GetMapping("/periodo")
    public ResponseEntity<List<EmprestimoDTO>> findByPeriodo(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataFim) {
        List<EmprestimoDTO> emprestimos = emprestimoService.findByPeriodo(dataInicio, dataFim);
        return ResponseEntity.ok(emprestimos);
    }

    @PostMapping
    public ResponseEntity<EmprestimoDTO> create(@Valid @RequestBody EmprestimoDTO emprestimoDTO) {
        EmprestimoDTO createdEmprestimo = emprestimoService.create(emprestimoDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdEmprestimo);
    }

    @PatchMapping("/{id}/devolver")
    public ResponseEntity<EmprestimoDTO> devolverLivro(@PathVariable Integer id) {
        EmprestimoDTO emprestimo = emprestimoService.devolverLivro(id);
        return ResponseEntity.ok(emprestimo);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EmprestimoDTO> update(@PathVariable Integer id, @Valid @RequestBody EmprestimoDTO emprestimoDTO) {
        EmprestimoDTO updatedEmprestimo = emprestimoService.update(id, emprestimoDTO);
        return ResponseEntity.ok(updatedEmprestimo);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        emprestimoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/atualizar-atrasados")
    public ResponseEntity<Void> atualizarStatusAtrasados() {
        emprestimoService.atualizarStatusAtrasados();
        return ResponseEntity.ok().build();
    }
}

