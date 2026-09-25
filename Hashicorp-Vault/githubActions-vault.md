To integrate HashiCorp Vault with GitHub Actions, the most secure and modern approach is using OpenID Connect (OIDC)

GitHub Actions acts as an OIDC Identity Provider (IdP). Vault trusts GitHub's cryptographic identity tokens and exchanges them on-the-fly for short-lived Vault client tokens.

🔄 The OIDC Authentication Workflow
1. GitHub Actions requests a JWT: When a workflow runs, GitHub issues a short-lived OIDC JSON Web Token (JWT) to the runner.

2. Exchanged with Vault: The runner sends this JWT token to Vault using the official HashiCorp Vault Action.

3. Vault Validates Identity: Vault verifies the signature against GitHub's public keys (https://githubusercontent.com) and verifies your organization, repository, or branch names match your security constraints.
   
4. Secrets Returned: Vault returns a short-lived token, reads the requested secrets, and injects them securely into your runner environment

🛠️ Step 1 — Configure Vault to Trust GitHub OIDC

 Enable the JWT Auth Method -- $ vault auth enable jwt

2. Configure Vault with GitHub's OIDC Endpoint
   Tell Vault where to find GitHub's public cryptographic keys to validate incoming tokens.

   vault write auth/jwt/config \
    oidc_discovery_url="https://githubusercontent.com" \
    bound_issuer="https://githubusercontent.com"

3. Create a Vault Mapping Role
   
   Create a specific role that restricts access to a particular GitHub Organization, Repository, or Branch.

   vault write auth/jwt/role/github-actions-role \
    role_type="jwt" \
    bound_audiences="https://github.com" \
    user_claim="actor" \
    bound_claims_type="glob" \
    bound_claims={ \
        "repository": "your-org/your-repo", \
        "ref": "refs/heads/main" \
    } \
    policies="deploy-policy" \
    ttl=1h


Security Check: This ensures only workflows running on the main branch of your-org/your-repo can swap their identity for a Vault token.


📝 Step 2 — Fetch Secrets in your GitHub Actions Workflow


In your GitHub repository, you don't need to save a Vault Token. You only need to save your Vault server's public URL.
Use the official hashicorp/vault-action in your .github/workflows/deploy.yml file.

name: CI/CD Secret Fetch

on:
  push:
    branches: [ "main" ]

jobs:
  fetch-secrets:
    runs-on: ubuntu-latest
    
    # 1. CRITICAL: Grant permission to fetch the OIDC token
    permissions:
      id-token: write
      contents: read

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      # 2. Authenticate and retrieve secrets via OIDC
      - name: Import Secrets from Vault
        uses: hashicorp/vault-action@v3
        with:
          url: https://example.com
          method: jwt
          role: github-actions-role
          # Provide the vault path and map the keys to runner environment variables
          secrets: |
            secret/data/ci-cd/api-keys token | API_TOKEN ;
            secret/data/ci-cd/api-keys password | DB_PASSWORD

      # 3. Use the secrets securely
      - name: Deploy Application
        run: |
          # Secrets are automatically masked by GitHub Actions (shown as *** in logs)
          echo "Deploying using API Token..."
          curl -H "Authorization: Bearer ${{ env.API_TOKEN }}" https://example.com


🔒 Key Implementation Notes

permissions Block: The id-token: write configuration is mandatory. Without it, GitHub will refuse to generate the dynamic JWT token for your workflow runner.

Log Masking: The HashiCorp Vault Action automatically tells GitHub to mask all retrieved secrets. If a script accidentally tries to execute echo $API_TOKEN, GitHub will catch it and print *** in the build console.