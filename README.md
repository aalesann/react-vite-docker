
# Guía para Dockerizar una Aplicación de React en Modo Desarrollo con Vite

Esta guía proporciona los pasos para configurar una aplicación de React con Vite en un contenedor Docker, permitiendo un entorno de desarrollo en tiempo real.

## 1. Configurar la Aplicación de React con Vite

Si aún no has creado la aplicación, inicia creando una con Vite:

```bash
# Crear el directorio de proyecto
mkdir react-vite-docker
cd react-vite-docker

# Crear la aplicación de React con Vite
npm create vite@latest . -- --template react
npm install
```

## 2. Modificar la Configuración de Vite

Abre o crea el archivo de configuración `vite.config.js` en la raíz del proyecto y ajusta las configuraciones de Vite para que funcionen mejor en un entorno de Docker. Añade el siguiente contenido al archivo:

```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Configuración de Vite con configuración para Docker
export default defineConfig({
  plugins: [react()],
  server: {
    host: true,  // Permite que el contenedor se exponga en la red del host
    port: 3000,  // Configura el puerto que usará Vite
    watch: {
      usePolling: true, // Usa la opción de polling para detectar cambios en tiempo real
    }
  }
})
```

## 3. Crear el Dockerfile

Crea un archivo `Dockerfile` para definir la imagen del contenedor. Esta configuración permite construir y ejecutar la aplicación en modo desarrollo.

```Dockerfile
# Usa una imagen base ligera de Node.js
FROM node:21.7.3-alpine

# Define el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia solo los archivos de dependencias primero (esto aprovecha el caché de Docker)
COPY package*.json ./

# Instala dependencias
RUN npm install

# Copia el resto del código de la aplicación al contenedor
COPY . .

# Expone el puerto que usará Vite
EXPOSE 3000

# Comando para iniciar la aplicación en modo desarrollo
CMD ["npm", "run", "dev"]
```

## 4. Crear el archivo `docker-compose.yml`

Para simplificar el despliegue y configurar el volumen para que los cambios se sincronicen automáticamente, crea un archivo `docker-compose.yml`:

```yaml
version: '3.8'

services:
  react-app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"  # Mapea el puerto del contenedor al host
    volumes:
      - .:/app        # Monta el directorio del proyecto en el contenedor
      - /app/node_modules # Evita conflictos en node_modules al montarlo como un volumen anónimo
    environment:
      - NODE_ENV=development
```

## 5. Ejecutar la Aplicación en Docker

Con los archivos configurados, puedes iniciar el contenedor y verificar que la aplicación esté accesible en modo desarrollo:

```bash
docker-compose up
```

Este comando inicia el contenedor y levanta el servidor de Vite en el puerto `3000`, permitiendo que accedas a la aplicación en [http://localhost:3000](http://localhost:3000).

## 6. Verificación de Cambios en Tiempo Real

Gracias a la configuración en el archivo `vite.config.js` (con `usePolling: true`), cualquier cambio en los archivos locales se verá reflejado en el navegador en tiempo real, haciendo que el entorno de desarrollo sea interactivo dentro del contenedor.

Esta configuración, Docker escucha los cambios en el código sin necesidad de variables de entorno adicionales.
