-- Criar extensões úteis
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabela de professores
CREATE TABLE professores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    especializacao VARCHAR(100),
    data_contratacao DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de turmas/classes
CREATE TABLE turmas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    nivel_ensino VARCHAR(20) NOT NULL, -- Ex: "Maternal I", "Jardim II", etc.
    professor_id INT REFERENCES professores(id) ON DELETE SET NULL,
    maximo_alunos INT DEFAULT 20,
    ano_letivo INT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de responsáveis/pais
CREATE TABLE responsaveis (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20) NOT NULL,
    endereco TEXT,
    parentesco VARCHAR(50) NOT NULL, -- "Pai", "Mãe", "Avô", etc.
    contato_emergencia BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de estudantes/alunos
CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    idade INT GENERATED ALWAYS AS (EXTRACT(YEAR FROM AGE(data_nascimento))) STORED,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    turma_id INT REFERENCES turmas(id) ON DELETE SET NULL,
    numero_matricula VARCHAR(20) UNIQUE NOT NULL,
    data_matricula DATE DEFAULT CURRENT_DATE,
    informacoes_medicas TEXT,
    alergias TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de relacionamento aluno-responsável
CREATE TABLE aluno_responsaveis (
    id SERIAL PRIMARY KEY,
    aluno_id INT REFERENCES alunos(id) ON DELETE CASCADE,
    responsavel_id INT REFERENCES responsaveis(id) ON DELETE CASCADE,
    responsavel_principal BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(aluno_id, responsavel_id)
);

-- Tabela de disciplinas/matérias
CREATE TABLE disciplinas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    niveis_ensino TEXT[], -- Array com níveis que podem cursar
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de horários das aulas
CREATE TABLE horarios (
    id SERIAL PRIMARY KEY,
    turma_id INT REFERENCES turmas(id) ON DELETE CASCADE,
    disciplina_id INT REFERENCES disciplinas(id) ON DELETE CASCADE,
    professor_id INT REFERENCES professores(id) ON DELETE SET NULL,
    dia_semana INT CHECK (dia_semana BETWEEN 1 AND 7), -- 1=Segunda, 7=Domingo
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(turma_id, dia_semana, hora_inicio)
);

-- Tabela de presença/frequência
CREATE TABLE frequencia (
    id SERIAL PRIMARY KEY,
    aluno_id INT REFERENCES alunos(id) ON DELETE CASCADE,
    turma_id INT REFERENCES turmas(id) ON DELETE CASCADE,
    data_frequencia DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'presente' CHECK (status IN ('presente', 'ausente', 'atrasado', 'justificado')),
    observacoes TEXT,
    registrado_por INT REFERENCES professores(id),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(aluno_id, data_frequencia)
);

