# 🏫 Sistema de Gestão Escolar Infantil

Este projeto implementa um **Sistema de Gestão Escolar** completo com banco de dados PostgreSQL, monitoramento através do Prometheus e visualização de dados usando Grafana. O ambiente é provisionado usando Docker e Docker Compose, otimizado para escolas infantis brasileiras.

## 📋 Índice

- [Características](#-características)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Configuração](#-configuração)
- [Uso](#-uso)
- [Monitoramento](#-monitoramento)
- [Backup](#-backup)
- [Troubleshooting](#-troubleshooting)
- [Contribuição](#-contribuição)
- [Licença](#-licença)

## 🌟 Características

### Funcionalidades Principais
- ✅ **Gestão de Alunos** - Cadastro completo com dados pessoais e responsáveis
- ✅ **Controle de Turmas** - Organização por faixa etária e capacidade
- ✅ **Registro de Frequência** - Controle diário de presença
- ✅ **Gestão de Professores** - Cadastro e alocação por turma
- ✅ **Relatórios Gerenciais** - Dashboards em tempo real

### Tecnologias Utilizadas
- 🐘 **PostgreSQL 15** - Banco de dados principal
- 📊 **Prometheus** - Coleta de métricas
- 📈 **Grafana** - Visualização e dashboards
- 🐳 **Docker & Docker Compose** - Containerização
- 🔧 **Nginx** - Proxy reverso e load balancer
- 🔄 **Backup Automático** - Rotinas de backup diárias

### Configurações Brasileiras
- 🇧🇷 **Timezone**: America/Sao_Paulo
- 🗓️ **Formato de Data**: DD/MM/YYYY
- 💰 **Moeda**: Real Brasileiro (R$)
- 🔤 **Idioma**: Português Brasileiro

## 📁 Estrutura do Projeto

```
school-management-system/
├── 📄 docker-compose.yml              # Orquestração dos containers
├── 📄 README.md                       # Este arquivo
├── 📄 .env.example                    # Variáveis de ambiente (exemplo)
├── 📄 .gitignore                      # Arquivos ignorados pelo Git
│
├── 🗄️ postgres/                       # Configurações do PostgreSQL
│   ├── 📄 Dockerfile                  # Build customizado do PostgreSQL
│   ├── 📁 init/                       # Scripts de inicialização
│   │   ├── 📄 01-init.sql            # Criação das tabelas
│   │   ├── 📄 02-data.sql            # Dados iniciais
│   │   └── 📄 03-indexes.sql         # Índices e otimizações
│   ├── 📄 postgres.conf               # Configurações do PostgreSQL
│   └── 📁 backups/                    # Diretório de backups
│
├── 🖥️ backend/                        # API Backend (Node.js/Express)
│   ├── 📄 Dockerfile                  # Build do backend
│   ├── 📄 package.json               # Dependências Node.js
│   ├── 📁 src/                        # Código fonte
│   │   ├── 📁 controllers/           # Controladores da API
│   │   ├── 📁 models/                # Modelos de dados
│   │   ├── 📁 routes/                # Rotas da API
│   │   └── 📄 app.js                 # Aplicação principal
│   ├── 📁 uploads/                    # Arquivos enviados
│   └── 📁 logs/                       # Logs da aplicação
│
├── 🌐 frontend/                       # Interface Web (React)
│   ├── 📄 Dockerfile                  # Build do frontend
│   ├── 📄 package.json               # Dependências React
│   ├── 📁 src/                        # Código fonte React
│   │   ├── 📁 components/            # Componentes React
│   │   ├── 📁 pages/                 # Páginas da aplicação
│   │   ├── 📁 services/              # Serviços de API
│   │   └── 📄 App.js                 # Componente principal
│   └── 📁 public/                     # Arquivos públicos
│
├── 🔧 nginx/                          # Configurações do Nginx
│   ├── 📄 nginx.conf                 # Configuração principal
│   ├── 📁 ssl/                       # Certificados SSL
│   └── 📁 logs/                      # Logs do Nginx
│
├── 📊 monitoring/                     # Monitoramento e Observabilidade
│   ├── 📁 prometheus/                # Configurações do Prometheus
│   │   ├── 📄 prometheus.yml         # Configuração principal
│   │   ├── 📄 school_alerts.yml      # Regras de alerta
│   │   └── 📁 rules/                 # Regras customizadas
│   │
│   ├── 📁 grafana/                   # Configurações do Grafana
│   │   ├── 📄 grafana.ini            # Configuração principal
│   │   ├── 📁 provisioning/          # Provisionamento automático
│   │   │   ├── 📁 dashboards/        # Dashboards
│   │   │   │   ├── 📄 school-dashboard.json
│   │   │   │   ├── 📄 postgres-dashboard.json
│   │   │   │   └── 📄 system-dashboard.json
│   │   │   └── 📁 datasources/       # Fontes de dados
│   │   │       └── 📄 datasources.yml
│   │   └── 📁 dashboards/            # Dashboards customizados
│   │
│   ├── 📁 alertmanager/              # Gerenciamento de Alertas
│   │   ├── 📄 alertmanager.yml       # Configuração de alertas
│   │   └── 📁 templates/             # Templates de notificação
│   │
│   └── 📁 postgres-exporter/         # Métricas do PostgreSQL
│       └── 📄 queries.yaml           # Queries customizadas
│
├── 💾 backup/                         # Sistema de Backup
│   ├── 📄 Dockerfile                 # Container de backup
│   ├── 📄 backup.sh                  # Script de backup
│   └── 📄 restore.sh                 # Script de restauração
│
└── 📁 data/                          # Dados persistentes
    ├── 📁 postgres/                  # Dados do PostgreSQL
    ├── 📁 grafana/                   # Dados do Grafana
    ├── 📁 prometheus/                # Dados do Prometheus
    └── 📁 alertmanager/              # Dados do Alertmanager
```

## 🔧 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Docker** (versão 20.10+)
- **Docker Compose** (versão 2.0+)
- **Git** (para clonar o repositório)
- **Mínimo 4GB RAM** disponível
- **Mínimo 10GB** de espaço em disco

### Verificação dos Pré-requisitos

```bash
# Verificar versão do Docker
docker --version

# Verificar versão do Docker Compose
docker-compose --version

# Verificar recursos disponíveis
docker system df
```

## 🚀 Instalação

### 1. Clone o Repositório

```bash
git clone https://github.com/seu-usuario/school-management-system.git
cd school-management-system
```

### 2. Configure as Variáveis de Ambiente

```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Edite as variáveis conforme necessário
nano .env
```

### 3. Crie os Diretórios Necessários

```bash
# Criar estrutura de diretórios
mkdir -p data/{postgres,grafana,prometheus,alertmanager}
mkdir -p postgres/backups
mkdir -p nginx/logs
mkdir -p backend/{uploads,logs}

# Definir permissões
sudo chown -R 1000:1000 data/
sudo chmod -R 755 data/
```

### 4. Construa e Inicie os Serviços

```bash
# Construir as imagens
docker-compose build

# Iniciar todos os serviços
docker-compose up -d

# Verificar status dos containers
docker-compose ps
```

### 5. Verificar a Inicialização

```bash
# Acompanhar logs de inicialização
docker-compose logs -f

# Verificar saúde dos serviços
docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

## ⚙️ Configuração

### Configuração Inicial do Banco de Dados

O banco será inicializado automaticamente com:
- Estrutura de tabelas para o sistema escolar
- Dados de exemplo (alunos, professores, turmas)
- Índices otimizados para performance

### Configuração do Grafana

1. **Acesse o Grafana**: http://localhost:3000
2. **Credenciais padrão**: 
   - Usuário: `admin`
   - Senha: `escola123`
3. **Dashboards disponíveis**:
   - Sistema Escolar - Visão Geral
   - PostgreSQL - Métricas Detalhadas
   - Sistema - Recursos e Performance

### Configuração de Alertas

Os alertas estão pré-configurados para:
- ✅ Alto uso de conexões do banco (>80%)
- ✅ Espaço em disco baixo (<10%)
- ✅ Queries lentas (>5 segundos)
- ✅ Falhas de conexão com o banco

## 📖 Uso

### Acessando os Serviços

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| **Frontend da Escola** | http://localhost:3001 | - |
| **API Backend** | http://localhost:8080 | - |
| **Grafana** | http://localhost:3000 | admin / escola123 |
| **Prometheus** | http://localhost:9090 | - |
| **Alertmanager** | http://localhost:9093 | - |
| **PostgreSQL** | localhost:5432 | school_user / school_password_123 |

### Comandos Úteis

```bash
# Parar todos os serviços
docker-compose down

# Reiniciar um serviço específico
docker-compose restart postgres

# Ver logs de um serviço
docker-compose logs -f backend

# Executar backup manual
docker-compose exec backup /backup.sh

# Acessar o banco de dados
docker-compose exec postgres psql -U school_user -d school_db

# Verificar métricas do sistema
docker stats
```

## 📊 Monitoramento

### Dashboards Disponíveis

#### 1. **Dashboard Principal da Escola** 🏫
- Total de alunos cadastrados
- Professores ativos
- Turmas em funcionamento
- Registros de frequência diários
- Performance do sistema

#### 2. **Dashboard do PostgreSQL** 🐘
- Conexões ativas vs máximo
- Tamanho do banco de dados
- Performance de queries
- Taxa de acerto do cache
- Transações por segundo

#### 3. **Dashboard do Sistema** 🖥️
- Uso de CPU e memória
- Espaço em disco
- Rede e I/O
- Status dos containers

### Métricas Importantes

```promql
# Exemplos de queries Prometheus

# Total de alunos
pg_stat_user_tables_n_tup_ins{relname="alunos"}

# Conexões ativas
pg_stat_activity_count{datname="school_db"}

# Queries por segundo
rate(pg_stat_database_xact_commit[5m])

# Uso de memória
pg_stat_bgwriter_buffers_alloc
```

## 💾 Backup

### Backup Automático

O sistema executa backups automáticos:
- **Frequência**: Diariamente às 2h da manhã
- **Retenção**: 30 dias
- **Localização**: `./backups/`
- **Formato**: SQL dump comprimido

### Backup Manual

```bash
# Executar backup manual
docker-compose exec backup /backup.sh

# Listar backups disponíveis
ls -la backups/

# Restaurar backup específico
docker-compose exec backup /restore.sh backup_2024-01-15.sql.gz
```

### Estratégia de Backup

1. **Backup Completo**: Diário (estrutura + dados)
2. **Backup Incremental**: A cada 6 horas (apenas dados alterados)
3. **Backup de Configurações**: Semanal (configs do sistema)
4. **Teste de Restauração**: Mensal (validação dos backups)

## 🔧 Troubleshooting

### Problemas Comuns

#### 1. **Container PostgreSQL não inicia**
```bash
# Verificar logs
docker-compose logs postgres

# Verificar permissões
sudo chown -R 999:999 data/postgres

# Limpar dados corrompidos
docker-compose down -v
docker-compose up -d
```

#### 2. **Grafana não carrega dashboards**
```bash
# Verificar provisionamento
docker-compose logs grafana

# Recriar container
docker-compose up -d --force-recreate grafana
```

#### 3. **Backend não conecta no banco**
```bash
# Verificar conectividade
docker-compose exec backend ping postgres

# Verificar variáveis de ambiente
docker-compose exec backend env | grep DB
```

#### 4. **Prometheus não coleta métricas**
```bash
# Verificar configuração
docker-compose exec prometheus cat /etc/prometheus/prometheus.yml

# Verificar targets
curl http://localhost:9090/api/v1/targets
```

### Logs Importantes

```bash
# Logs do sistema completo
docker-compose logs --tail=100

# Logs específicos por serviço
docker-compose logs postgres
docker-compose logs backend
docker-compose logs grafana
docker-compose logs prometheus
```

### Comandos de Diagnóstico

```bash
# Status dos containers
docker-compose ps

# Uso de recursos
docker stats

# Verificar rede
docker network ls
docker network inspect school-management-system_school_network

# Verificar volumes
docker volume ls
docker volume inspect school-management-system_postgres_data
```

## 🤝 Contribuição

Contribuições são bem-vindas!
