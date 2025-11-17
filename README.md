# Sistema de Gerenciamento de Consentimentos LGPD

Sistema desenvolvido em Rails 8.1 para gerenciamento de consentimentos de usuários conforme princípios da LGPD (Lei Geral de Proteção de Dados).

## Como Rodar o Projeto

### Pré-requisitos
- Ruby 3.4.0
- PostgreSQL 12+
- Rails 8.1.1

### Passos para Setup

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/YanFellippe/sistema-de-consentimento-lgpd.git
   cd lgpd_consent
   ```

2. **Instale as dependências:**
   ```bash
   bundle install
   ```

3. **Configure o Banco de Dados:**
   
   Certifique-se de que o PostgreSQL está rodando. Edite o arquivo `config/database.yml` se necessário:
   ```yaml
   development:
     adapter: postgresql
     database: lgpd_consent_system_development
     username: postgres
     password: admin123
     host: 127.0.0.1
   ```

4. **Crie e configure o banco de dados:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

   O comando `db:create`: 
   - Cria o banco de dados configurado no arquivo `config/database.yml`

   O comando `db:migrate`: 
   - Executa todas as migrations pendentes e altera o banco de dados conforme definido nos arquivos em `db/migrate/`
   
   O comando `db:seed`:
   - Roda o arquivo `db/seeds.rb` e insere dados iniciais no banco
   - Gera um usuário de teste (teste@exemplo.com)
   - Três finalidades de consentimento:
     - Receber comunicações de marketing
     - Uso de dados para analytics
     - Inscrição em newsletter

5. **Inicie o servidor:**
   ```bash
   rails s
   ```

6. **Acesse o sistema:**
   
   Abra seu navegador em: **http://[::1]:3000/**
   
   Você verá a lista de usuários cadastrados. A partir daí você pode:
   - Criar novos usuários
   - Gerenciar consentimentos de cada usuário
   - Visualizar o histórico completo de consentimentos

---

## Modelagem do Problema

### Estrutura de Dados

O sistema foi modelado com três entidades principais:

#### 1. **User (Usuário)**
Armazena informações básicas do usuário:
- `name`: Nome completo
- `email`: E-mail único (com validação)

#### 2. **Purpose (Finalidade)**
Representa as diferentes finalidades para as quais o consentimento pode ser solicitado:
- `name`: Nome da finalidade (ex: "Receber comunicações de marketing")

Esta abordagem torna o sistema escalável - novas finalidades podem ser adicionadas sem modificar código, apenas inserindo novos registros no banco.

#### 3. **Consent (Consentimento)**
Tabela central que registra o relacionamento entre usuários e finalidades:
- `user_id`: Referência ao usuário
- `purpose_id`: Referência à finalidade
- `status`: Estado do consentimento (enum: granted=0, revoked=1)
- `granted_at`: Data/hora da concessão
- `revoked_at`: Data/hora da revogação
- `created_at` / `updated_at`: Timestamps automáticos

### Decisões de Design

**1. Tabela de Consentimentos Separada**
Ao invés de adicionar colunas booleanas no modelo User (ex: `marketing_consent`, `analytics_consent`), optei por uma tabela separada. Isso permite:
- Rastreabilidade completa (quando foi concedido/revogado)
- Flexibilidade para adicionar novas finalidades
- Conformidade com LGPD (histórico de mudanças)

**2. Enum para Status**
O campo `status` usa enum do Rails (integer no banco):
- Mais performático que strings
- Métodos auxiliares automáticos (`consent.granted?`, `consent.revoked?`)
- Type-safe (previne valores inválidos)

**3. Estado "Não Definido"**
Quando não existe registro de Consent para um par usuário/finalidade, o sistema interpreta como "Não Definido". O registro só é criado quando o usuário toma uma ação pela primeira vez.

**4. Validações**
- Unicidade de email no User
- Unicidade de combinação user_id + purpose_id no Consent (previne duplicatas)
- Validações de presença em campos obrigatórios

### Fluxo de Dados

```
Usuário acessa /users → Lista todos os usuários
         ↓
