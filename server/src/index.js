const express = require('express');
const cors = require('cors');
const fs = require('fs/promises');
const path = require('path');

const app = express();
const PORT = Number(process.env.PORT) || 8787;
const HOST = process.env.HOST || '0.0.0.0';
const DATA_DIR = path.join(__dirname, '..', 'data');
const DATA_FILE = path.join(DATA_DIR, 'simulator-db.json');

const defaultDb = {
  updatedAt: new Date().toISOString(),
  missions: [],
  settings: {
    droneCount: 3,
    speed: 2.2,
    city: 'PA',
    mapMode: 'normal',
    language: 'pt-BR'
  }
};

app.use(cors());
app.use(express.json({ limit: '1mb' }));

async function ensureDb() {
  await fs.mkdir(DATA_DIR, { recursive: true });
  try {
    await fs.access(DATA_FILE);
  } catch {
    await fs.writeFile(DATA_FILE, JSON.stringify(defaultDb, null, 2), 'utf-8');
  }
}

async function readDb() {
  await ensureDb();
  const raw = await fs.readFile(DATA_FILE, 'utf-8');
  const parsed = JSON.parse(raw);
  return {
    ...defaultDb,
    ...parsed,
    settings: { ...defaultDb.settings, ...(parsed.settings || {}) },
    missions: Array.isArray(parsed.missions) ? parsed.missions : []
  };
}

async function writeDb(nextDb) {
  const payload = {
    ...nextDb,
    updatedAt: new Date().toISOString()
  };
  await fs.writeFile(DATA_FILE, JSON.stringify(payload, null, 2), 'utf-8');
  return payload;
}

app.get('/health', async (_req, res) => {
  await ensureDb();
  res.json({ ok: true, service: 'drsolucoes-data-server' });
});

app.get('/api/simulator', async (_req, res, next) => {
  try {
    const db = await readDb();
    res.json(db);
  } catch (err) {
    next(err);
  }
});

app.put('/api/simulator/settings', async (req, res, next) => {
  try {
    const db = await readDb();
    const incoming = req.body || {};
    const nextSettings = {
      ...db.settings,
      ...incoming,
      droneCount: Math.min(30, Math.max(0, Number(incoming.droneCount ?? db.settings.droneCount))),
      speed: Math.min(10, Math.max(0.2, Number(incoming.speed ?? db.settings.speed)))
    };
    const saved = await writeDb({ ...db, settings: nextSettings });
    res.json(saved.settings);
  } catch (err) {
    next(err);
  }
});

app.get('/api/simulator/missions', async (_req, res, next) => {
  try {
    const db = await readDb();
    res.json(db.missions);
  } catch (err) {
    next(err);
  }
});

app.post('/api/simulator/missions', async (req, res, next) => {
  try {
    const db = await readDb();
    const item = req.body || {};
    const text = String(item.text || '').trim();
    if (!text) return res.status(400).json({ error: 'text é obrigatório' });

    const missionItem = {
      id: `${Date.now()}-${Math.random().toString(16).slice(2, 8)}`,
      time: item.time || new Date().toISOString(),
      kind: item.kind || 'info',
      text,
      line: item.line || ''
    };

    const limited = [...db.missions, missionItem].slice(-500);
    await writeDb({ ...db, missions: limited });
    res.status(201).json(missionItem);
  } catch (err) {
    next(err);
  }
});

app.delete('/api/simulator/missions', async (_req, res, next) => {
  try {
    const db = await readDb();
    await writeDb({ ...db, missions: [] });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'Erro interno no servidor.' });
});

app.listen(PORT, HOST, () => {
  console.log(`Servidor de dados ativo em http://${HOST}:${PORT}`);
});
