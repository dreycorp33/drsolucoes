# DR Soluções — Simulador + Servidor de Dados

Este repositório agora possui:

- `index.html`: front-end do simulador (Leaflet + voz + waypoints + histórico de missão).
- `server/`: API Node.js/Express para persistir dados (missões e configurações) em JSON.

## 1) Rodar localmente

### Front-end
```bash
python -m http.server 8000
```
Acesse: `http://127.0.0.1:8000`

### API de dados
```bash
cd server
npm install
npm start
```
API em: `http://127.0.0.1:8787`

Endpoints principais:
- `GET /health`
- `GET /api/simulator`
- `PUT /api/simulator/settings`
- `GET /api/simulator/missions`
- `POST /api/simulator/missions`
- `DELETE /api/simulator/missions`

## 2) Publicar no GitHub + servidor de dados

O GitHub Pages hospeda **somente front-end estático**. Para ter servidor de dados, publique a pasta `server/` em um provedor Node (Render/Railway/Fly.io) conectado ao seu repositório GitHub.

### Fluxo sugerido (Render)
1. Suba o repositório no GitHub.
2. No Render, crie um *Web Service* ligado ao repositório.
3. Configure:
   - **Root Directory:** `server`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
4. Deploy.
5. Copie a URL pública (ex.: `https://seu-servidor.onrender.com`).
6. No navegador do simulador, configure a base da API:
   ```js
   localStorage.setItem('dr_api_base', 'https://seu-servidor.onrender.com')
   location.reload()
   ```

## 3) Persistência no front-end

O front-end tenta conectar em `http://127.0.0.1:8787` por padrão.

- Se a API estiver online: salva/carrega histórico e configurações.
- Se estiver offline: entra em modo local sem quebrar a UI.

## 4) Observações

- O servidor salva dados em `server/data/simulator-db.json`.
- Para produção, pode trocar por banco real (PostgreSQL/MongoDB).
- Para múltiplos usuários, recomendamos autenticação e separação por conta/projeto.
