# Use node image
FROM node:10

LABEL maintainer="clemieux@nextjump.com" service="ci_cd_experiment"

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 2193

CMD ["node", "server.js"]