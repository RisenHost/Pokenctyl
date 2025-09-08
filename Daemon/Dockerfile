FROM node:18-alpine
WORKDIR /app
COPY daemon.js ./daemon.js
RUN npm init -y && npm i axios
CMD ["node","daemon.js"]
