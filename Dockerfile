# Usa una imagen base de Node.js
FROM node:21.7.3-alpine

# Define el directorio de trabajo en el contenedor
WORKDIR /app

# Copia el package.json y el package-lock.json para instalar dependencias
COPY package*.json ./

# Instala dependencias
RUN npm install

# Copia el resto del código fuente
COPY . .

# Expone el puerto que usará Vite (por defecto 5173)
EXPOSE 3000

# Comando para iniciar el servidor de desarrollo
CMD ["npm", "run", "dev"]
