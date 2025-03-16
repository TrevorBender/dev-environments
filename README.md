# Dev environments

For example, t use specific version of node.

```direnv
use flake "github:TrevorBender/dev-environments?dir=node-22"
```

Use specific commit:

```direnv
use flake "github:TrevorBender/dev-environments?dir=node-22&rev=<commit-id>"
```

Alternatively, clone this repo, set an env var like `DEV_ENVIRONMENTS_HOME` and:

```direnv
use flake path:$DEV_ENVIRONMENTS_HOME/node-22
```

## Development environments as a template

```bash
nix flake init --template "github:TrevorBender/dev-environments?dir=<env-name"
```
