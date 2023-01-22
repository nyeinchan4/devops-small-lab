FROM node:14.21.0-alpine

WORKDIR /var/src/app

COPY package*.json ./

RUN npm install

COPY . . 

ENTRYPOINT [ "npm start" ]
