# Império Morangos - Site para GitHub Pages

Esta é a versão estática (front-end) da aplicação "Império Morangos" preparada para publicar com GitHub Pages.

O repositório contém:
- `index.html` — aplicação completa (HTML/CSS/JS).
- `.nojekyll` — evita que o GitHub Pages processe com Jekyll (útil para arquivos que começam com `_`).
- `README.md` — instruções.
- `site-vendas/` — front-end do site de vendas.
- `demo/` — ambiente de demonstrações e protótipos.
- `sistema/` — aplicação principal (backoffice/operacional).
- `api/` — serviços de backend e integrações.
- `docs/` — documentação técnica e guias.
- `docker-compose.yml` — orquestração local dos serviços.

Como publicar (opções):

Opção A — Usando um repositório normal (URL ficará: `https://<usuario>.github.io/<repo>`):
1. Faça push dos arquivos para a branch `main` (já tratado).
2. No GitHub (Settings → Pages) selecione:
   - Branch: `main` e diretório `/ (root)`
   - Salve — o site ficará disponível em `https://<usuario>.github.io/<repo>` em alguns minutos.

Opção B — Site no domínio root `https://<usuario>.github.io` (se quiser sem `/repo`):
1. Crie/renomeie o repositório para exatamente: `<usuario>.github.io`.
2. Faça o push dos arquivos para a branch `main`.
3. O site ficará disponível em `https://<usuario>.github.io` imediatamente (após publicação).

Observações:
- A aplicação usa localStorage para dados locais; o backup/restore é feito por arquivo `.json`.
- A app usa jsPDF via CDN para gerar relatórios em PDF — funciona no GitHub Pages.
- Se quiser custom domain (ex: meu-dominio.com), adicione um arquivo `CNAME` com o domínio e configure DNS conforme a documentação do GitHub Pages.
- Posso automatizar o deploy (GitHub Actions) ou criar o repositório e enviar os arquivos para você — me diga se quer CI/CD ou separação de assets.

Se quiser separar CSS/JS em arquivos próprios (melhor organização), eu posso adicionar a estrutura `assets/css` e `assets/js`.
