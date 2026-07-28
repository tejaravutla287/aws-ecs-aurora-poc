const express = require("express");
const db = require("./db");

const app = express();

app.use(express.static("public"));

app.get("/health", async (req, res) => {

  try {

    await db.query("SELECT NOW()");

    res.status(200).json({
      status: "healthy"
    });

  } catch (err) {

    res.status(500).json({
      status: "unhealthy",
      error: err.message
    });
  }
});

app.get("/api/version", (req, res) => {

  res.json({
    environment: process.env.ENVIRONMENT,
    version: "1.0.0"
  });
});

app.listen(80, () => {

  console.log("Application Started");
});
