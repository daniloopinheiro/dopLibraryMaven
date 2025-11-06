# 🚀 Deploy no Render - Biblioteca API

Guia completo para fazer deploy da Biblioteca API no Render.com

---

## 🔥 Solução para Erro 502 (Maven Central)

### O Problema

```
[ERROR] Failed to execute goal on project biblioteca-api: Could not resolve dependencies...
status code: 502, reason phrase: Bad Gateway (502)
```

### Causa

O erro 502 acontece quando o Maven Central está temporariamente indisponível ou com problemas de rede durante o build no Render.

### Soluções Implementadas

#### ✅ 1. Usar Dockerfile.render (RECOMENDADO)

O arquivo `Dockerfile.render` foi otimizado especificamente para o Render com:

- **Retry automático** em downloads de dependências
- **Timeouts aumentados** para operações de rede
- **Maven Wrapper** ao invés do Maven do sistema
- **Resolução de dependências em etapas**
- **Imagem base não-alpine** para build (melhor compatibilidade)

**No Render Dashboard:**
1. Vá em **Settings**
2. Em **Dockerfile Path**, mude de `Dockerfile` para `Dockerfile.render`
3. Clique em **Save Changes**
4. Faça um **Manual Deploy**

---

#### ✅ 2. Usar render.yaml (Blueprint)

O arquivo `render.yaml` configura automaticamente seu serviço:

**Setup:**
1. Commit o arquivo `render.yaml` no repositório
2. No Render Dashboard, clique em **New** > **Blueprint**
3. Conecte seu repositório
4. O Render detectará automaticamente o `render.yaml`
5. Clique em **Apply**

---

#### ✅ 3. Aumentar Timeout do Build (Render Dashboard)

1. Vá em **Settings**
2. Em **Advanced**, aumente o **Build Timeout** para **20 minutos**
3. Save Changes

---

#### ✅ 4. Retry Manual

Se o build falhar:
1. Aguarde **5-10 minutos**
2. Clique em **Manual Deploy** novamente
3. O problema geralmente é temporário

---

## 📋 Deploy Passo a Passo

### Método 1: Via Dashboard (Mais Simples)

#### 1. Criar Conta no Render
- Acesse: https://render.com
- Faça login com GitHub

#### 2. Criar PostgreSQL Database (Opcional)

Se quiser usar banco de dados:

1. No Dashboard, clique em **New** > **PostgreSQL**
2. Configure:
   - **Name**: `biblioteca-db`
   - **Database**: `biblioteca`
   - **Region**: Oregon (ou mais próximo)
   - **Plan**: Free
3. Clique em **Create Database**
4. **Copie a Internal Database URL** (vamos usar depois)

#### 3. Criar Web Service

1. No Dashboard, clique em **New** > **Web Service**
2. Conecte seu repositório GitHub
3. Configure:

**Basic:**
- **Name**: `biblioteca-api`
- **Region**: Oregon
- **Branch**: `main`
- **Runtime**: Docker
- **Dockerfile Path**: `Dockerfile.render` ⚠️ IMPORTANTE

**Plan:**
- Escolha **Free** para teste

**Environment Variables:**

Se estiver usando PostgreSQL no Render:
```
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=[cole a Internal Database URL]
SPRING_DATASOURCE_USERNAME=biblioteca_user
SPRING_DATASOURCE_PASSWORD=[gerado pelo Render]
SPRING_JPA_HIBERNATE_DDL_AUTO=update
```

Se estiver usando H2 (sem banco externo):
```
SPRING_PROFILES_ACTIVE=dev
```

Se estiver usando Supabase:
```
SPRING_PROFILES_ACTIVE=supabase
SPRING_DATASOURCE_URL=jdbc:postgresql://seu-projeto.supabase.co:5432/postgres
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=sua-senha-supabase
```

**Advanced Settings:**
- **Health Check Path**: `/api/autores`
- **Auto-Deploy**: Yes

4. Clique em **Create Web Service**

#### 4. Aguardar Build

