package com.biblioteca.controller;

import com.biblioteca.dto.AutorDTO;
import com.biblioteca.dto.BatchResultDTO;
import com.biblioteca.service.AutorService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/autores")
@CrossOrigin(origins = "*")
public class AutorController {

    @Autowired
    private AutorService autorService;

    @GetMapping
    public ResponseEntity<List<AutorDTO>> findAll() {
        List<AutorDTO> autores = autorService.findAll();
        return ResponseEntity.ok(autores);
    }

    @GetMapping("/{id}")
    public ResponseEntity<AutorDTO> findById(@PathVariable Integer id) {
        AutorDTO autor = autorService.findById(id);
        return ResponseEntity.ok(autor);
    }

    @GetMapping("/search")
    public ResponseEntity<List<AutorDTO>> searchByName(@RequestParam String name) {
        List<AutorDTO> autores = autorService.searchByName(name);
        return ResponseEntity.ok(autores);
    }

    @GetMapping("/nacionalidade/{nacionalidade}")
    public ResponseEntity<List<AutorDTO>> findByNacionalidade(@PathVariable String nacionalidade) {
        List<AutorDTO> autores = autorService.findByNacionalidade(nacionalidade);
        return ResponseEntity.ok(autores);
    }

    @PostMapping
    public ResponseEntity<AutorDTO> create(@Valid @RequestBody AutorDTO autorDTO) {
        AutorDTO createdAutor = autorService.create(autorDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdAutor);
    }

    @PostMapping("/batch")
    public ResponseEntity<BatchResultDTO> createBatch(@Valid @RequestBody List<AutorDTO> autoresDTO) {
        BatchResultDTO result = autorService.createBatchWithResult(autoresDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(result);
    }

    @PutMapping("/{id}")
    public ResponseEntity<AutorDTO> update(@PathVariable Integer id, @Valid @RequestBody AutorDTO autorDTO) {
        AutorDTO updatedAutor = autorService.update(id, autorDTO);
        return ResponseEntity.ok(updatedAutor);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        autorService.delete(id);
        return ResponseEntity.noContent().build();
    }
}

