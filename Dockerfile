FROM node:14-alpine3.10 AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM node:14-alpine3.10 AS release

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

RUN adduser -S hawkeye

WORKDIR /app

RUN chown -R hawkeye /app

USER hawkeye

COPY package*.json ./

RUN npm install --only=production

COPY . .

COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD ["npm", "run", "start:prod"]