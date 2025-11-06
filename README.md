# dopBase

[![CD - Deploy](https://github.com/daniloopinheiro/dopBase/actions/workflows/cd.yml/badge.svg)](https://github.com/daniloopinheiro/dopBase/actions/workflows/cd.yml)
[![CI - Build & Test](https://github.com/daniloopinheiro/dopBase/actions/workflows/ci.yml/badge.svg)](https://github.com/daniloopinheiro/dopBase/actions/workflows/ci.yml)
[![Dependencies Check & Update](https://github.com/daniloopinheiro/dopBase/actions/workflows/dependencies.yml/badge.svg)](https://github.com/daniloopinheiro/dopBase/actions/workflows/dependencies.yml)
[![Monitoring & Performance](https://github.com/daniloopinheiro/dopBase/actions/workflows/monitoring.yml/badge.svg)](https://github.com/daniloopinheiro/dopBase/actions/workflows/monitoring.yml)
[![PR Automation](https://github.com/daniloopinheiro/dopBase/actions/workflows/pr-automation.yml/badge.svg)](https://github.com/daniloopinheiro/dopBase/actions/workflows/pr-automation.yml)

**Repositório base/template** com CI/CD completo para qualquer tecnologia backend e frontend.  
Inclui workflows de integração contínua, deploy, gerenciamento de dependências e monitoramento prontos para uso.

## 📑 Índice

1. [Visão Geral](#visão-geral)
2. [CI/CD e Workflows](#cicd-e-workflows)
3. [Instalação](#instalação)
4. [Como Usar](#como-usar)
5. [Configuração](#configuração)
6. [Contribuições](#contribuições)
7. [Artigos & Conteúdos](#artigos--conteúdos)
8. [Licença](#licença)
9. [Contato](#contato)

---

## Visão Geral

O **dopBase** é um repositório base/template completo com pipelines de CI/CD prontos para uso, suportando múltiplas tecnologias e frameworks. Este projeto fornece uma base sólida para iniciar qualquer aplicação com as melhores práticas de DevOps.

### 🎯 Como Usar Este Template

Este repositório serve como base para novos projetos. Para usá-lo:

1. **Clone ou use como template**:
   ```bash
   # Opção 1: Clone direto
   git clone https://github.com/daniloopinheiro/dopBase.git meu-novo-projeto
   
   # Opção 2: Use o botão "Use this template" no GitHub
   ```

2. **Adicione seu código**: Os workflows detectam automaticamente a tecnologia e configuram tudo
3. **Configure secrets** (opcional): Para deploy automático
4. **Comece a desenvolver**: Os workflows funcionam imediatamente!

> **Nota**: Arquivos de configuração específicos (como `k6-test.js`, `.pa11yci.json`, `sonar-project.properties`) não estão incluídos. Você pode criá-los conforme necessário para seu projeto específico.

### ✨ Recursos Principais

- 🔄 **CI/CD Automático**: Workflows prontos para build, teste e deploy
- 🌐 **Multi-tecnologia**: Suporta Node.js, Python, .NET, Java, Go e mais
- 🔒 **Segurança**: Scans automáticos de vulnerabilidades
- 📦 **Gerenciamento de Dependências**: Atualização automática e verificação de segurança
- 🤖 **Automação de PRs**: Labeling, validações e estatísticas automáticas
- 📊 **Monitoramento**: Performance, acessibilidade e qualidade de código
- 🚀 **Deploy Automático**: Integração com Vercel, Netlify, Heroku, AWS, Azure e mais

---

## CI/CD e Workflows

Este projeto inclui workflows completos de GitHub Actions para automação de todo o ciclo de desenvolvimento.

### 🚀 Workflows Disponíveis

#### 1. **CI - Build & Test** (`ci.yml`)
- ✅ Detecção automática de tecnologias
- 🏗️ Build automático para backend e frontend
- 🧪 Execução de testes
- 📊 Análise de código (Linting)
- 🔒 Scan de segurança com Trivy
- 📈 Análise de qualidade com SonarCloud

#### 2. **CD - Deploy** (`cd.yml`)
- 🚀 Deploy automático para múltiplas plataformas
- 🐳 Build e push de imagens Docker
- 📝 Criação automática de releases
- 🏷️ Geração de changelog

#### 3. **Dependencies Check** (`dependencies.yml`)
- 🔍 Verificação de vulnerabilidades
- 📦 Detecção de pacotes desatualizados
- 🔄 Atualização automática de dependências
- ⚖️ Verificação de licenças

#### 4. **PR Automation** (`pr-automation.yml`)
- 🏷️ Labeling automático
- 📏 Validação de título semântico
- 📊 Estatísticas de mudanças
- 🤖 Auto-merge de PRs do Dependabot

#### 5. **Monitoring** (`monitoring.yml`)
- 🔍 Lighthouse audit
- ⚡ Testes de performance com k6
- 🔒 Verificação de SSL
- 📊 Análise de cobertura de código

#### 6. **Auto Tag & Version** (`auto-tag.yml`) ⭐ NOVO
- 🏷️ Criação automática de tags quando há merge para `main`
- 📊 Versionamento semântico baseado em commits convencionais
- 🔄 Detecta automaticamente o tipo de versão (major, minor, patch)
- 🎯 Integrado com CD para releases automáticas

### 📚 Documentação dos Workflows

- 📖 [Guia Completo](.github/README.md) - Documentação detalhada de todos os workflows
- 🚀 [Quick Start](.github/QUICKSTART.md) - Comece em 5 minutos
- 🏷️ [Auto Versioning](.github/AUTO_VERSIONING.md) - Tags e releases automáticas ⭐ NOVO
- 📦 [Release Guide](.github/RELEASE_GUIDE.md) - Como criar releases
- 📛 [Badges](.github/BADGES.md) - Badges para seu README

### 🔧 Tecnologias Suportadas

| Categoria | Tecnologias |
|-----------|-------------|
| **Frontend** | Node.js, React, Vue, Angular, Svelte, Next.js, Nuxt.js |
| **Backend** | Node.js, Python, .NET, Java, Go |
| **Gerenciadores** | npm, yarn, pnpm, pip, Maven, Gradle, NuGet, Go modules |
| **Containers** | Docker, Docker Compose |
| **Deploy** | Vercel, Netlify, GitHub Pages, Heroku, AWS, Azure |

### ⚡ Início Rápido

1. **Clone o repositório**
2. **Os workflows já estão configurados** em `.github/workflows/`
3. **Faça seu primeiro push**:
   ```bash
   git add .
   git commit -m "feat: initial commit"
   git push origin main
   ```
4. **Veja os workflows em ação** na aba Actions do GitHub

### 🎯 Fluxo Completo de Release Automática

Este repositório possui um fluxo completo de automação:

```
1. Desenvolver → 2. PR → 3. Merge para main → 4. Auto Tag → 5. Auto Release
```

**Exemplo prático:**
```bash
# 1. Criar branch e desenvolver
git checkout -b feature/nova-funcionalidade
git commit -m "feat: adiciona funcionalidade incrível"

# 2. Criar PR e fazer merge para main

# 3. Automação acontece:
#    ✅ Auto Tag detecta "feat:" e cria tag v1.1.0
#    ✅ CD detecta tag e cria release automaticamente
#    ✅ Changelog gerado com base nos commits
```

Para mais detalhes, consulte o [Auto Versioning Guide](.github/AUTO_VERSIONING.md).

---

## Instalação

Forneça instruções claras sobre como instalar o seu software.  
Inclua pré-requisitos, como dependências de software ou bibliotecas necessárias.  

Exemplo:

```bash
$ git clone https://github.com/seu-usuario/nome-do-projeto.git
$ cd nome-do-projeto
````

---

## Como Usar

Explique como usar o seu software em detalhes.
Forneça exemplos de código, comandos de linha ou capturas de tela para demonstrar o uso típico do software.

Exemplo:

```bash
# Exemplo de execução
dotnet run
```

Isso iniciará o servidor de desenvolvimento.

---

## Configuração

Se o seu software requer configuração adicional além da instalação padrão, explique aqui como configurá-lo.
Isso pode incluir variáveis de ambiente, arquivos de configuração ou qualquer ajuste necessário para personalizar o comportamento do software.

---

## Contribuições

Explique se você está aberto para contribuições e como outros desenvolvedores podem ajudar.
Inclua orientações para quem deseja reportar bugs, enviar solicitações de novos recursos ou fazer alterações no código.

---

## Artigos & Conteúdos

* 💼 [LinkedIn](https://www.linkedin.com/in/daniloopinheiro)
* ✍️ [Medium](https://medium.com/@daniloopinheiro)
* 💻 [Dev.to](https://dev.to/daniloopinheiro)

---

## Licença

MIT License © 2025 [LICENSE.md](https://github.com/daniloopinheiro/dopBase/blob/main/LICENSE.md) — por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

---

## Contato

### 💬 Suporte Técnico
Para questões técnicas, problemas ou sugestões:
- **Issues**: [GitHub Issues](https://github.com/daniloopinheiro/dopNetHL7/issues)
- **Discussions**: [GitHub Discussions](https://github.com/daniloopinheiro/dopNetHL7/discussions)

### 👨‍💻 Autor
**Danilo O. Pinheiro**  
Especialista em .NET, Clean Architecture e Interoperabilidade em Saúde

- **Email Pessoal**: [daniloopro@gmail.com](mailto:daniloopro@gmail.com)
- **Email Empresarial**: [devsfree@devsfree.com.br](mailto:devsfree@devsfree.com.br)
- **Consultoria**: [contato@dopme.io](mailto:contato@dopme.io)
- **LinkedIn**: [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)

### 🏢 Empresas
- **[DevsFree](https://devsfree.com.br)**: Desenvolvimento de Software
- **[dopme.io](https://dopme.io)**: Consultoria e Soluções Tecnológicas

---

<div align="center">

**⭐ Se este projeto foi útil, deixe uma estrela no GitHub! ⭐**

<p>
Feito com ❤️ por <strong>Danilo O. Pinheiro</strong><br/>  
<a href="https://devsfree.com.br" target="_blank">DevsFree</a> • <a href="https://dopme.io" target="_blank">dopme.io</a>  
</p>

</div>