- O build levará **5-15 minutos** na primeira vez
- Acompanhe os logs em tempo real
- Se falhar com erro 502, aguarde 5 minutos e tente novamente

#### 5. Testar a API

Após o deploy bem-sucedido:
```bash
# Sua URL será algo como:
https://biblioteca-api-xxxx.onrender.com

# Testar
curl https://biblioteca-api-xxxx.onrender.com/api/autores
```

---

### Método 2: Via render.yaml (Automático)

#### 1. Commit o render.yaml

```bash
git add render.yaml Dockerfile.render
git commit -m "feat: Adicionar configuração Render"
git push origin main
```

#### 2. Criar Blueprint no Render

1. Dashboard > **New** > **Blueprint**
2. Conecte o repositório
3. Render detecta o `render.yaml` automaticamente
4. Revise as configurações
5. Clique em **Apply**

#### 3. Pronto!

O Render criará automaticamente:
- PostgreSQL Database
- Web Service (API)
- Variáveis de ambiente conectadas

---

## 🔧 Variáveis de Ambiente

### Obrigatórias

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `SPRING_PROFILES_ACTIVE` | `dev` ou `prod` | Perfil do Spring |

### Com PostgreSQL (Render)

| Variável | Fonte | Descrição |
|----------|-------|-----------|
| `SPRING_DATASOURCE_URL` | Internal DB URL | URL do banco |
| `SPRING_DATASOURCE_USERNAME` | Database User | Usuário do banco |
| `SPRING_DATASOURCE_PASSWORD` | Database Password | Senha do banco |
| `SPRING_JPA_HIBERNATE_DDL_AUTO` | `update` | Estratégia JPA |

### Opcionais

| Variável | Valor Padrão | Descrição |
|----------|--------------|-----------|
| `JAVA_OPTS` | (configurado) | Opções JVM |
| `SPRING_JPA_SHOW_SQL` | `false` | Mostrar SQL |
| `SERVER_PORT` | `8080` | Porta (não mude) |

---

## 🐛 Troubleshooting

### Erro: "Container failed to start"

**Causa**: Aplicação não iniciou na porta esperada

**Solução**:
1. Verifique se a variável `PORT` está sendo usada
2. No `Dockerfile.render`, a porta é configurada automaticamente
3. Não force porta 8080 hardcoded

```bash
# No Dockerfile.render, a linha CMD já trata disso:
CMD sh -c "java $JAVA_OPTS -Dserver.port=${PORT:-8080} -jar app.jar"
```

---

### Erro: "Maven 502 Bad Gateway"

**Solução**:

1. **Use Dockerfile.render**:
   ```
   Settings > Dockerfile Path > Dockerfile.render
   ```

2. **Aguarde e retry**:
   - Espere 5-10 minutos
   - Clique em **Manual Deploy**

3. **Aumente timeout**:
   - Settings > Advanced > Build Timeout > 20 minutes

---

### Erro: "Database connection failed"

**Causa**: Variáveis de ambiente incorretas

**Solução**:

1. Verifique se usou a **Internal Database URL** (não External)
2. Formato correto:
   ```
   postgresql://usuario:senha@host:5432/database
   ```

3. Para usar no Spring, converta para JDBC:
   ```
   jdbc:postgresql://host:5432/database
   ```

4. No Render Dashboard, Database > Info > copie:
   - **Internal Database URL** (preferido)
   - **Username**
   - **Password**

---

### Erro: "Health check failed"

**Causa**: Endpoint `/api/autores` não responde

**Solução**:

1. Verifique os logs:
   ```
   Render Dashboard > Logs
   ```

2. Veja se a aplicação iniciou:
   ```
   Procure por: "Started BibliotecaApplication"
   ```

3. Teste manualmente:
   ```bash
   curl https://sua-url.onrender.com/api/autores
   ```

