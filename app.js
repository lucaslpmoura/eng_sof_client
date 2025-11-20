const express = require('express');
const path = require('path');
const app = express();
const PORT = 80;

const webPath = path.join(__dirname, 'build', 'web');

app.use(express.static(webPath));

app.get('/client', (req, res) => {
    res.sendFile(path.join(webPath, 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
