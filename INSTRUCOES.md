# 🚛 CargaFlow — Sistema de Controle de Embarques

Sistema completo com painel web + modo lançamento rápido para celular (PWA).

---

## 📁 Estrutura de Arquivos

```
cargaflow/
├── index.html          ← Sistema completo (único arquivo principal)
├── vercel.json         ← Configuração do Vercel
├── SETUP_SUPABASE.sql  ← Script SQL para o banco de dados
├── INSTRUCOES.md       ← Este arquivo
└── public/
    ├── manifest.json   ← PWA manifest
    ├── sw.js           ← Service Worker
    └── icons/          ← Ícones do app (você deve adicionar)
        ├── icon-192.png
        └── icon-512.png
```

---

## ✅ PASSO 1 — Criar conta no Supabase

1. Acesse **https://supabase.com** e clique em **Start your project**
2. Crie uma conta (pode usar Google ou GitHub)
3. Clique em **New Project**
4. Preencha:
   - **Name**: `cargaflow` (ou qualquer nome)
   - **Database Password**: crie uma senha forte e guarde
   - **Region**: escolha `South America (São Paulo)`
5. Clique em **Create new project** e aguarde ~1 minuto

---

## ✅ PASSO 2 — Configurar o banco de dados

1. No painel do Supabase, clique em **SQL Editor** (ícone de código na lateral)
2. Clique em **New query**
3. Abra o arquivo `SETUP_SUPABASE.sql` deste projeto
4. Copie TODO o conteúdo e cole no editor
5. Clique em **Run** (▶️)
6. Deve aparecer `Success. No rows returned`

---

## ✅ PASSO 3 — Pegar as credenciais do Supabase

1. No painel do Supabase, clique em **Settings** (engrenagem) → **API**
2. Copie os valores:
   - **Project URL** → algo como `https://xxxxxxxxxxxx.supabase.co`
   - **anon public** (em Project API keys)

---

## ✅ PASSO 4 — Inserir credenciais no código

1. Abra o arquivo `index.html` em um editor de texto
2. Encontre as linhas (perto do final, na parte do JavaScript):

```javascript
const SUPABASE_URL = 'COLOQUE_SUA_SUPABASE_URL_AQUI';
const SUPABASE_ANON_KEY = 'COLOQUE_SUA_ANON_KEY_AQUI';
```

3. Substitua pelos valores copiados:

```javascript
const SUPABASE_URL = 'https://xxxxxxxxxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5...';
```

---

## ✅ PASSO 5 — Criar o primeiro usuário (Admin)

1. No painel do Supabase, clique em **Authentication** → **Users**
2. Clique em **Invite user** ou **Add user**
3. Insira seu e-mail e uma senha
4. Confirme o e-mail (verifique sua caixa de entrada)
5. Agora vá em **SQL Editor** e execute:

```sql
UPDATE public.usuarios 
SET tipo = 'admin' 
WHERE email = 'SEU_EMAIL_AQUI';
```

---

## ✅ PASSO 6 — Fazer deploy no Vercel

### Opção A — Via GitHub (recomendado):
1. Crie conta no **https://github.com**
2. Crie um novo repositório (ex: `cargaflow`)
3. Faça upload de todos os arquivos
4. Acesse **https://vercel.com** e crie uma conta
5. Clique em **New Project** → **Import Git Repository**
6. Selecione seu repositório
7. Clique em **Deploy**
8. Em segundos seu site estará no ar!

### Opção B — Via Vercel CLI:
```bash
npm install -g vercel
cd cargaflow
vercel
```

---

## ✅ PASSO 7 — Adicionar ao iPhone (PWA)

1. Acesse a URL do seu sistema no **Safari** (obrigatório no iPhone)
2. Toque no ícone de **Compartilhar** (quadrado com seta para cima)
3. Role para baixo e toque em **"Adicionar à Tela de Início"**
4. Confirme tocando em **Adicionar**
5. O app abrirá direto no **Modo Lançamento Rápido** (/rapido)

> **Nota**: Os ícones do app (icon-192.png e icon-512.png) precisam ser adicionados na pasta `public/icons/`. Você pode criar ícones em https://www.canva.com ou https://favicon.io

---

## 🗂️ Rotas do Sistema

| Rota | Descrição |
|------|-----------|
| `/#login` | Tela de login |
| `/#dashboard` | Painel com gráficos e resumo |
| `/#embarques` | Lista completa com filtros |
| `/#rapido` | Modo lançamento rápido (celular) |
| `/#relatorios` | Gráficos e análises |
| `/#configuracoes` | Tema, usuários e backup |

---

## 👥 Perfis de Usuário

| Perfil | Criar | Editar | Excluir | Configurações |
|--------|-------|--------|---------|---------------|
| **Admin** | ✅ | ✅ | ✅ | ✅ |
| **Operador** | ✅ | ✅ | ❌ | ❌ |
| **Visualizador** | ❌ | ❌ | ❌ | ❌ |

---

## 🔧 Alterar nome do sistema

O nome "CargaFlow" aparece em:
1. `index.html` — busque por `CargaFlow` e substitua
2. `public/manifest.json` — campo `name` e `short_name`

---

## ❓ Suporte

Se aparecer erro de RLS no Supabase:
1. Vá em **Authentication** → **Policies**
2. Verifique se as políticas foram criadas nas tabelas `embarques`, `usuarios` e `historico`
3. Re-execute o `SETUP_SUPABASE.sql` se necessário
