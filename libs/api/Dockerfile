FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
COPY libs/api/package*.json ./libs/api/

RUN npm install
RUN cd libs/api && npm install

COPY . .

WORKDIR /app/libs/api

CMD ["npm", "start"]