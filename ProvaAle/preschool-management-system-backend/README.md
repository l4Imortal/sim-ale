# Backend do Sistema de Gestão de Escola Infantil

## Visão Geral
O Sistema de Gestão de Escola Infantil é uma aplicação backend projetada para gerenciar diversos aspectos de uma escola infantil, incluindo alunos, professores, turmas e disciplinas. Este projeto utiliza Node.js com TypeScript e é conteinerizado utilizando Docker.

## Estrutura do Projeto
```
preschool-management-system-backend
├── src
│   ├── app.ts
│   ├── controllers
│   │   └── index.ts
│   ├── routes
│   │   └── index.ts
│   ├── models
│   │   └── index.ts
│   └── types
│       └── index.ts
├── database
│   ├── ddl.sql
│   └── Dockerfile
├── backend
│   └── Dockerfile
├── docker-compose.yml
├── package.json
├── tsconfig.json
└── README.md
```

## Pré-requisitos
- Docker
- Docker Compose
- Node.js (para desenvolvimento local)

## Instruções de Configuração

1. **Clonar o Repositório**
   ```bash
   git clone https://github.com/seunomeusuario/preschool-management-system-backend.git
   cd preschool-management-system-backend
   ```

2. **Construir e Executar os Contêineres Docker**
   Utilize o Docker Compose para construir e executar os contêineres da aplicação e do banco de dados.
   ```bash
   docker-compose up --build
   ```

3. **Acessar a Aplicação**
   Após os contêineres estarem em execução, você pode acessar a aplicação backend em `http://localhost:3000`.

## Configuração do Banco de Dados
O esquema do banco de dados está definido em `database/ddl.sql`. Este arquivo contém as instruções DDL necessárias para criar as tabelas de alunos, professores, turmas e disciplinas.

## Configuração do Docker
- O arquivo `database/Dockerfile` configura o ambiente do banco de dados.
- O arquivo `backend/Dockerfile` configura o ambiente Node.js para a aplicação backend.

## Contribuindo
Sinta-se à vontade para fazer um fork do repositório e enviar pull requests com melhorias ou novos recursos.

## Licença
Este projeto está licenciado sob a Licença MIT. Consulte o arquivo LICENSE para mais detalhes.

## Agradecimentos
Agradecemos a todos os colaboradores e à comunidade de código aberto pelo suporte.