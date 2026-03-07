# DR Soluções — Site institucional (GitHub Pages)

Este repositório publica um site institucional estático da solução ERP SaaS Comercial + PDV.

## Arquivos principais

- `index.html` — página institucional responsiva pronta para publicação.
- `.nojekyll` — garante publicação estática no GitHub Pages sem processamento Jekyll.
- `docs/` — documentação técnica (arquitetura, schema e API) para evolução do produto.

## Publicar no GitHub Pages

### Opção A — projeto em subpasta
URL final: `https://<usuario>.github.io/<repo>`

1. Faça push da branch `main`.
2. No GitHub: **Settings → Pages**.
3. Em **Build and deployment**, escolha **Deploy from a branch**.
4. Selecione **main** e pasta **/(root)**.
5. Salve e aguarde a publicação.

### Opção B — domínio raiz do usuário
URL final: `https://<usuario>.github.io`

1. Renomeie o repositório para `<usuario>.github.io`.
2. Faça push da branch `main`.
3. O site passa a servir no domínio raiz do usuário.

## Próximos passos

- Integrar formulário de contato com API/CRM.
- Separar CSS/JS em `assets/`.
- Evoluir para monorepo (`apps/web`, `apps/api`, `apps/institutional`).
