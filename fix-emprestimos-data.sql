-- ============================================
-- Script para corrigir dados dos empréstimos
-- Converte valores minúsculos para MAIÚSCULOS
-- ============================================

-- 1. Ver os dados atuais (para conferir)
SELECT 
    id_emprestimo,
    nome_usuario,
    status,
    data_emprestimo
FROM emprestimos
ORDER BY id_emprestimo;

-- ============================================
-- 2. CORRIGIR: Converter todos para MAIÚSCULO
-- ============================================

-- Opção A: UPDATE direto (se a coluna já é ENUM)
UPDATE emprestimos 
SET status = UPPER(status::text)::status_emprestimo
WHERE status IS NOT NULL;

-- Opção B: Se a coluna é VARCHAR
-- UPDATE emprestimos 
-- SET status = UPPER(status);

-- ============================================
-- 3. Verificar se corrigiu
-- ============================================

SELECT 
    id_emprestimo,
    nome_usuario,
    status,
    data_emprestimo
FROM emprestimos
ORDER BY id_emprestimo;

-- Deve mostrar: EMPRESTADO, DEVOLVIDO, ATRASADO (tudo maiúsculo)

-- ============================================
-- 4. Confirmar tipos válidos
-- ============================================

-- Ver todos os valores únicos de status
SELECT DISTINCT status 
FROM emprestimos;

-- Deve retornar apenas:
-- EMPRESTADO
-- DEVOLVIDO
-- ATRASADO

-- ============================================
-- ALTERNATIVA RÁPIDA: Deletar todos empréstimos
-- (Se forem apenas dados de teste)
-- ============================================

-- DELETE FROM emprestimos;

-- Verificar
-- SELECT COUNT(*) FROM emprestimos;

-- ============================================
-- Commit das alterações
-- ============================================

-- COMMIT;

