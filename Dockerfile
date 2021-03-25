### Образ с бэкендом ОО ФППД
FROM art-docker-public.rd.aorti.ru/python:3.8-slim-buster AS backend

ARG DB_HOST="fppd-oo-db-svc"
ARG DB_NAME="payment_subsystem"
ARG DB_USER="postgres"
ARG DB_PASSWORD="postgres"
ARG DB_PORT="5432"
ARG ONLINE_PAYMENT_REDIRECT_URL=""
ARG CEPH_ACCESS_KEY=""
ARG CEPH_SECRET_KEY=""
ARG CEPH_HOST=""
ARG CEPH_BUCKET_NAME=""
ARG PROJ_NAME=""
ARG APP_TYPE=""
ARG NODE=""
ARG KEYCLOAK_SERVER_URL=""


RUN mkdir -p /usr/src/payment_subsystem/
WORKDIR /usr/src/payment_subsystem/

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV TZ Europe/Moscow
ENV ALLOWED_HOSTS *
ENV BIND_ADDR 0.0.0.0:8000
ENV NAME ${DB_NAME}
ENV USER ${DB_USER}
ENV PASSWORD ${DB_PASSWORD}
ENV HOST ${DB_HOST}
ENV PORT ${DB_PORT}
ENV ONLINE_PAYMENT_REDIRECT_URL ${ONLINE_PAYMENT_REDIRECT_URL}
ENV CEPH_ACCESS_KEY ${CEPH_ACCESS_KEY}
ENV CEPH_SECRET_KEY ${CEPH_SECRET_KEY}
ENV CEPH_HOST ${CEPH_HOST}
ENV PROJ_NAME ${PROJ_NAME}
ENV APP_TYPE ${APP_TYPE}
ENV NODE ${NODE}
ENV CEPH_BUCKET_NAME ${CEPH_BUCKET_NAME}
ENV KEYCLOAK_SERVER_URL ${KEYCLOAK_SERVER_URL}

COPY uvicorn_entrypoint.sh /root/uvicorn_entrypoint.sh
COPY . .

RUN rm -rf dump.sql create_oo_db.sh \
	&& echo "deb http://art.rd.aorti.ru/repository/debian-yandex/ buster main contrib non-free" > /etc/apt/sources.list \
    && mv pip.conf /etc && pip3 install --upgrade pip \
    && apt update && apt install -y supervisor gcc\
    && pip3 install -U -r requirements.txt \
    && chmod +x /root/uvicorn_entrypoint.sh \
    && mv /usr/src/payment_subsystem/supervisor.conf /etc/supervisor/conf.d/ \
    && service supervisor restart

CMD ["/usr/bin/supervisord"]

## Образ с БД ОО ФППД
FROM art-docker-public.rd.aorti.ru/postgres:latest AS db

ARG DB_NAME="payment_subsystem"
ARG DB_PASSWORD="postgres"
ARG DB_PGDATA="/var/lib/postgresql/data/fppd-oo-data"

ENV POSTGRES_DB ${DB_NAME}
ENV POSTGRES_PASSWORD ${DB_PASSWORD}
ENV POSTGRES_HOST_AUTH_METHOD trust
ENV PGDATA ${DB_PGDATA}
ENV TZ Europe/Moscow

COPY dump.sql /docker-entrypoint-initdb.d/01_script.sql
COPY create_oo_db.sh /docker-entrypoint-initdb.d/create_oo_db.sh

RUN printf "GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO postgres;\n" >> /docker-entrypoint-initdb.d/00_script.sql \
	&& cat /docker-entrypoint-initdb.d/01_script.sql >> /docker-entrypoint-initdb.d/00_script.sql \
	&& chown postgres:postgres /docker-entrypoint-initdb.d/00_script.sql \
	&& rm -f /docker-entrypoint-initdb.d/01_script.sql \
	&& chown -R postgres:postgres /docker-entrypoint-initdb.d \
	&& chmod a+x /docker-entrypoint-initdb.d/create_oo_db.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
