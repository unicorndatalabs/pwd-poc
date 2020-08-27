FROM postgres:12

# set authentication free access
ENV POSTGRES_HOST_AUTH_METHOD trust

# add sql scripts to initialization scripts
COPY create.sql insert.sql /docker-entrypoint-initdb.d/