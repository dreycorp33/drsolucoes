# SaaS ERP Comercial + PDV — Arquitetura de Referência

Este documento transforma os requisitos do projeto em um blueprint executável para implementação incremental em produção.

## 1) Visão Geral

Plataforma SaaS multiempresa com isolamento de dados por tenant, cobrindo:

- Gestão comercial (clientes, produtos, vendas)
- PDV touch-friendly (venda rápida)
- Estoque e financeiro
- Relatórios gerenciais
- Painel administrativo
- Website institucional integrado

## 2) Stack Recomendada

### Frontend (Web App + PDV + Admin)

- React + TypeScript + Vite
- Tailwind CSS + Headless UI
- React Router
- React Query (cache e sincronização)
- PWA (service worker + manifest)

### Backend (API SaaS)

- Node.js + NestJS (módulos e DI)
- Prisma ORM
- PostgreSQL
- Redis (cache, fila, rate limit)
- BullMQ (jobs assíncronos)

### Infraestrutura

- Docker + Docker Compose (dev)
- Kubernetes opcional (produção em escala)
- NGINX/Traefik (reverse proxy)
- S3 compatível para arquivos
- CI/CD com GitHub Actions

## 3) Modelo Multi-Tenant

Abordagem inicial (recomendada): **single database + tenant_id em todas as tabelas de domínio**.

- Isolamento lógico por `tenant_id`
- Política de acesso por RBAC e escopo de tenant
- Índices compostos (`tenant_id`, `campo`) em entidades com alto volume
- Auditoria de ações críticas por usuário e tenant

Evolução futura:

1. Schema por tenant (quando necessário)
2. Banco por tenant enterprise

## 4) Módulos de Negócio

- Auth (login, refresh token, reset senha, confirmação e-mail, 2FA opcional)
- Tenant (empresa, plano, configurações e tema)
- Usuários e RBAC
- Produtos/Categorias/Fornecedores
- Clientes
- Estoque (movimentações, inventário, alertas)
- PDV e Vendas
- Financeiro (contas a pagar/receber e fluxo de caixa)
- Relatórios (PDF/CSV/XLSX)
- Billing (assinaturas e status de plano)
- Website institucional (CMS simples)

## 5) Segurança

- Senhas com bcrypt
- JWT access token + refresh token rotativo
- Rate limit por IP e por usuário
- Helmet, CORS restritivo e validação de payload
- Proteção contra XSS, SQL Injection e CSRF (quando usar cookies)
- Logs de auditoria (login, permissões, cancelamentos, fechamento de caixa)

## 6) Arquitetura por Camadas

### API (REST)

- Controllers: validação e contrato HTTP
- Services: regras de negócio
- Repositories/ORM: persistência
- Domain: entidades e políticas

### Frontend

- `pages/` por domínio funcional
- `components/` reutilizáveis
- `features/` para regras isoladas por contexto
- `hooks/` para estado e integrações

## 7) Fluxo de Venda no PDV

1. Operador abre caixa
2. Seleciona cliente (opcional)
3. Busca produto por nome/SKU/código de barras
4. Adiciona itens e quantidades
5. Aplica desconto
6. Seleciona pagamento (dinheiro, PIX, crédito, débito, múltiplo)
7. Finaliza venda
8. Sistema:
   - grava venda
   - grava pagamentos
   - baixa estoque
   - atualiza financeiro
   - emite comprovante

## 8) Entregas por Fase

### Fase 1 — Fundação

- Autenticação + multi-tenant + RBAC
- Cadastros: clientes e produtos
- Venda simples com baixa de estoque
- Dashboard base

### Fase 2 — PDV completo

- Tela otimizada touch
- Múltiplas formas de pagamento
- Abertura/fechamento de caixa
- Comprovantes e impressão

### Fase 3 — Financeiro e Relatórios

- Contas a pagar/receber
- Fluxo de caixa
- Relatórios por período/produto/cliente
- Exportações PDF/CSV/XLSX

### Fase 4 — SaaS e Escala

- Billing
- Auditoria avançada
- Backup/restauração
- Observabilidade e tuning de performance

## 9) Estrutura de Monorepo Sugerida

```txt
apps/
  web/               # React (dashboard + PDV + admin)
  api/               # NestJS (REST API)
  institutional/     # site institucional
packages/
  ui/                # design system
  config/            # eslint, tsconfig, shared configs
  types/             # tipos compartilhados
infra/
  docker/
  k8s/
docs/
  api/
  architecture/
```

## 10) Requisitos Não Funcionais

- Suporte a milhares de usuários
- P95 de resposta API < 300ms em endpoints críticos
- Backup diário automático + backup manual
- RPO/RTO definidos por plano
- Métricas e alertas com OpenTelemetry + Prometheus/Grafana

## 11) Checklist de Produção

- [ ] Segredos em cofre (Vault/Secrets Manager)
- [ ] TLS obrigatório
- [ ] Migrações versionadas
- [ ] Testes e2e dos fluxos críticos
- [ ] Política de retenção de logs
- [ ] Plano de disaster recovery

