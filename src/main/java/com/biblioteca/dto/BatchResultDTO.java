package com.biblioteca.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BatchResultDTO {
    
    private List<AutorDTO> autores;
    private int totalProcessado;
    private int criados;
    private int existentes;
    private String mensagem;
    
    public BatchResultDTO(List<AutorDTO> autores, int criados, int existentes) {
        this.autores = autores;
        this.totalProcessado = autores.size();
        this.criados = criados;
        this.existentes = existentes;
        this.mensagem = String.format(
            "Total processado: %d | Criados: %d | Já existentes: %d",
            totalProcessado, criados, existentes
        );
    }
}

