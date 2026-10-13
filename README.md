# Squared Up

A small kanban board deployed to Azure with Terraform, built as a hands-on way to learn Azure and infrastructure as code.

The infrastructure is built step by step in small modules. The app starts simple: three columns, cards you can move between them. Recurring and scheduled cards come after that.

> **Status:** v1 is deployed. The kanban runs on Azure Container Apps with its data in Azure Database for PostgreSQL, all built with Terraform. There is no sign-in yet, so the live site is only up while I am working on it.

## Run the app locally

You need Node.js and Docker. From the repo root:

```bash
docker compose up -d                  # Postgres on localhost:5433
cd app
cp .env.example .env
npm install
./node_modules/.bin/prisma migrate dev
./node_modules/.bin/prisma generate
npm run dev                           # http://localhost:3000
```

(If your checkout path contains a `:` character, npm cannot find `node_modules/.bin` programs by name. Call them by path as above, or check the code out somewhere without one.)

## Architecture (so far)

```mermaid
flowchart LR
    user([Browser]) -->|HTTPS| app

    subgraph azure[Azure, resource group rg-squaredup-dev]
        subgraph env[Container Apps environment]
            app[Container App: kanban]
            job[Container App Job: migrations]
        end
        db[(PostgreSQL Flexible Server)]
        acr[(Container Registry)]
        id{{Managed identity: AcrPull}}
        logs[(Log Analytics)]
        app -->|cards| db
        job -->|creates tables| db
        app -. pulls image .-> acr
        job -. pulls image .-> acr
        id -. authorises .-> acr
        app --- id
        env -->|logs| logs
    end

    tf[Terraform] -->|creates| azure
    tf <-->|state| state[(Blob Storage: tfstate)]
```

The app pulls its image from a private registry using a managed identity, so there are no registry passwords. Terraform keeps its state in Azure Blob Storage, in a separate resource group so tearing the app down never deletes it.

## What exists today

| Piece | Azure service |
|---|---|
| Resource group, tags | Resource Manager |
| Spending alerts at 50, 75, 90 and 100% of a monthly budget | Cost Management budget |
| Logs | Log Analytics workspace (module `monitoring`) |
| Image storage and pull identity | Container Registry, user-assigned managed identity, `AcrPull` role (module `registry`) |
| Hosting | Container Apps environment and app, scale to zero (module `app`) |
| Database | Azure Database for PostgreSQL Flexible Server, with a generated admin password (module `database`) |
| Migrations | A manually triggered Container App Job that runs `prisma migrate deploy` (module `job`) |
| The app | Next.js, Server Actions, Zod and Prisma: add, move and delete cards across To do, Doing and Done |

## Roadmap

| Stage | What |
|---|---|
| Done | v1: foundations, database, the kanban app, containerised and deployed |
| Next | Recurring cards: a daily Container App Job spawns upcoming cards and moves them to To do when the date passes |
| Later | Sign-in (Entra ID), Key Vault, App Insights, private networking, CI/CD with GitHub Actions |

## Repo layout

```
app/                  Next.js kanban app, Dockerfile, Prisma schema and migrations
infra/                Terraform root module
  modules/
    monitoring/       Log Analytics workspace
    registry/         Container Registry, pull identity, role assignment
    app/              Container Apps environment and app
    database/         PostgreSQL Flexible Server and database
    job/              Container App Job (migrations)
docs/                 Design spec
docker-compose.yml    Local Postgres for development
```

## Running it yourself

You need an Azure subscription, the Azure CLI, Terraform and Docker.

1. Create the Terraform state storage once, by hand (a resource group, a storage account and a private `tfstate` container), and update the `backend` block in `infra/providers.tf` with your names.
2. Register the resource providers (`Microsoft.App`, `Microsoft.ContainerRegistry`, `Microsoft.OperationalInsights`, `Microsoft.ManagedIdentity` and so on).
3. From `infra/`:

```bash
az login
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
export TF_VAR_alert_email="you@example.com"
terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan
```

4. The app needs its images in the registry before it can start, so create the registry first (`terraform apply -target=module.registry`), then build for `linux/amd64` and push `squaredup-app` and `squaredup-migrate` (the `runner` and `migrate` targets of `app/Dockerfile`), then run the full `terraform apply`.
5. Create the tables by starting the migration job (`az containerapp job start`, using the `migrate_job_name` output). The site is at the `app_url` output.

Tear it down with `terraform destroy`. The state storage lives outside the config, so it survives.

## Cost

A small Basic registry costs a few pence a day, the workspace has a daily ingestion cap, and the app scales to zero. PostgreSQL is the main running cost (roughly 40 to 60 pence a day while it exists), so the stack is meant to be destroyed between sessions.

## How it's built

This is a learning project. I write the Terraform and app code, using Claude as a tutor and reviewer, and for some starter snippets. Each lesson is one commit.

## License

MIT