-- Tabela de avaliações/notas
CREATE TABLE avaliacoes (
    id SERIAL PRIMARY KEY,
    aluno_id INT REFERENCES alunos(id) ON DELETE CASCADE,
    disciplina_id INT REFERENCES disciplinas(id) ON DELETE CASCADE,
    professor_id INT REFERENCES professores(id) ON DELETE SET NULL,
    tipo_avaliacao VARCHAR(50) NOT NULL, -- "Prova", "Trabalho", "Participação"
    nota DECIMAL(5,2),
    nota_maxima DECIMAL(5,2) DEFAULT 10.00,
    data_avaliacao DATE NOT NULL,
    comentarios TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de eventos escolares
CREATE TABLE eventos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_evento DATE NOT NULL,
    hora_inicio TIME,
    hora_fim TIME,
    local VARCHAR(100),
    tipo_evento VARCHAR(50), -- "Reunião", "Festa", "Apresentação", etc.
    turmas_participantes INT[], -- Array de IDs das turmas
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar índices para performance
CREATE INDEX idx_alunos_turma ON alunos(turma_id);
CREATE INDEX idx_alunos_ativo ON alunos(ativo);
CREATE INDEX idx_frequencia_data ON frequencia(data_frequencia);
CREATE INDEX idx_frequencia_aluno ON frequencia(aluno_id);
CREATE INDEX idx_horarios_turma_dia ON horarios(turma_id, dia_semana);
CREATE INDEX idx_avaliacoes_aluno ON avaliacoes(aluno_id);
CREATE INDEX idx_eventos_data ON eventos(data_evento);

-- Inserir dados de exemplo
INSERT INTO professores (nome, email, telefone, especializacao, data_contratacao) VALUES
('Maria Silva Santos', 'maria.silva@escolainfantil.com.br', '(11) 99999-1111', 'Educação Infantil', '2023-01-15'),
('João Pedro Costa', 'joao.costa@escolainfantil.com.br', '(11) 99999-2222', 'Educação Física', '2023-02-01'),
('Ana Beatriz Lima', 'ana.lima@escolainfantil.com.br', '(11) 99999-3333', 'Artes e Música', '2023-03-10'),
('Carla Fernanda Souza', 'carla.souza@escolainfantil.com.br', '(11) 99999-4444', 'Psicopedagogia', '2023-04-05');

INSERT INTO turmas (nome, nivel_ensino, professor_id, ano_letivo) VALUES
('Turma dos Patinhos', 'Maternal I', 1, 2024),
('Turma dos Coelhinhos', 'Maternal II', 2, 2024),
('Turma das Borboletas', 'Jardim I', 3, 2024),
('Turma dos Passarinhos', 'Jardim II', 4, 2024);

INSERT INTO disciplinas (nome, descricao, niveis_ensino) VALUES
('Linguagem e Comunicação', 'Desenvolvimento da linguagem oral, escrita e expressão', ARRAY['Maternal I', 'Maternal II', 'Jardim I', 'Jardim II']),
('Matemática Lúdica', 'Conceitos básicos de números, formas e quantidades', ARRAY['Maternal II', 'Jardim I', 'Jardim II']),
('Educação Física', 'Desenvolvimento motor, coordenação e atividades físicas', ARRAY['Maternal I', 'Maternal II', 'Jardim I', 'Jardim II']),
('Artes e Música', 'Expressão artística, criatividade e musicalização', ARRAY['Maternal I', 'Maternal II', 'Jardim I', 'Jardim II']),
('Ciências da Natureza', 'Descoberta do mundo natural e meio ambiente', ARRAY['Jardim I', 'Jardim II']),
('Socialização', 'Desenvolvimento social e emocional', ARRAY['Maternal I', 'Maternal II', 'Jardim I', 'Jardim II']);

INSERT INTO responsaveis (nome, email, telefone, endereco, parentesco, contato_emergencia) VALUES
('Carlos Eduardo Oliveira', 'carlos.oliveira@email.com', '(11) 98888-1111', 'Rua das Flores, 123 - Vila Madalena', 'Pai', TRUE),
('Lucia Maria Oliveira', 'lucia.oliveira@email.com', '(11) 98888-2222', 'Rua das Flores, 123 - Vila Madalena', 'Mãe', TRUE),
('Roberto Silva Santos', 'roberto.santos@email.com', '(11) 97777-3333', 'Av. Paulista, 456 - Bela Vista', 'Pai', TRUE),
('Fernanda Costa Santos', 'fernanda.santos@email.com', '(11) 97777-4444', 'Av. Paulista, 456 - Bela Vista', 'Mãe', FALSE);

INSERT INTO alunos (nome, data_nascimento, sexo, turma_id, numero_matricula, informacoes_medicas, alergias) VALUES
('Pedro Henrique Oliveira', '2020-05-15', 'M', 1, 'MAT2024001', 'Nenhuma observação médica especial', 'Alergia a amendoim'),
('Sofia Isabella Oliveira', '2019-08-22', 'F', 2, 'MAT2024002', 'Usa óculos para miopia leve', 'Nenhuma alergia conhecida'),
('Gabriel Lucas Santos', '2020-12-10', 'M', 1, 'MAT2024003', 'Asma leve - possui bombinha', 'Alergia a pólen'),
('Valentina Maria Santos', '2018-03-18', 'F', 3, 'MAT2024004', 'Nenhuma observação médica especial', 'Intolerância à lactose');

INSERT INTO aluno_responsaveis (aluno_id, responsavel_id, responsavel_principal) VALUES
(1, 1, TRUE),   -- Pedro - Carlos (pai principal)
(1, 2, FALSE),  -- Pedro - Lucia (mãe)
(2, 1, FALSE),  -- Sofia - Carlos (pai)
(2, 2, TRUE),   -- Sofia - Lucia (mãe principal)
(3, 3, TRUE),   -- Gabriel - Roberto (pai principal)
(3, 4, FALSE),  -- Gabriel - Fernanda (mãe)
(4, 3, FALSE),  -- Valentina - Roberto (pai)
(4, 4, TRUE);   -- Valentina - Fernanda (mãe principal)

INSERT INTO horarios (turma_id, disciplina_id, professor_id, dia_semana, hora_inicio, hora_fim) VALUES
-- Segunda-feira
(1, 1, 1, 1, '08:00', '09:00'), -- Maternal I - Linguagem
(1, 4, 3, 1, '09:00', '10:00'), -- Maternal I - Artes
(2, 1, 2, 1, '08:00', '09:00'), -- Maternal II - Linguagem
(2, 2, 2, 1, '09:00', '10:00'), -- Maternal II - Matemática
-- Terça-feira
(1, 3, 2, 2, '08:00', '09:00'), -- Maternal I - Ed. Física
(1, 6, 1, 2, '09:00', '10:00'), -- Maternal I - Socialização
(3, 1, 3, 2, '08:00', '09:00'), -- Jardim I - Linguagem
(3, 5, 3, 2, '09:00', '10:00'); -- Jardim I - Ciências

INSERT INTO eventos (titulo, descricao, data_evento, hora_inicio, hora_fim, local, tipo_evento, turmas_participantes) VALUES
('Festa Junina 2024', 'Tradicional festa junina da escola com quadrilha e comidas típicas', '2024-06-15', '14:00', '17:00', 'Pátio Principal', 'Festa', ARRAY[1,2,3,4]),
('Reunião de Pais - 1º Semestre', 'Reunião para apresentação do desenvolvimento dos alunos', '2024-07-10', '19:00', '21:00', 'Auditório', 'Reunião', ARRAY[1,2]),
('Apresentação de Teatro', 'Peça teatral apresentada pelos alunos do Jardim', '2024-08-20', '15:00', '16:00', 'Sala de Artes', 'Apresentação', ARRAY[3,4]),
('Dia das Crianças', 'Comemoração especial com brincadeiras e atividades lúdicas', '2024-10-12', '08:00', '12:00', 'Toda a Escola', 'Comemoração', ARRAY[1,2,3,4]);

-- Função para atualizar campo atualizado_em automaticamente
CREATE OR REPLACE FUNCTION atualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualizar atualizado_em automaticamente
CREATE TRIGGER trigger_professores_atualizado_em BEFORE UPDATE ON professores FOR EACH ROW EXECUTE FUNCTION atualizar_timestamp();
CREATE TRIGGER trigger_turmas_atualizado_em BEFORE UPDATE ON turmas FOR EACH ROW EXECUTE FUNCTION atualizar_timestamp();
CREATE TRIGGER trigger_responsaveis_atualizado_em BEFORE UPDATE ON responsaveis FOR EACH ROW EXECUTE FUNCTION atualizar_timestamp();
CREATE TRIGGER trigger_alunos_atualizado_em BEFORE UPDATE ON alunos FOR EACH ROW EXECUTE FUNCTION atualizar_timestamp();
CREATE TRIGGER trigger_disciplinas_atualizado_em BEFORE UPDATE ON disciplinas FOR EACH ROW EXECUTE FUNCTION atualizar_timestamp();
CREATE TRIGGER trigger_eventos_atualizado_em BEFORE UPDATE ON eventos FOR EACH ROW EXECUTE FUNCTION atualizar_timestamp();

-- Views úteis para consultas frequentes
CREATE VIEW vw_alunos_completo AS
SELECT 
    a.id,
    a.nome,
    a.data_nascimento,
    a.idade,
    a.sexo,
    a.numero_matricula,
    a.data_matricula,
    a.informacoes_medicas,
    a.alergias,
    a.ativo,
    t.nome as turma_nome,
    t.nivel_ensino,
    p.nome as professor_nome,
    r.nome as responsavel_principal_nome,
    r.telefone as responsavel_telefone
FROM alunos a
LEFT JOIN turmas t ON a.turma_id = t.id
LEFT JOIN professores p ON t.professor_id = p.id
LEFT JOIN aluno_responsaveis ar ON a.id = ar.aluno_id AND ar.responsavel_principal = TRUE
LEFT JOIN responsaveis r ON ar.responsavel_id = r.id
WHERE a.ativo = TRUE;

CREATE VIEW vw_frequencia_mensal AS
SELECT 
    a.nome as aluno_nome,
    t.nome as turma_nome,
    DATE_TRUNC('month', f.data_frequencia) as mes,
    COUNT(*) as total_dias,
    COUNT(CASE WHEN f.status = 'presente' THEN 1 END) as dias_presentes,
    COUNT(CASE WHEN f.status = 'ausente' THEN 1 END) as dias_ausentes,
    ROUND(
        (COUNT(CASE WHEN f.status = 'presente' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2
    ) as percentual_presenca
FROM frequencia f
JOIN alunos a ON f.aluno_id = a.id
JOIN turmas t ON f.turma_id = t.id
GROUP BY a.id, a.nome, t.nome, DATE_TRUNC('month', f.data_frequencia)
ORDER BY mes DESC, a.nome;

CREATE VIEW vw_horarios_turma AS
SELECT 
    t.nome as turma_nome,
    t.nivel_ensino,
    CASE h.dia_semana
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END as dia_semana_nome,
    h.hora_inicio,
    h.hora_fim,
    d.nome as disciplina_nome,
    p.nome as professor_nome
FROM horarios h
JOIN turmas t ON h.turma_id = t.id
JOIN disciplinas d ON h.disciplina_id = d.id
JOIN professores p ON h.professor_id = p.id
ORDER BY t.nome, h.dia_semana, h.hora_inicio;

-- Inserir dados de frequência de exemplo (últimos 30 dias)
INSERT INTO frequencia (aluno_id, turma_id, data_frequencia, status, registrado_por)
SELECT 
    a.id,
    a.turma_id,
    d.data_freq,
    CASE 
        WHEN RANDOM() < 0.9 THEN 'presente'
        WHEN RANDOM() < 0.95 THEN 'atrasado'
        ELSE 'ausente'
    END,
    t.professor_id
FROM alunos a
CROSS JOIN (
    SELECT CURRENT_DATE - INTERVAL '1 day' * generate_series(0, 29) as data_freq
) d
JOIN turmas t ON a.turma_id = t.id
WHERE EXTRACT(DOW FROM d.data_freq) BETWEEN 1 AND 5 -- Segunda a sexta
AND a.ativo = TRUE;

-- Inserir avaliações de exemplo
INSERT INTO avaliacoes (aluno_id, disciplina_id, professor_id, tipo_avaliacao, nota, data_avaliacao, comentarios)
VALUES
(1, 1, 1, 'Observação Diária', 8.5, '2024-05-15', 'Pedro demonstra boa evolução na comunicação oral'),
(1, 4, 3, 'Atividade Prática', 9.0, '2024-05-20', 'Muito criativo nas atividades artísticas'),
(2, 1, 2, 'Observação Diária', 9.5, '2024-05-15', 'Sofia tem excelente desenvolvimento da linguagem'),
(2, 2, 2, 'Atividade Lúdica', 8.0, '2024-05-18', 'Boa compreensão dos conceitos matemáticos básicos'),
(3, 1, 1, 'Observação Diária', 7.5, '2024-05-15', 'Gabriel está mais participativo nas atividades'),
(4, 5, 3, 'Projeto', 9.2, '2024-05-22', 'Valentina demonstra grande curiosidade sobre a natureza');

-- Função para calcular idade automaticamente
CREATE OR REPLACE FUNCTION calcular_idade(data_nascimento DATE)
RETURNS INT AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(data_nascimento));
END;
$$ LANGUAGE plpgsql;

-- Função para gerar número de matrícula automático
CREATE OR REPLACE FUNCTION gerar_numero_matricula()
RETURNS TEXT AS $$
DECLARE
    ano_atual INT;
    proximo_numero INT;
    numero_matricula TEXT;
BEGIN
    ano_atual := EXTRACT(YEAR FROM CURRENT_DATE);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(numero_matricula FROM 8) AS INT)), 0) + 1
    INTO proximo_numero
    FROM alunos
    WHERE numero_matricula LIKE 'MAT' || ano_atual || '%';
    
    numero_matricula := 'MAT' || ano_atual || LPAD(proximo_numero::TEXT, 3, '0');
    
    RETURN numero_matricula;
