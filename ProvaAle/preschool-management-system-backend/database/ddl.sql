-- Criar tabelas sem dependências primeiro
CREATE TABLE materias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE professores (
    id SERIAL PRIMARY KEY,
    primeiro_nome VARCHAR(50) NOT NULL,
    ultimo_nome VARCHAR(50) NOT NULL,
    data_contratacao DATE NOT NULL,
    materia_id INT REFERENCES materias(id)
);

CREATE TABLE sala (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    professores_id INT REFERENCES professores(id)
);

CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    primeiro_nome VARCHAR(50) NOT NULL,
    ultimo_nome VARCHAR(50) NOT NULL,
    data_de_nascimento DATE NOT NULL,
    data_inscricao DATE NOT NULL,
    sala_id INT REFERENCES sala(id)
);