4. Se necessário, mude o health check:
   ```
   Settings > Health Check Path > /actuator/health
   ```
   
   E adicione ao `pom.xml`:
   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-actuator</artifactId>
   </dependency>
   ```

---

### Build muito lento

**Causa**: Render Free tier é limitado

**Soluções**:

1. **Otimize o build**:
   - Já implementado no `Dockerfile.render`
   - Multi-stage build reduz tempo

2. **Use cache**:
   - Não mude o `pom.xml` frequentemente
   - Render mantém cache de camadas Docker

3. **Upgrade de plano**:
   - Starter plan: build mais rápido
   - Mais CPU e memória

---

### App dorme após 15 minutos (Free tier)

**Causa**: Render Free tier suspende apps inativas

**Soluções**:

1. **Aceite a limitação**:
   - Primeira requisição levará 30-60s
   - Normal no Free tier

2. **Upgrade para Starter**:
   - Sem suspensão automática
   - $7/mês

3. **Use ping service** (workaround):
   - Configure um cron job para fazer ping
   - Exemplo: UptimeRobot, cron-job.org

---

## 📊 Monitoramento

### Logs

```bash
# No Render Dashboard
Logs > Ver em tempo real
```

### Métricas

```bash
# No Render Dashboard
Metrics > Ver CPU, Memory, Requests
```

### Alertas

Configure em **Settings** > **Notifications**

---

## 💰 Custos

### Free Tier (Grátis)
- ✅ 750 horas/mês
- ✅ PostgreSQL 256MB
- ⚠️ App suspende após 15 min inativo
- ⚠️ Build pode ser lento

### Starter ($7/mês)
- ✅ Sem suspensão
- ✅ Build mais rápido
- ✅ PostgreSQL 1GB
- ✅ Melhor performance

---

## 🚀 Atualizações

### Auto-Deploy (Recomendado)

Habilitado por padrão. Cada push no GitHub dispara deploy automático.

### Manual Deploy

```bash
# No Render Dashboard
Manual Deploy > Deploy Latest Commit
```

### Rollback

```bash
# No Render Dashboard
Events > Escolha deploy anterior > Rollback
```

---

## 🔒 Segurança

### Variáveis Secretas

Use **Environment Variables** no Render (não commite no código):

```bash
# Boas práticas
✅ Senhas: via Render Environment Variables
✅ API Keys: via Render Environment Variables
❌ Nunca commite secrets no Git
```

### Database

- Use **Internal Database URL** (mais seguro)
- Render gerencia firewall automaticamente
- Conexões criptografadas por padrão

---

## 📚 Recursos

### Links Úteis

- [Render Docs](https://render.com/docs)
- [Docker on Render](https://render.com/docs/docker)
- [Environment Variables](https://render.com/docs/environment-variables)
- [PostgreSQL](https://render.com/docs/databases)

### Suporte

- **Render Community**: https://community.render.com
- **Status Page**: https://status.render.com

---

## ✅ Checklist de Deploy

Antes de fazer deploy:

- [ ] `Dockerfile.render` está no repositório
- [ ] Código está commitado e pushed
- [ ] Variáveis de ambiente configuradas
- [ ] Database criado (se usando PostgreSQL)
- [ ] Dockerfile Path = `Dockerfile.render`
- [ ] Health Check Path = `/api/autores`
- [ ] Branch correta selecionada

---

## 🎯 Quick Commands

```bash
# Commit mudanças
git add .
git commit -m "feat: Deploy no Render"
git push origin main

# Testar localmente antes
docker build -f Dockerfile.render -t biblioteca-api:render .
docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=dev biblioteca-api:render

# Testar API após deploy
curl https://sua-url.onrender.com/api/autores
curl https://sua-url.onrender.com/api/livros
```

---

## 🆘 Ajuda

Se continuar com problemas:

1. **Verifique os logs** no Render Dashboard
2. **Teste localmente** com `Dockerfile.render`
3. **Consulte** [DOCKER.md](DOCKER.md) para mais detalhes
4. **Abra issue** no GitHub

---

**Desenvolvido por [Danilo O. Pinheiro](https://www.linkedin.com/in/daniloopinheiro/)**

Deploy com sucesso! 🚀

