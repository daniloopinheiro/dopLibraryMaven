-- ============================================
-- Script de Inicialização - Supabase
-- Execute este script no SQL Editor do Supabase
-- ANTES de iniciar a aplicação
-- ============================================

-- 1. Criar o tipo ENUM para status de empréstimo
CREATE TYPE IF NOT EXISTS status_emprestimo AS ENUM ('EMPRESTADO', 'DEVOLVIDO', 'ATRASADO');

-- 2. Verificar se foi criado (opcional)
SELECT typname, enumlabel 
FROM pg_type 
JOIN pg_enum ON pg_enum.enumtypid = pg_type.oid 
WHERE typname = 'status_emprestimo';

-- ============================================
-- Pronto! Agora você pode iniciar a aplicação
-- Execute: ./run-supabase.bat
-- ============================================

