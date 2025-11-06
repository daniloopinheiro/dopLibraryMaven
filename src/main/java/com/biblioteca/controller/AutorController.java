package com.biblioteca.controller;

import com.biblioteca.dto.AutorDTO;
import com.biblioteca.dto.BatchResultDTO;
import com.biblioteca.service.AutorService;
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
@RequestMapping("/autores")
@CrossOrigin(origins = "*")
@Tag(name = "Autores", description = "API para gerenciamento de autores")
public class AutorController {

    @Autowired
    private AutorService autorService;

    @Operation(
        summary = "Listar todos os autores",
        description = "Retorna uma lista com todos os autores cadastrados no sistema"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista de autores retornada com sucesso"),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @GetMapping
    public ResponseEntity<List<AutorDTO>> findAll() {
        List<AutorDTO> autores = autorService.findAll();
        return ResponseEntity.ok(autores);
    }

    @Operation(
        summary = "Buscar autor por ID",
        description = "Retorna um autor específico com base no ID fornecido"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Autor encontrado"),
        @ApiResponse(responseCode = "404", description = "Autor não encontrado", content = @Content),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @GetMapping("/{id}")
    public ResponseEntity<AutorDTO> findById(
        @Parameter(description = "ID do autor", required = true, example = "1")
        @PathVariable Integer id
    ) {
        AutorDTO autor = autorService.findById(id);
        return ResponseEntity.ok(autor);
    }

    @Operation(
        summary = "Buscar autores por nome",
        description = "Busca autores cujo nome ou sobrenome contenha o texto fornecido (busca parcial)"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso"),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @GetMapping("/search")
    public ResponseEntity<List<AutorDTO>> searchByName(
        @Parameter(description = "Nome ou parte do nome do autor", required = true, example = "Machado")
        @RequestParam String name
    ) {
        List<AutorDTO> autores = autorService.searchByName(name);
        return ResponseEntity.ok(autores);
    }

    @Operation(
        summary = "Buscar autores por nacionalidade",
        description = "Retorna todos os autores de uma determinada nacionalidade"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso"),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @GetMapping("/nacionalidade/{nacionalidade}")
    public ResponseEntity<List<AutorDTO>> findByNacionalidade(
        @Parameter(description = "Nacionalidade do autor", required = true, example = "Brasileiro")
        @PathVariable String nacionalidade
    ) {
        List<AutorDTO> autores = autorService.findByNacionalidade(nacionalidade);
        return ResponseEntity.ok(autores);
    }

    @Operation(
        summary = "Criar novo autor",
        description = "Cria um novo autor no sistema com os dados fornecidos"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Autor criado com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos", content = @Content),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @PostMapping
    public ResponseEntity<AutorDTO> create(
        @io.swagger.v3.oas.annotations.parameters.RequestBody(
            description = "Dados do autor a ser criado",
            required = true,
            content = @Content(schema = @Schema(implementation = AutorDTO.class))
        )
        @Valid @RequestBody AutorDTO autorDTO
    ) {
        AutorDTO createdAutor = autorService.create(autorDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdAutor);
    }

    @Operation(
        summary = "Criar múltiplos autores em lote",
        description = "Cria vários autores de uma vez. Ignora duplicatas automaticamente e retorna estatísticas da operação"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Operação em lote concluída"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos", content = @Content),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @PostMapping("/batch")
    public ResponseEntity<BatchResultDTO> createBatch(
        @io.swagger.v3.oas.annotations.parameters.RequestBody(
            description = "Lista de autores a serem criados",
            required = true
        )
        @Valid @RequestBody List<AutorDTO> autoresDTO
    ) {
        BatchResultDTO result = autorService.createBatchWithResult(autoresDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(result);
    }

    @Operation(
        summary = "Atualizar autor",
        description = "Atualiza os dados de um autor existente"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Autor atualizado com sucesso"),
        @ApiResponse(responseCode = "404", description = "Autor não encontrado", content = @Content),
        @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos", content = @Content),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @PutMapping("/{id}")
    public ResponseEntity<AutorDTO> update(
        @Parameter(description = "ID do autor", required = true, example = "1")
        @PathVariable Integer id,
        @io.swagger.v3.oas.annotations.parameters.RequestBody(
            description = "Dados atualizados do autor",
            required = true,
            content = @Content(schema = @Schema(implementation = AutorDTO.class))
        )
        @Valid @RequestBody AutorDTO autorDTO
    ) {
        AutorDTO updatedAutor = autorService.update(id, autorDTO);
        return ResponseEntity.ok(updatedAutor);
    }

    @Operation(
        summary = "Deletar autor",
        description = "Remove um autor do sistema. Atenção: só é possível deletar autores que não possuem livros cadastrados"
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Autor deletado com sucesso"),
        @ApiResponse(responseCode = "404", description = "Autor não encontrado", content = @Content),
        @ApiResponse(responseCode = "409", description = "Autor possui livros cadastrados", content = @Content),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor", content = @Content)
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
        @Parameter(description = "ID do autor", required = true, example = "1")
        @PathVariable Integer id
    ) {
        autorService.delete(id);
        return ResponseEntity.noContent().build();
    }
}

