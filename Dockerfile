# Runs the official Argo CD MCP server over HTTP (streamable MCP).
# Upstream: https://github.com/argoproj-labs/mcp-for-argocd

FROM node:22-slim

ARG ARGOCD_MCP_VERSION=0.5.0

WORKDIR /app

RUN npm install -g "argocd-mcp@${ARGOCD_MCP_VERSION}" \
  && npm cache clean --force

USER node

EXPOSE 3002

ENV NODE_ENV=production

# HTTP transport for reverse proxies / MCP aggregators
ENTRYPOINT ["argocd-mcp"]
CMD ["http", "--port", "3002"]
