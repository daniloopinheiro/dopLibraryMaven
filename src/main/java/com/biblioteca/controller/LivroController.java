package com.biblioteca.controller;

import com.biblioteca.dto.LivroDTO;
import com.biblioteca.service.LivroService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/livros")
@CrossOrigin(origins = "*")
@Tag(name = "Livros", description = "API para gerenciamento de livros")
public class LivroController {

    @Autowired
    private LivroService livroService;

    @GetMapping
    public ResponseEntity<List<LivroDTO>> findAll() {
        List<LivroDTO> livros = livroService.findAll();
        return ResponseEntity.ok(livros);
    }

    @GetMapping("/{id}")
    public ResponseEntity<LivroDTO> findById(@PathVariable Integer id) {
        LivroDTO livro = livroService.findById(id);
        return ResponseEntity.ok(livro);
    }

    @GetMapping("/search")
    public ResponseEntity<List<LivroDTO>> searchByTitulo(@RequestParam String titulo) {
        List<LivroDTO> livros = livroService.searchByTitulo(titulo);
        return ResponseEntity.ok(livros);
    }

    @GetMapping("/isbn/{isbn}")
    public ResponseEntity<LivroDTO> findByIsbn(@PathVariable String isbn) {
        LivroDTO livro = livroService.findByIsbn(isbn);
        return ResponseEntity.ok(livro);
    }

    @GetMapping("/autor/{idAutor}")
    public ResponseEntity<List<LivroDTO>> findByAutor(@PathVariable Integer idAutor) {
        List<LivroDTO> livros = livroService.findByAutor(idAutor);
        return ResponseEntity.ok(livros);
    }

    @GetMapping("/genero/{genero}")
    public ResponseEntity<List<LivroDTO>> findByGenero(@PathVariable String genero) {
        List<LivroDTO> livros = livroService.findByGenero(genero);
        return ResponseEntity.ok(livros);
    }

    @GetMapping("/disponiveis")
    public ResponseEntity<List<LivroDTO>> findDisponiveis() {
        List<LivroDTO> livros = livroService.findDisponiveis();
        return ResponseEntity.ok(livros);
    }

    @PostMapping
    public ResponseEntity<LivroDTO> create(@Valid @RequestBody LivroDTO livroDTO) {
        LivroDTO createdLivro = livroService.create(livroDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdLivro);
    }

    @PutMapping("/{id}")
    public ResponseEntity<LivroDTO> update(@PathVariable Integer id, @Valid @RequestBody LivroDTO livroDTO) {
        LivroDTO updatedLivro = livroService.update(id, livroDTO);
        return ResponseEntity.ok(updatedLivro);
    }

    @PatchMapping("/{id}/disponibilidade")
    public ResponseEntity<Void> updateDisponibilidade(@PathVariable Integer id, @RequestParam Boolean disponivel) {
        livroService.updateDisponibilidade(id, disponivel);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        livroService.delete(id);
        return ResponseEntity.noContent().build();
    }
}