Clica em "Gerenciar Consentimentos" → /users/:id
         ↓
Sistema carrega: @user, @purposes, @consents_hash
         ↓
Para cada Purpose, verifica se existe Consent
         ↓
Exibe botões "Conceder" ou "Revogar" conforme status
         ↓
Ao clicar, POST para /consents/toggle
         ↓
Controller atualiza/cria Consent com timestamps
         ↓
Redirect de volta para /users/:id com mensagem
```

---

## Funcionalidades Implementadas

- Cadastro de usuários (CRUD completo)
- Listagem de usuários
- Gerenciamento de consentimentos por usuário
- Concessão e revogação de consentimentos
- Registro de timestamps (granted_at, revoked_at)
- Histórico de consentimentos por usuário
- Interface responsiva e intuitiva
- Validações de dados
- Prevenção de duplicatas (unicidade user + purpose)

---

## Melhorias Futuras

Se houvesse mais tempo, as seguintes funcionalidades seriam implementadas:

### 1. **Testes Automatizados**
- **RSpec**: Testes de unidade para models
  - Validações (email único, presença de campos)
  - Associações (has_many, belongs_to)
  - Métodos customizados
- **Testes de integração**: Simular fluxo completo do usuário
  - Criar usuário → Conceder consentimento → Revogar → Verificar histórico
- **Factory Bot**: Para criar fixtures de teste
- **Shoulda Matchers**: Para simplificar testes de validação

### 2. **Autenticação e Autorização**
- **Devise**: Sistema de login/logout
- **Cancancan**: Controle de permissões
  - Usuários só podem gerenciar seus próprios consentimentos
  - Administradores podem visualizar todos os usuários
- **Sessões seguras**: CSRF protection, secure cookies

### 3. **Auditoria Completa (PaperTrail)**
- Tabela `versions` para rastrear TODAS as mudanças
- Atualmente: apenas última data de concessão/revogação
- Ideal: histórico completo com:
  - Quem fez a mudança
  - Quando foi feita
  - Qual era o valor anterior
  - Qual é o novo valor
  - IP de origem

### 4. **API RESTful**
```ruby
# Endpoints propostos:
GET    /api/v1/users/:user_id/consents
POST   /api/v1/users/:user_id/consents
PATCH  /api/v1/consents/:id
DELETE /api/v1/consents/:id
GET    /api/v1/consents/:id/history
```
- Autenticação via JWT
- Versionamento de API
- Documentação com Swagger/OpenAPI
- Rate limiting

### 5. **Notificações**
- Email ao usuário quando consentimento é alterado
- Background jobs (Sidekiq) para envio assíncrono
- Templates de email personalizados
- Logs de envio

### 6. **Dashboard Administrativo**
- Estatísticas de consentimentos
- Gráficos (Chart.js ou similar):
  - Taxa de concessão por finalidade
  - Evolução temporal
  - Usuários mais ativos
- Exportação de relatórios (CSV, PDF)

### 7. **Internacionalização (i18n)**
- Suporte a múltiplos idiomas
- Português, Inglês, Espanhol
- Datas e horários localizados

### 8. **Performance**
- Cache de queries frequentes (Redis)
- Eager loading para evitar N+1 queries
- Paginação (Kaminari ou Pagy)
- Índices no banco de dados

### 9. **Segurança**
- Brakeman: Análise estática de vulnerabilidades
- Bundler Audit: Verificar gems com vulnerabilidades conhecidas
- Rate limiting por IP
- Logs de acesso e tentativas suspeitas

### 10. **DevOps**
- Docker/Docker Compose para ambiente de desenvolvimento
- CI/CD (GitHub Actions)
- Deploy automatizado (Heroku, AWS, ou Railway)
- Monitoramento (New Relic, Datadog)

---

## Tecnologias Utilizadas

- **Ruby** 3.4.0
- **Rails** 8.1.1
- **PostgreSQL** (banco de dados)
- **HTML/CSS** (views com ERB)
- **Puma** (servidor web)