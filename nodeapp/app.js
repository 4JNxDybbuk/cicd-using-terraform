const express = require('express')
const app = express();

app.get('/', (req, res) => {
    res.send("<h1> Server is running... </h1>");
});

app.get('/cicd', (req, res) => {
    res.send("<h1> Succeesfully execute CI/CD pipeline using Terraform & Github Actions... </h1>");
});


app.listen(8080, () => console.log("Server running.."));