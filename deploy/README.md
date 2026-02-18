# Ironclaw Akash Deployment

Deploy Ironclaw on Akash Network with automatic Docker builds via GitHub Actions.

## Prerequisites

1. **Enable GitHub Packages** (one-time setup):
   - Go to **Settings → Actions → General**
   - Under "Workflow permissions", select **Read and write permissions**
   - Save changes

2. **External PostgreSQL Database**: Set up a managed database with pgvector extension:
   - [Neon](https://neon.tech) (recommended, free tier)
   - [Supabase](https://supabase.com)
   - [Railway](https://railway.app)

3. **NEAR AI Session Token**: Get from [NEAR AI Cloud](https://cloud.near.ai)

4. **Akash Wallet**: Set up [Keplr](https://keplr.app) or [Leap](https://leapwallet.io)

---

## Quick Start

### Step 1: Build Docker Image (Automatic)

Push to main branch or create a version tag:

```bash
# Option A: Push to main (creates :latest and :sha-xxx tags)
git push origin main

# Option B: Create version tag (creates :v0.1.0 and :sha-xxx tags)
git tag v0.1.0
git push origin v0.1.0
```

Verify the image was published:
- Go to https://github.com/ToXMon/ironclaw/pkgs/container/ironclaw

### Step 2: Configure SDL

Edit `akash.yaml` and update:

| Variable | Description |
|----------|-------------|
| `image: ghcr.io/toxmon/ironclaw:v0.1.0` | Update to match your published tag |
| `DATABASE_URL` | PostgreSQL connection string |
| `NEARAI_SESSION_TOKEN` | From NEAR AI Cloud |
| `GATEWAY_AUTH_TOKEN` | Secure random token |

### Step 3: Deploy on Akash Console

1. Go to [console.akash.network](https://console.akash.network)
2. Connect wallet
3. Click **Create Deployment**
4. Paste your configured SDL
5. Select provider and confirm

---

## Available Docker Image Tags

| Tag | When Created | Use Case |
|-----|--------------|----------|
| `v0.1.0` | Version tag push | **Production (Akash requires this)** |
| `sha-abc1234` | Every build | Specific commit, debugging |
| `latest` | Main branch push | Development (not usable on Akash) |

> **Important**: Akash requires explicit version tags. Use `v0.1.0` style tags, NOT `:latest`.

---

## Files

| File | Description |
|------|-------------|
| `akash.yaml` | Simple deployment (external DB) - **Recommended** |
| `akash-fullstack.yaml` | Full stack with embedded PostgreSQL |

---

## Estimated Costs

| Deployment | Resources | Cost (approx) |
|------------|-----------|---------------|
| Simple | 1 CPU / 2Gi RAM / 5Gi | ~$1.50/month |
| Full Stack | 1.5 CPU / 3Gi RAM / 26Gi | ~$4/month |

---

## Troubleshooting

### Image Pull Errors

If you see "image not found" errors:
1. Verify the image exists: https://github.com/ToXMon/ironclaw/pkgs/container/ironclaw
2. Ensure you're using an explicit tag (e.g., `v0.1.0`), not `:latest`
3. Check that GitHub Actions workflow completed successfully

### Database Connection Issues

1. Verify your DATABASE_URL is correct
2. Ensure the database allows external connections
3. Check that pgvector extension is installed

### Container Crashes

Check logs in Akash Console for specific errors. Common issues:
- Missing required environment variables
- Invalid NEAR AI session token
- Database connection failures
