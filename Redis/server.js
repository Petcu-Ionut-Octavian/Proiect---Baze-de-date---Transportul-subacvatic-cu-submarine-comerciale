import Redis from "ioredis";
import oracledb from "oracledb";
import express from "express";

const app = express();
const redis = new Redis(); // localhost:6379

// Conexiune Oracle
const db = await oracledb.getConnection({
  user: "octavian",
  password: "Octavian2005",
  connectString: "localhost/FREEPDB1"
});

// GET cu caching
app.get("/produs/:id", async (req, res) => {
  const id = req.params.id;
  const cacheKey = `produs:${id}`;

  // 1. Caut în cache
  const cached = await redis.get(cacheKey);
  if (cached) {
    return res.json({
      source: "cache",
      data: JSON.parse(cached)
    });
  }

  // 2. Dacă nu e în cache → iau din DB
  const result = await db.execute(
    "SELECT * FROM produse WHERE id = :id",
    [id]
  );

  if (result.rows.length === 0) {
    return res.status(404).json({ error: "Produsul nu există" });
  }

  const produs = result.rows[0];

  // 3. Salvez în cache pentru 60 secunde
  await redis.set(cacheKey, JSON.stringify(produs), "EX", 60);

  // 4. Returnez răspunsul
  res.json({
    source: "database",
    data: produs
  });
});

app.listen(3000, () => console.log("Server pornit pe portul 3000"));
