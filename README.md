# DR Soluções — Site institucional (GitHub Pages)

Este repositório publica um site institucional estático da solução ERP SaaS Comercial + PDV.

## Arquivos principais

- `index.html` — página institucional responsiva pronta para publicação.
- `master.html` — painel de controle do usuário master (módulos, cadastro de empresas, liberação de acesso e geração de links).
- `tenant.html` — ambiente de teste das empresas, acessado por link gerado no master.
- `app.html` — página com módulos funcionais para uso (dashboard, clientes, produtos, PDV, financeiro e relatórios).
- `erp-completo.html` — HTML único completo com todas as funções principais do ERP/PDV (cadastros, vendas, estoque, financeiro, caixa, relatórios, configurações e backup).
- `.nojekyll` — garante publicação estática no GitHub Pages sem processamento Jekyll.
- `docs/` — documentação técnica (arquitetura, schema e API) para evolução do produto.

## Fluxo de liberação por empresa

1. Acesse `master.html`.
2. Faça login master (`master` / `master123`, alterável no painel).
3. Cadastre a empresa com usuário e senha próprios.
4. Vá em **Liberação de acesso**, selecione a empresa e os módulos.
5. Clique em **Gerar link de acesso**.
6. Compartilhe o link com a empresa para ela testar os módulos em `tenant.html` com as credenciais definidas no master.
7. Após login no tenant, clique em **Abrir módulos funcionais** para usar o sistema em `app.html`.

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


## ERP completo em um único HTML

- Abra `erp-completo.html` para usar o sistema completo em formato single-file.
- Fluxo recomendado: cadastre empresa/admin em **Auth**, faça login e use os módulos pelo menu lateral.
