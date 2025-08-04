# syntax = docker/dockerfile:1

ARG NODE_VERSION=20.18.0
FROM node:${NODE_VERSION}-slim AS base

LABEL fly_launch_runtime="Node.js"

WORKDIR /app

ENV NODE_ENV="production"
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# --------- Etapa de construcción ---------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    node-gyp \
    pkg-config \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci --include=dev

COPY . .

# --------- Etapa final para producción ---------
FROM base

# Instalamos Chromium y dependencias mínimas
RUN apt-get update && apt-get install --no-install-recommends -y \
    chromium \
    # Dependencias esenciales
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    # Otras dependencias útiles
    ffmpeg \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

# Configuración de Chromium para Puppeteer
RUN ln -s /usr/bin/chromium /usr/bin/chromium-browser

COPY --from=build /app /app

# Asegurar permisos adecuados
RUN chown -R node:node /app
USER node

EXPOSE 3000

CMD ["npm", "start"]
