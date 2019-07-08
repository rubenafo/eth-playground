const express = require('express')
const app = express()

let port = process.argv[2]
let firstParam = process.argv[3]

app.get('/', (req, res) => res.send(firstParam))
app.listen(port)
