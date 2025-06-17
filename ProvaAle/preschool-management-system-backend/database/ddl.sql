CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    primeiro_nome VARCHAR(50) NOT NULL,
    ultimo_nome VARCHAR(50) NOT NULL,
    data_de_nascimento DATE NOT NULL,
    data_inscrição DATE NOT NULL,
    sala_id INT REFERENCES classes(id)
);

CREATE TABLE profrssores (
    id SERIAL PRIMARY KEY,
    primeiro_nome VARCHAR(50) NOT NULL,
    ultimo_nome VARCHAR(50) NOT NULL,
    data_contratacao DATE NOT NULL,
    materia_id INT REFERENCES subjects(id)
);

CREATE TABLE sala (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    profrssores_id INT REFERENCES teachers(id)
);

CREATE TABLE materias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);