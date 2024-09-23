const express = require('express');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true })); // Adicionando o middleware

// Chave secreta para gerar o JWT (use uma variável de ambiente em produção)
const SECRET_KEY = 'minhaChaveSecreta';

// Endpoint de login
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    console.log(req.body); // Para verificar o que está chegando
    
    // Simulação de validação de usuário
    if (username && password) {
        const token = jwt.sign({ username }, SECRET_KEY, { expiresIn: '1h' });
        res.json({ token });
    } else {
        res.status(400).json({ message: 'Login ou senha inválidos' });
    }
});

// Endpoint para retornar notas dos alunos
app.get('/notasAlunos', (req, res) => {
    const alunos = [
        { matricula: '123', nome: 'João', nota: 55 },
        { matricula: '456', nome: 'Maria', nota: 75 },
        { matricula: '789', nome: 'Pedro', nota: 100 }
    ];

    res.json(alunos);
});

// Iniciar o servidor
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
