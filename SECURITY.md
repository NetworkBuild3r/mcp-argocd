# Security

- **Never commit** Argo CD API tokens, kubeconfigs, or `.env` files.
- Treat `ARGOCD_API_TOKEN` like a password; use Kubernetes Secrets or a secret manager.
- Avoid `NODE_TLS_REJECT_UNAUTHORIZED=0` outside isolated dev environments.
- Prefer `MCP_READ_ONLY=true` if assistants only need read access.

Report sensitive issues privately to the repository owner.
