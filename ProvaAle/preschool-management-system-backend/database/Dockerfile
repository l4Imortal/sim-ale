FROM postgres:latest

ENV POSTGRES_DB preschool_management
ENV POSTGRES_USER user
ENV POSTGRES_PASSWORD password

COPY ddl.sql /docker-entrypoint-initdb.d/
