-- ============================================
-- Script para corrigir tipo da coluna status
-- Execute no pgAdmin se o problema persistir após reiniciar
-- ============================================

-- Opção 1: Verificar o tipo atual
SELECT 
    column_name, 
    data_type, 
    udt_name,
    column_default
FROM information_schema.columns
WHERE table_name = 'emprestimos' 
  AND column_name = 'status';

-- ============================================
-- Se a coluna está como status_emprestimo (ENUM)
-- mas o erro persiste, recrie a constraint:
-- ============================================

-- 1. Remover constraint antiga (se existir)
ALTER TABLE emprestimos 
DROP CONSTRAINT IF EXISTS emprestimos_status_check;

-- 2. Garantir que o tipo ENUM existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'status_emprestimo') THEN
        CREATE TYPE status_emprestimo AS ENUM ('EMPRESTADO', 'DEVOLVIDO', 'ATRASADO');
    END IF;
END $$;

-- 3. Se a coluna está como VARCHAR, converter para ENUM
DO $$ 
BEGIN
    -- Verifica se a coluna é VARCHAR
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'emprestimos' 
          AND column_name = 'status' 
          AND data_type = 'character varying'
    ) THEN
        -- Converte para ENUM
        ALTER TABLE emprestimos 
        ALTER COLUMN status TYPE status_emprestimo 
        USING status::status_emprestimo;
        
        RAISE NOTICE 'Coluna status convertida de VARCHAR para status_emprestimo';
    ELSE
        RAISE NOTICE 'Coluna status já está no tipo correto';
    END IF;
END $$;

-- ============================================
-- ALTERNATIVA: Se preferir usar VARCHAR
-- (mais simples, mas menos performático)
-- ============================================

-- 1. Remover o tipo ENUM (se quiser simplificar)
-- DROP TYPE IF EXISTS status_emprestimo CASCADE;

-- 2. Converter coluna para VARCHAR
-- ALTER TABLE emprestimos 
-- ALTER COLUMN status TYPE VARCHAR(20);

-- 3. Adicionar constraint de validação
-- ALTER TABLE emprestimos
-- ADD CONSTRAINT emprestimos_status_check 
-- CHECK (status IN ('EMPRESTADO', 'DEVOLVIDO', 'ATRASADO'));

-- ============================================
-- Verificação final
-- ============================================

SELECT 
    column_name, 
    data_type, 
    udt_name
FROM information_schema.columns
WHERE table_name = 'emprestimos' 
  AND column_name = 'status';

-- Deve retornar:
-- column_name | data_type    | udt_name
-- ------------|--------------|-------------------
-- status      | USER-DEFINED | status_emprestimo

-- ============================================
-- Testar inserção manual
-- ============================================

-- Isso deve funcionar:
-- INSERT INTO emprestimos (
--     id_livro, nome_usuario, cpf_usuario, telefone, email,
--     data_emprestimo, data_prevista_devolucao, status, observacoes
-- ) VALUES (
--     1, 'João Silva', '12345678900', '11987654321', 'joao@email.com',
--     '2025-11-04', '2025-11-18', 'EMPRESTADO'::status_emprestimo, 'Teste'
-- );

-- ============================================
-- Rollback (se necessário)
-- ============================================

-- Para voltar ao estado anterior:
-- ROLLBACK;

