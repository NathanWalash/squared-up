# Squared Up: design spec

Date: 2026-10-13

## Goal

Learn Azure and Terraform by building and deploying a small real app, one lesson at a time. The learner writes the code and infrastructure. Claude guides, explains and reviews, and does not write the solution unless asked. The app is a vehicle for the infrastructure, so it stays thin.

## The app

A shared board for two flatmates with two kinds of cards.

- **Task cards:** To do, Doing, Done.
- **Payment cards:** title, amount, who paid, month, status. Flow: Needs amount, Needs proof, To validate, Settled.
- **Recurring payments:** created each month by a scheduled job. Fixed (WiFi) spawns with the amount known. Variable (energy) spawns as "Needs amount".
- **Proof rule:** a card flagged proofRequired cannot move on until a receipt is uploaded.
- **Validation:** the other person validates cards at month-end, moving them to Settled.
- **Month-end view:** who owes whom.
- Status changes use buttons, not drag-and-drop.

## Tech stack

- TypeScript, Next.js (App Router), Server Actions with Zod validation
- Prisma and PostgreSQL
- Better Auth with Microsoft Entra sign-in, allow-list of two users. GitHub sign-in is the fallback if Entra takes more than about 45 minutes.
- Docker, one container for the app

## Azure services (core)

- Resource groups, with tags
- Container Registry (ACR) and Container Apps (the web app)
- Container App Jobs: monthly cron job and Prisma migrations
- PostgreSQL Flexible Server
- Blob Storage: private receipts container, short-lived SAS upload links
- Key Vault: connection string and auth secrets
- User-assigned managed identities and role assignments, no passwords in code
- Entra app registration
- Log Analytics and App Insights

## Terraform

- `azurerm` and `azuread` providers
- Remote state in Blob Storage with locking, in its own resource group
- Local modules: network, data, storage, app, monitoring, identity
- Budget alert
- `terraform destroy` at the end of each session for anything that bills hourly (notably Postgres)

## Environment

- Personal Azure free account ($200 credit, 30 days), subscription "Azure subscription 1", personal tenant
- Region: uksouth, or the nearest region that works
- Public endpoints locked down by firewall, RBAC and no anonymous blob access until the networking lesson
- Patterns may be borrowed from the work project's infrastructure, but no code is copied from it

## Learning method

Each lesson follows the same loop: concept, write, plan, apply and inspect in the portal, commit. Break and fix something deliberately now and then. One git commit per lesson. Building bottom-up means errors have a single cause.

## Lesson roadmap

1. Terraform basics: provider, backend, resource group, tags, budget alert
2. Variables, outputs, first module
3. Storage account and Blob container, role assignments
4. Managed identity and Key Vault, store and read a secret
5. Log Analytics and App Insights
6. Container Registry, build and push a hello-world image
7. Container Apps: environment, run the hello-world image
8. PostgreSQL Flexible Server, connect the app via Key Vault
9. Next.js app, Prisma, migrations as a Container App Job
10. Entra app registration and sign-in
11. Payments, receipt upload, monthly cron job
12. Private networking, then CI/CD with GitHub Actions and OIDC

Until lesson 9, a hello-world container stands in for the app.

## Out of scope for now

Email reminders (Communication Services), OCR on receipts (Document Intelligence), live board updates, Front Door, Redis, a failover copy of the stack, drag-and-drop, polished UI.

## Done when

- `terraform apply` builds everything from a clean state and `destroy` removes it.
- The learner can sign in, add a payment, upload proof and move it through its statuses.
- The monthly job creates the recurring cards.
- The learner can explain what each service is for and why it is there.

## Risks

- Next.js, Prisma and Azure all being new at once, so the app stays minimal and arrives late.
- Entra setup can take time, hence the GitHub fallback.
- Free-account region or SKU restrictions.
- Private networking and DNS is the hardest piece, so it comes last.
- Postgres bills hourly, so it is created late and destroyed at the end of each session.

## Progress so far

- Repo initialised at `Squared_Up/`.
- Azure CLI logged in with the personal account.
- Remote state bootstrap (resource group, storage account, `tfstate` container, role assignment, provider registrations) in progress, done by hand with `az` because Terraform needs it to exist first.