END;
$$ LANGUAGE plpgsql;

-- Trigger para gerar número de matrícula automaticamente
CREATE OR REPLACE FUNCTION trigger_gerar_matricula()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.numero_matricula IS NULL OR NEW.numero_matricula = '' THEN
        NEW.numero_matricula := gerar_numero_matricula();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_alunos_gerar_matricula 
    BEFORE INSERT ON alunos 
    FOR EACH ROW 
    EXECUTE FUNCTION trigger_gerar_matricula();

-- Comentários nas tabelas para documentação
COMMENT ON TABLE professores IS 'Tabela que armazena informações dos professores da escola infantil';
COMMENT ON TABLE turmas IS 'Tabela que armazena informações das turmas/classes da escola';
COMMENT ON TABLE responsaveis IS 'Tabela que armazena informações dos pais e responsáveis pelos alunos';
COMMENT ON TABLE alunos IS 'Tabela principal que armazena informações dos alunos matriculados';
COMMENT ON TABLE disciplinas IS 'Tabela que armazena as matérias/atividades oferecidas pela escola';
COMMENT ON TABLE horarios IS 'Tabela que define os horários das aulas por turma';
COMMENT ON TABLE frequencia IS 'Tabela que registra a presença diária dos alunos';
COMMENT ON TABLE avaliacoes IS 'Tabela que armazena as avaliações e notas dos alunos';
COMMENT ON TABLE eventos IS 'Tabela que armazena os eventos escolares (festas, reuniões, etc.)';

