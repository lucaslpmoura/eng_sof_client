const express = require('express');
const path = require('path');
const app = express();
const PORT = 80;

// Caminho absoluto da pasta "build/web"
const webPath = path.join(__dirname, 'build', 'web');

// Servir arquivos estáticos do Flutter Web
app.use(express.static(webPath));

// Para qualquer rota, retornar o index.html (SPA)
app.get('/client', (req, res) => {
    res.sendFile(path.join(webPath, 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
