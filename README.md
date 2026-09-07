# Arch setup scripts

Provisioning for a personal Arch Linux desktop: install scripts under
`src/scripts/install/`, dotfiles and system config under `src/scripts/config/`,
orchestrated by `master.sh`.

```bash
npm run all             # install + config
npm run install:cli     # CLI-only install
npm run install:all     # full install (CLI + desktop/native)
npm run config          # config only (ensures submodules are up to date)
```

Direct bash equivalents (from `src/scripts/`):

```bash
bash master.sh          # install + config
bash run-install.sh cli # CLI-only install
bash run-install.sh all # full install (default)
bash run-config.sh      # config only
```

CI runs four jobs in `archlinux:base-devel` Docker:

- `test-cli`: `run-install.sh cli` → `validate-installs-cli.sh`
- `test-config`: `run-config.sh` → `validate-config-only.sh`
- `test-full`: `run-install.sh all` → `validate-installs.sh`
- `test-master`: `master.sh` → `validate.sh` (full installs + config)

Each validation script confirms the expected binaries/packages and config outcomes
for that run mode.

## Package manager preference

Each app uses one install path:

1. **pacman** when the package is in the official repositories
2. **yay/AUR** when pacman does not provide it (Brave, Bruno, Proton VPN/Pass, Zoom, Etcher)
3. **Flatpak** where appropriate
4. **Upstream binary** only when neither pacman, AUR, nor Flatpak applies (pass-cli, Cursor, Ollama)

## Install layout

| Path                          | Role                                                                   |
| ----------------------------- | ---------------------------------------------------------------------- |
| `install/preflight/`          | pacman sync, essentials (git, curl, base-devel, yay), timezone         |
| `install/all.sh`              | Full install orchestrator (`--cli` for CLI-only mode)                  |
| `install/cli.sh`              | Thin wrapper that runs `install/all.sh --cli`                          |
| `install/packages/*.packages` | One pacman package per line; installed by `install/all.sh`             |
| `install/repos/manifest`      | No-op placeholder (pacman repos live in `/etc/pacman.conf`)            |
| `install/snaps.txt`           | Snap packages (no-oped on Arch; AUR/Flatpak alternatives used instead) |
| `install/apps/`               | AUR installs, repo clones, and app-specific installers                 |
| `install/dev/`                | nvm, language stacks, Docker, Neovim, rustup, gems, pip/npm tools      |
| `install/shell/`              | Ghostty, Meslo font, Oh My Posh                                        |
| `install/post-install/`       | pacman cleanup, Docker service, tldr cache, completion banner          |

### Validation scripts (`scripts/`)

| Script                     | Use with                                   |
| -------------------------- | ------------------------------------------ |
| `validate-installs-cli.sh` | After `run-install.sh cli`                 |
| `validate-installs.sh`     | After `run-install.sh all` or `master.sh`  |
| `validate-config-only.sh`  | After `run-config.sh`                      |
| `validate-config.sh`       | After `master.sh` or full install + config |
| `validate.sh`              | After `master.sh` (installs + config)      |

### Package lists (`install/packages/`)

| File                           | Contents                                                                                     |
| ------------------------------ | -------------------------------------------------------------------------------------------- |
| `base.packages`                | CLI and security tools (bat, fzf, github-cli, jq, ripgrep, tealdeer, ufw, nmap, exiftool, …) |
| `shell.packages`               | zsh, tmux, fonts, plugins                                                                    |
| `media.packages`               | vlc, ffmpeg                                                                                  |
| `desktop.packages`             | GNOME Tweaks, shell extensions                                                               |
| `productivity.packages`        | LibreOffice, KeePassXC, Redshift, Flameshot                                                  |
| `lsp.packages`                 | Mason LSP runtimes (Go, Ruby, PHP, Lua, Docker, …)                                           |
| `lsp-optional.packages`        | Julia (optional)                                                                             |
| `dev.packages`                 | Neovim, Python                                                                               |
| `griffo.packages`              | yazi, lazygit, lazydocker                                                                    |
| `fastfetch.packages`           | fastfetch                                                                                    |
| `third-party-cli.packages`     | Docker, Node.js (official Arch packages; no external repo needed)                            |
| `third-party-desktop.packages` | Brave, Bruno, Signal Desktop, appindicator libs                                              |

### Apps (`install/apps/`)

Chrome, Proton VPN/Pass, Signal, Bruno, Zoom, Etcher, OWASP ZAP, ufw-docker,
Hacking git clones, pass-cli — each script handles its own AUR package or binary
when pacman lists are not enough.

### Development (`install/dev/`)

Node.js, nvm, Docker, rustup, Solargraph gem, Semgrep, Vue CLI, Cursor Agent CLI,
Ollama, language servers.

### Preflight & post-install

- pacman sync, essentials, timezone (America/New_York)
- Docker service enabled; UFW rules in `config/security/` (LocalSend, Docker DNS, ufw-docker)

### Snaps

Snap is not native to Arch. `install/apps/snaps.sh` and `lib/snap-install.sh` are
best-effort/no-op; equivalent apps are installed from the AUR or Flatpak.

## Explicitly not installed

These are **not** provisioned by this repo (remove from old notes or other dotfiles if you still expect them):

| Removed / never included                     | Notes                                                         |
| -------------------------------------------- | ------------------------------------------------------------- |
| **Sourcegraph CLI (`sg`)**                   | Removed; use Bruno or other tooling                           |
| **Spotify**                                  | Not provisioned; install manually if needed                   |
| GNOME apps via random snaps                  | Not provisioned                                               |
| Full IDE bundles (VS Code:, JetBrains, etc.) | Dotfiles may reference extensions; install editors separately |
| 1Password, Bitwarden, etc.                   | Use Proton Pass / KeePassXC paths above                       |

## Configuration (`src/scripts/config/`)

Symlinks and settings from `src/dotfiles` (submodule, read-only): `config/dotfiles.sh`
symlinks each `config/<app>/` tree under `~/.config/` (including `zsh/` for OS-specific
shell snippets); copies for shell home files and VS Code: settings. Covers Neovim, btop,
fastfetch, Kitty/Alacritty/Ghostty, Git, GNOME gsettings (skipped in CI without a GNOME
session), UFW defaults and rules (LocalSend, Docker DNS, ufw-docker), home directory layout.

See [AGENTS.md](AGENTS.md) for contributor conventions, ShellCheck, and CI details.
