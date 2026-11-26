# Agent instructions

Arch Linux provisioning scripts under `src/scripts/`: Omarchy-style per-app install/config
scripts, orchestrated by `master.sh`, `run-install.sh`, and `run-config.sh`.
`run-install.sh` accepts `cli` (CLI-only) or `all` (CLI + desktop/native); npm
shortcuts are `npm run install:cli`, `npm run install:all`, `npm run config`, and
`npm run all`. The `src/dotfiles` submodule is maintained separately. **Never edit,
commit, or bump `src/dotfiles` from this repo** unless the user explicitly asks.
Consume it read-only via `link_dotfiles_xdg_config_dirs` in `config/dotfiles.sh`
(symlinks each `src/dotfiles/config/<app>/` under `~/.config/`) and targeted file copies.
`run-config.sh` and `master.sh` initialize/update submodules before running config.

## Repository standards

[garretpatten/github-standards](https://github.com/garretpatten/github-standards) is the
**canonical source of truth** for how every `garretpatten` repository must be structured
and maintained: license, security policy, contributing, community files, README
branding, CODEOWNERS, branch protection, pull requests, signed commits, Dependabot,
dependency hygiene, secret hygiene, workflow permissions, action pinning, repository
metadata, CI and quality, and exceptions.

- **Before starting any task**, read the current standards from the source of truth
  rather than from memory or a cached copy — they change over time. The standards index
  is at <https://github.com/garretpatten/github-standards#standards-files>; fetch raw
  files from
  `https://raw.githubusercontent.com/garretpatten/github-standards/master/<standard>.md`
  (via web fetch, `curl`, or `gh api`) and read every standard relevant to the task.
- **While working**, apply the standards to every change: workflows, dependency files,
  community files, repository metadata, and commit practices must conform to the
  standards as they exist at the time of the change.
- **When you detect drift** — this repository lagging behind a standard that changed —
  bring the repository back in line as part of normal work and call it out in your
  summary. If an update would be large or ambiguous, propose it instead of applying it
  silently.
- **Before finishing**, confirm the work satisfies the
  [verification](https://github.com/garretpatten/github-standards/blob/master/verification.md)
  standard and that local checks pass.
- For a full compliance review, use the `github-audit` skill, which audits a repository
  against these standards and reports numbered findings.

## Dotfiles submodule

`src/dotfiles/` is a **Git submodule** pinned to a commit of
[garretpatten/dotfiles](https://github.com/garretpatten/dotfiles).
Never edit files inside `src/dotfiles/` directly in this repository.

If a dotfiles change is needed:

1. Make the change in the `dotfiles` repository and push it.
2. In this repository, update the submodule:
   `cd src/dotfiles && git pull origin master && cd ../..`
3. Commit the submodule pointer change:
   `git add src/dotfiles && git commit -m "Bump dotfiles submodule"`

## Before you finish

**Do not consider shell or workflow work complete until ShellCheck and shfmt pass the same way CI does.**

From the repository root:

```bash
find src/scripts -name '*.sh' -print0 | xargs -0 shellcheck -x
find scripts -name '*.sh' -print0 | xargs -0 shellcheck -x
find .github/scripts -name '*.sh' -print0 | xargs -0 shellcheck -x
find src/scripts -name '*.sh' -print0 | xargs -0 shfmt -d
find scripts -name '*.sh' -print0 | xargs -0 shfmt -d
find .github/scripts -name '*.sh' -print0 | xargs -0 shfmt -d
```

Uses `.shellcheckrc` (`external-sources=true`, `source-path=SCRIPTDIR`).

`shfmt -d` exits non-zero on formatting drift; apply fixes with `shfmt -w` on the
files that fail. CI (`.github/workflows/quality-checks.yaml`) runs `shfmt -d`
with defaults over **changed** shell files only, and shfmt reads the repo-root
`.editorconfig`, which pins shell indentation to 4 spaces (`[*.sh]`
`indent_style = space`, `indent_size = 4`). Keep new shell code in that style; do
not switch files to shfmt's default tabs, and never replace the `.editorconfig`
section to "fix" a shfmt diff.

### ShellCheck conventions

- Leaf scripts under `install/` and `config/` should be plain commands; avoid
  `source utils.sh` and wrapper functions.
- Orchestrators (`master.sh`, `*/all.sh`) source `lib/env.sh`, `lib/run.sh`, and
  `# shellcheck source=...` for any other `lib/*.sh` they use.
- Do not use `A && B || C` for conditional execution (CI reports **SC2015**). Use
  `if` / `then` / `fi` instead.
- `|| true` on a single command is fine for best-effort provisioning.

### Other CI linters

`.github/workflows/quality-checks.yaml` also runs Prettier, markdownlint, and yamllint on
pull requests. Prettier and markdownlint are installed via `npm ci`; yamllint is a Python
tool. Run the relevant tools when you touch those file types:

```bash
npm ci
npx prettier --check .
npx markdownlint-cli2 "**/*.md" "#node_modules" "#src/dotfiles/node_modules"
yamllint .github .yamllint .markdownlint.yaml
```

The same workflow also runs shfmt on changed `*.sh`/`*.bash`/`*.zsh` files (see above)
and editorconfig-checker on every changed file because this repo has an `.editorconfig`
— keep changed files compliant with the properties set there.

### Test workflow

`.github/workflows/test-runner.yaml` runs four jobs in `archlinux:base-devel` Docker:

- `test-cli`: `run-install.sh cli` → `scripts/validate-installs-cli.sh`
- `test-config`: `run-config.sh` → `scripts/validate-config-only.sh`
- `test-full`: `run-install.sh all` → `scripts/validate-installs.sh`
- `test-master`: `master.sh` → `scripts/validate.sh` (full installs + config)

GNOME gsettings scripts no-op without an active GNOME session.

## Layout

| Path                                                        | Role                                                    |
| ----------------------------------------------------------- | ------------------------------------------------------- |
| `src/scripts/lib/env.sh`                                    | `PROJECT_ROOT`, `TEMP_DIR`                              |
| `src/scripts/lib/run.sh`                                    | `run_script` helper (forwards extra args)               |
| `src/scripts/lib/gnome-session.sh`                          | Skip GNOME config when not on GNOME                     |
| `src/scripts/lib/zsh-login.sh`                              | `.zshrc` pass-cli guard for provisioning                |
| `src/scripts/lib/git-submodules.sh`                         | Initialize/update submodules before config              |
| `src/scripts/lib/package-install.sh`                        | `install_pacman_packages_from_file` / AUR helpers       |
| `src/scripts/lib/package-maintain.sh`                       | pacman sync/cleanup helpers                             |
| `src/scripts/install/all.sh`                                | Full install orchestrator (`--cli` for CLI-only)        |
| `src/scripts/install/cli.sh`                                | Wrapper that runs `install/all.sh --cli`                |
| `src/scripts/install/packages/*.packages`                   | pacman package lists (one per line)                     |
| `src/scripts/install/packages/third-party-cli.packages`     | Docker/Node.js official packages                        |
| `src/scripts/install/packages/third-party-desktop.packages` | Brave/Bruno/Signal packages (some AUR)                  |
| `src/scripts/install/apps/pass-cli.sh`                      | Proton Pass CLI binary install                          |
| `src/scripts/install/`                                      | `packages/`, `apps/`, `dev/`, `shell/`, `post-install/` |
| `src/scripts/config/<category>/`                            | Dotfiles/GNOME/system config + `all.sh`                 |
| `scripts/lib/validate-installs-sections.sh`                 | Shared install validation sections                      |
| `scripts/lib/validate-config-sections.sh`                   | Shared config validation sections                       |
| `scripts/validate-installs-cli.sh`                          | Validate CLI-only install outcomes                      |
| `scripts/validate-installs.sh`                              | Validate full install outcomes                          |
| `scripts/validate-config-only.sh`                           | Validate config-only outcomes                           |
| `scripts/validate-config.sh`                                | Validate config after full install/master               |

## Product and safety constraints

- **Night Light** (`config/system/gnome-gsettings.sh`, GNOME only) conflicts with **Redshift** (`install/packages/productivity.packages`); on Hyprland use Redshift only.
- **Hyprland**: set `ARCH_SETUP_DESKTOP=hyprland` when auto-detection fails (TTY before compositor install); do not install `gnome-shell-extension-appindicator` unless on GNOME.
- **Security**: Verified downloads, least-privilege dirs, `config/security/ufw-rules.sh` UFW defaults.
- **User impact**: Logout/login for `docker` group / default shell / GNOME tweaks.
- **CI**: Set `ARCH_SETUP_CI=1` to skip flaky AUR targets (e.g. balena-etcher) in Docker.
- No secrets or machine-local paths committed.

## Commits

Only commit when the user asks. Do not commit secrets.

## GitHub Actions

Whenever a GitHub workflow is added, all GitHub Action pins in that workflow
should be updated to point to the full-length commit SHA of the most recent
release.
