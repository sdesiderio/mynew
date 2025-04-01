# Usa l'immagine ufficiale di Node.js come base
FROM node:16 AS build

# Imposta la directory di lavoro all'interno del container
WORKDIR /app

# Copia i file package.json e package-lock.json per installare le dipendenze
COPY package*.json ./

# Installa le dipendenze
RUN npm install

# Copia il resto dei file dell'app
COPY . .

# Costruisce l'app per la produzione
RUN npm run build

# Usa un'immagine leggera di Nginx per servire i file statici
FROM nginx:alpine

# Copia il build di React nella cartella di Nginx per la pubblicazione
COPY --from=build /app/build /usr/share/nginx/html

# Espone la porta 80 (la porta predefinita di Nginx)
EXPOSE 80

# Avvia Nginx in modalità foreground
CMD ["nginx", "-g", "daemon off;"]
