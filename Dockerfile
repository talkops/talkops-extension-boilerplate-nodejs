FROM node:23.9-slim AS base
ENV NODE_NO_WARNINGS=1
RUN npm install -g pm2
RUN mkdir /app && mkdir /data && chown node:node /app && chown node:node /data
ENV AGENT_URLS=ws://talkops
ENV README_TEMPLATE_URL=https://d8bee12e.talkops.app/readme.ejs
CMD ["pm2-runtime", "ecosystem.config.cjs" ]
WORKDIR /app

FROM base AS dev
COPY . .
RUN chown -R node:node /app
USER node
RUN npm install
VOLUME [ "/app" ]

FROM base
COPY ecosystem.config.cjs index.mjs package.json ./
RUN npm install --omit=dev
COPY schemas schemas
USER node
