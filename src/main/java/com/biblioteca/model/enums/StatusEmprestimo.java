package com.biblioteca.model.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum StatusEmprestimo {
    EMPRESTADO,
    DEVOLVIDO,
    ATRASADO;
    
    @JsonCreator
    public static StatusEmprestimo fromString(String value) {
        if (value == null) {
            return null;
        }
        
        // Aceita maiúsculo, minúsculo ou capitalizado
        String upperValue = value.toUpperCase();
        
        try {
            return StatusEmprestimo.valueOf(upperValue);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(
                String.format("Valor inválido para StatusEmprestimo: '%s'. Valores aceitos: EMPRESTADO, DEVOLVIDO, ATRASADO (case-insensitive)", value)
            );
        }
    }
    
    @JsonValue
    public String toValue() {
        return this.name();
    }
}

