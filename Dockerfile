FROM docker:24.0.5-cli-alpine3.18 as docker

FROM node:alpine3.18 as npm-install

USER node

RUN mkdir -p /home/node/app

WORKDIR /home/node/app

COPY --chown=node:node package.json package.json
COPY --chown=node:node package-lock.json package-lock.json

RUN npm install

FROM node:alpine3.18 as build

USER node

RUN mkdir -p /home/node/app

WORKDIR /home/node/app

COPY --chown=node:node ace ace
COPY --chown=node:node ace-manifest.json ace-manifest.json
COPY --chown=node:node tsconfig.json tsconfig.json
COPY --chown=node:node .adonisrc.json .adonisrc.json
COPY --chown=node:node env.ts env.ts
COPY --chown=node:node server.ts server.ts
COPY --chown=node:node contracts contracts
COPY --chown=node:node commands commands
COPY --chown=node:node providers providers
COPY --chown=node:node config config
COPY --chown=node:node database database
COPY --chown=node:node start start
COPY --chown=node:node app app

COPY --from=npm-install /home/node/app/node_modules node_modules
COPY --from=npm-install /home/node/app/package.json package.json
COPY --from=npm-install /home/node/app/package-lock.json package-lock.json

RUN node ace build --production

FROM node:alpine3.18


ARG DOCKER_GID=1001

RUN addgroup -g $DOCKER_GID docker && \
  addgroup node docker

COPY --from=docker /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/libexec/docker/cli-plugins/docker-compose
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker /usr/local/bin/docker-compose /usr/local/bin/docker-compose

USER node

RUN mkdir -p /home/node/app

WORKDIR /home/node/app

COPY --from=build --chown=node:node /home/node/app/build .

RUN npm ci --production

USER node

ENV PORT=3333
ENV HOST=0.0.0.0
ENV NODE_ENV=production
ENV APP_KEY=secret
ENV DRIVE_DISK=local
ENV DB_CONNECTION=pg
ENV PG_HOST=host.docker.internal
ENV PG_PORT=5432
ENV PG_USER=remote-minecraft-rcon-cli
ENV PG_PASSWORD=secret
ENV PG_DB_NAME=remote-minecraft-rcon-cli

ENTRYPOINT [ "node" ]

CMD [ "server.js" ]
