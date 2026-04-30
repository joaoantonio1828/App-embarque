-- ============================================================
-- CargaFlow - Setup do Banco de Dados (Supabase)
-- Execute este SQL no SQL Editor do seu projeto Supabase
-- ============================================================

-- 1. TABELA DE USUÁRIOS (perfis)
CREATE TABLE IF NOT EXISTS public.usuarios (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nome TEXT,
  email TEXT,
  tipo TEXT DEFAULT 'operador' CHECK (tipo IN ('admin', 'operador', 'visualizador')),
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABELA DE EMBARQUES
CREATE TABLE IF NOT EXISTS public.embarques (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  placa TEXT NOT NULL,
  motorista TEXT NOT NULL,
  origem TEXT NOT NULL,
  destino TEXT NOT NULL,
  valor NUMERIC(12,2) DEFAULT 0,
  observacao TEXT,
  status TEXT DEFAULT 'Aguardando carregamento',
  criado_por TEXT,
  editado_por TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABELA DE HISTÓRICO
CREATE TABLE IF NOT EXISTS public.historico (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  embarque_id UUID REFERENCES public.embarques(id) ON DELETE CASCADE,
  descricao TEXT,
  usuario TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- 4. HABILITAR RLS (Row Level Security)
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.embarques ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.historico ENABLE ROW LEVEL SECURITY;

-- 5. POLÍTICAS - USUÁRIOS
-- Todos os autenticados podem ver usuários
CREATE POLICY "usuarios_select" ON public.usuarios
  FOR SELECT TO authenticated USING (true);

-- Usuário pode inserir/atualizar seu próprio perfil
CREATE POLICY "usuarios_insert_own" ON public.usuarios
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

CREATE POLICY "usuarios_update_own" ON public.usuarios
  FOR UPDATE TO authenticated USING (true);

-- 6. POLÍTICAS - EMBARQUES
-- Todos os autenticados podem ver
CREATE POLICY "embarques_select" ON public.embarques
  FOR SELECT TO authenticated USING (true);

-- Admin e operador podem inserir
CREATE POLICY "embarques_insert" ON public.embarques
  FOR INSERT TO authenticated WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.usuarios
      WHERE id = auth.uid() AND tipo IN ('admin', 'operador')
    )
  );

-- Admin e operador podem atualizar
CREATE POLICY "embarques_update" ON public.embarques
  FOR UPDATE TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.usuarios
      WHERE id = auth.uid() AND tipo IN ('admin', 'operador')
    )
  );

-- Somente admin pode deletar
CREATE POLICY "embarques_delete" ON public.embarques
  FOR DELETE TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.usuarios
      WHERE id = auth.uid() AND tipo = 'admin'
    )
  );

-- 7. POLÍTICAS - HISTÓRICO
CREATE POLICY "historico_select" ON public.historico
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "historico_insert" ON public.historico
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "historico_delete" ON public.historico
  FOR DELETE TO authenticated USING (
    EXISTS (SELECT 1 FROM public.usuarios WHERE id = auth.uid() AND tipo = 'admin')
  );

-- 8. REALTIME (habilitar para a tabela embarques)
ALTER PUBLICATION supabase_realtime ADD TABLE public.embarques;

-- 9. ÍNDICES para performance
CREATE INDEX IF NOT EXISTS idx_embarques_criado_em ON public.embarques(criado_em DESC);
CREATE INDEX IF NOT EXISTS idx_embarques_status ON public.embarques(status);
CREATE INDEX IF NOT EXISTS idx_embarques_placa ON public.embarques(placa);
CREATE INDEX IF NOT EXISTS idx_historico_embarque ON public.historico(embarque_id);

-- ============================================================
-- PRONTO! Banco configurado.
-- Agora crie o primeiro usuário admin via Authentication
-- no painel do Supabase, depois execute:
-- UPDATE public.usuarios SET tipo = 'admin' WHERE email = 'seu@email.com';
-- ============================================================
