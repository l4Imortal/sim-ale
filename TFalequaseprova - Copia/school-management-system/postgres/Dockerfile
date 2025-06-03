FROM postgres:15-alpine

# Definir variáveis de ambiente padrão
ENV POSTGRES_DB=school_db
ENV POSTGRES_USER=school_user
ENV POSTGRES_PASSWORD=school_password

# Copiar arquivos de inicialização e configuração
COPY init.sql /docker-entrypoint-initdb.d/
COPY postgres.conf /etc/postgresql/postgresql.conf

# Definir permissões corretas e criar diretórios necessários
RUN chmod 644 /docker-entrypoint-initdb.d/init.sql && \
    chmod 600 /etc/postgresql/postgresql.conf && \
    chown postgres:postgres /etc/postgresql/postgresql.conf && \
    mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql

# Mudar para usuário postgres (segurança)
USER postgres

# Expor porta
EXPOSE 5432

# Healthcheck para verificar se o banco está funcionando
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB || exit 1

# Comando de inicialização com arquivo de configuração customizado
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
