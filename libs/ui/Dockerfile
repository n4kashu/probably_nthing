FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
COPY libs/ui/package*.json ./libs/ui/

RUN npm install
RUN cd libs/ui && npm install

COPY . .

WORKDIR /app/libs/ui

CMD ["npm", "start"]