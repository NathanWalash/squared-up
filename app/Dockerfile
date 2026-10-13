# Build stages run on the machine doing the build (fast, no emulation). The
# output is plain JavaScript, so it runs on the target platform unchanged.
FROM --platform=$BUILDPLATFORM node:22-slim AS buildbase
WORKDIR /app

# Install all dependencies (cached unless package files change).
FROM buildbase AS deps
COPY package.json package-lock.json ./
RUN npm ci

# Generate the Prisma client and build the Next.js app.
FROM buildbase AS build
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Prisma reads this while generating; it is not used to connect at build time.
ENV DATABASE_URL="postgresql://build:build@localhost:5432/build"
RUN npx prisma generate && npm run build

# Runtime stages use the target platform (linux/amd64 for Azure Container Apps).
FROM node:22-slim AS base
WORKDIR /app

# The web app: small standalone server, runs as a non-root user.
FROM base AS runner
ENV NODE_ENV=production \
    PORT=3000 \
    HOSTNAME=0.0.0.0
COPY --from=build /app/public ./public
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
USER node
EXPOSE 3000
CMD ["node", "server.js"]

# One-off job image: applies the Prisma migrations to the database.
# Installs on the target platform because Prisma's migration engine is a native binary.
FROM base AS migrate
# Prisma's migration engine needs OpenSSL to connect to Azure Postgres over TLS.
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
RUN npm ci
COPY prisma ./prisma
COPY prisma.config.ts ./
CMD ["npx", "prisma", "migrate", "deploy"]
