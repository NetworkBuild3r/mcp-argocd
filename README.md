# mcp-argocd

**Docker & Kubernetes packaging** for the official [Argo CD MCP server](https://github.com/argoproj-labs/mcp-for-argocd) (`argocd-mcp` on npm). Use it to give AI assistants (Cursor, VS Code, Claude, etc.) tools to inspect and manage Argo CD applications.

This repo does **not** fork the MCP implementation—it pins and runs the upstream package in a reproducible way (same pattern as a typical production `node:22-slim` + `npx` deployment).

## Prerequisites

- [Argo CD](https://argo-cd.readthedocs.io/) with API access
- An [API token](https://argo-cd.readthedocs.io/en/stable/developer-guide/api-docs/#authorization)
- Node is only required locally if you use `npx` directly; Docker users do not need Node installed

## Quick start (Docker Compose)

```bash
cp .env.example .env
# Edit .env: ARGOCD_BASE_URL, ARGOCD_API_TOKEN

docker compose up --build
```

MCP HTTP endpoint: `http://localhost:3002/mcp` (streamable HTTP).

## Quick start (Kubernetes)

1. Edit `kubernetes/deployment.yaml`: set `ARGOCD_BASE_URL` to your Argo CD URL (in-cluster example: `http://argocd-server.argocd.svc.cluster.local` if TLS is handled elsewhere).
2. Create the token secret:

   ```bash
   kubectl apply -f kubernetes/namespace.yaml
   kubectl -n mcp-argocd create secret generic mcp-argocd-credentials \
     --from-literal=argocd_api_token='YOUR_TOKEN'
   ```

3. Build and push an image (or use your registry):

   ```bash
   docker build -t YOUR_REGISTRY/mcp-argocd:latest .
   docker push YOUR_REGISTRY/mcp-argocd:latest
   ```

   Update `image:` in `kubernetes/deployment.yaml` accordingly.

4. Apply:

   ```bash
   kubectl apply -f kubernetes/
   ```

5. Point your MCP client at `http://mcp-argocd.mcp-argocd.svc.cluster.local:3002/mcp` (from inside the cluster) or expose the Service via Ingress / LoadBalancer as you prefer.

## Cursor / IDE (stdio)

For local-only use, you can call the upstream package directly (no Docker):

```json
{
  "mcpServers": {
    "argocd": {
      "command": "npx",
      "args": ["argocd-mcp@0.5.0", "stdio"],
      "env": {
        "ARGOCD_BASE_URL": "https://your-argocd.example.com",
        "ARGOCD_API_TOKEN": "your-token"
      }
    }
  }
}
```

See the [upstream README](https://www.npmjs.com/package/argocd-mcp) for `NODE_TLS_REJECT_UNAUTHORIZED`, `MCP_READ_ONLY`, and the full tool list.

## Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `ARGOCD_BASE_URL` | Yes | Argo CD base URL (no trailing slash) |
| `ARGOCD_API_TOKEN` | Yes | API token |
| `NODE_TLS_REJECT_UNAUTHORIZED` | No | Set to `0` only for self-signed TLS (insecure) |
| `MCP_READ_ONLY` | No | Set to `true` to disable mutating tools |

## Upstream & license

- **Server implementation:** [argoproj-labs/mcp-for-argocd](https://github.com/argoproj-labs/mcp-for-argocd) (Apache-2.0)
- **This repo:** MIT (deployment files only). See [NOTICE](NOTICE).

## Contributing

Issues and PRs welcome for docs, Kubernetes examples, and CI. Do not commit real tokens or internal URLs.
