# drsolucoes — Blueprint ERP SaaS Comercial + PDV

Este repositório agora contém uma base de planejamento técnico para construir um sistema ERP comercial SaaS multiempresa com PDV, financeiro, estoque, relatórios e API REST.

## Conteúdo

- `docs/saas-erp-architecture.md` — arquitetura de referência, módulos, segurança, fases de entrega e checklist de produção.
- `docs/database-schema.sql` — modelo relacional inicial PostgreSQL multi-tenant com entidades principais.
- `docs/api-openapi.yaml` — especificação OpenAPI inicial com endpoints essenciais (`/auth`, `/products`, `/customers`, `/sales`, `/reports`).
- `index.html` — aplicação legada estática originalmente existente no projeto.

## Como usar este material

1. Revisar arquitetura e ajustar stack final.
2. Importar schema SQL em ambiente PostgreSQL de desenvolvimento.
3. Gerar servidor inicial da API a partir do OpenAPI/NestJS.
4. Implementar em fases (fundação → PDV → financeiro/relatórios → escala SaaS).

## Próximo passo recomendado

Criar monorepo com:

- `apps/api` (NestJS)
- `apps/web` (React + Vite)
- `apps/institutional` (site institucional)
- `packages/ui` (componentes compartilhados)