-- Inserir configurações do sistema
CREATE TABLE configuracoes_sistema (
    id SERIAL PRIMARY KEY,
    chave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT NOT NULL,
    descricao TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO configuracoes_sistema (chave, valor, descricao) VALUES
('nome_escola', 'Escola Infantil Pequenos Sonhadores', 'Nome oficial da instituição'),
('endereco_escola', 'Rua das Crianças, 456 - Jardim Feliz - São Paulo/SP', 'Endereço completo da escola'),
('telefone_escola', '(11) 3333-4444', 'Telefone principal da escola'),
('email_escola', 'contato@pequenossonhadores.edu.br', 'Email oficial da escola'),
('horario_funcionamento', '07:00 às 18:00', 'Horário de funcionamento da escola'),
('ano_letivo_atual', '2024', 'Ano letivo em vigor'),
('capacidade_maxima_turma', '20', 'Número máximo de alunos por turma'),
('idade_minima_matricula', '2', 'Idade mínima para matrícula (em anos)'),
('idade_maxima_matricula', '6', 'Idade máxima para matrícula (em anos)');

-- Mensagem de conclusão
DO $$
BEGIN
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'BANCO DE DADOS DA ESCOLA INFANTIL CRIADO COM SUCESSO!';
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Tabelas criadas: 10';
    RAISE NOTICE 'Views criadas: 3';
    RAISE NOTICE 'Funções criadas: 4';
    RAISE NOTICE 'Triggers criados: 7';
    RAISE NOTICE 'Dados de exemplo inseridos: ✓';
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Sistema pronto para uso!';
    RAISE NOTICE '=================================================';
END $$;
