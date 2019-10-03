'use strict';

const express = require('express');

const PORT = 2193;
const HOST = '127.0.0.1';

const app = express();
app.get('/', (req, res) => {
    res.send('hello world');
});

app.listen(PORT, HOST);

console.log(`Running on http://${HOST}:${PORT}`);