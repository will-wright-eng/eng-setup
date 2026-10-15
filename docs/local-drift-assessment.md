# Local Drift Assessment

Comparison of this repo against the machine it last built. Written
2026-10-15. Evidence comes from `brew bundle check`, `brew bundle dump
--file=-`, a diff of each tracked dotfile against `$HOME`, and command
counts from atuin history (count and last-used date only).

## Resolved

- **`make run` no longer deletes or overwrites local changes.** The
  playbook first compares the managed `.zshrc` block and each file in
  `managed_files` (`.gitconfig`, Zed, Ghostty) with the repo. If any
  differ, it prints the diffs, changes nothing, and fails with an
  override command per tag (`--tags <tag> -e allow_overwrite=true`, which
  backs up first and touches only that tag's files) or the command to
  copy the local file into the repo. The `|| true` that hid failures is
  gone.
- **Oh My Zsh install is non-destructive.** It runs after the `.zshrc`
  block is written, with `--unattended --keep-zshrc`, so it neither moves
  an existing `.zshrc` aside nor writes its template.
- **Playbooks run again.** `/opt/homebrew/bin/python3` became Python 3.15
  on 2026-10-12, and ansible-core 2.21 modules crash on it. Both
  playbooks now use `ansible_playbook_python`, the interpreter Ansible
  itself runs on.
- **`~` resolves consistently.** Task paths use `home_dir` from `$HOME`,
  as `macos.yml` already did. Before, `copy` resolved `~` from the user
  account while `stat` and `blockinfile` used `$HOME`.
- **`.gitconfig` copy path fixed.** It pointed at `ansible/configs/`,
  which doesn't exist.
- **The managed `.zshrc` block matches the local one**, plus the
  `lv` alias, a guarded `source ~/keys`, `gac`, and `~/.local/bin` on
  PATH.
- **uv setup fixed.** uv comes from the Brewfile, Homebrew installs its
  zsh completion, and the block puts `~/.local/bin` (uv tools) on PATH.
  The curl-install `post_tasks` message and the README TODO are gone.
- **Zed and Ghostty configs tracked.** `configs/zed/` holds
  `settings.json`, which now lists the installed extensions under
  `auto_install_extensions`, and `keymap.json`. `configs/ghostty/config`
  replaces the iTerm2 profile.
- **Dead files removed.** `scripts/zsh-functions.sh` and the README's
  `archive/` reference are gone.
- **Brewfile installs again.** It drops `sqlitestudio` and the removed
  `terraform` core formula. HashiCorp's `hashicorp/tap/terraform` is
  installed with `link: false`, because tfenv owns `bin/terraform`.
- **Brewfile matches daily use.** It adds 64 missing taps, formulae, and
  casks. It removes `cursor`, `ungoogled-chromium`, `raycast`,
  `modern-csv`, `gopanda`, `rar`, `opencode`, `ollama`,
  `docker-completion`, `doctl`, and `blueutil`. `codex` and
  `claude-code` stay as they are. `brew-dump` is gone.
- **tfswitch removed locally.** The formula, the `warrensbox/tap` cask,
  and the shadowed `~/bin/terraform` 1.5.5 symlink are gone. `terraform`
  still resolves to tfenv.
- **LazyVim bootstraps from upstream.** When `~/.config/lazyvim` is
  missing, the playbook clones the LazyVim starter and seeds
  `lazyvim.json` from `configs/lazyvim/`. An existing config is never
  touched.
- **Cursor configs and browser-extension tooling removed**, including
  their Make targets and README steps.

## Remaining

### P0: `make run` Stops on This Machine

A check-mode run against `$HOME` stops on three files:

- **`.gitconfig`: don't take the repo version.** It would drop
  `user.signingkey`, `gpg.program`, and the `wl` alias. Fix the repo
  side instead: add `wl = worktree list` and
  `[gpg] program = /opt/homebrew/bin/gpg` to `configs/.gitconfig`, add
  `[include] path = ~/.gitconfig.local`, move the signing key into
  `~/.gitconfig.local`, and have `scripts/setup-github-gpg.sh` write it
  there with `git config --file`.
- **`.zshrc`: taking the repo version is safe.** The diff adds the `lv`
  alias and `~/.local/bin` to PATH, guards `source ~/keys`, and moves
  `gac` into the block. Then delete the duplicate `gac` and `lv`
  definitions below the block.
- **Zed `settings.json`: taking the repo version is safe.** The only
  difference is the added `auto_install_extensions` list.

### P1: Brewfile Follow-ups

- **tfswitch leftovers.** `warrensbox/tap` is still tapped with nothing
  installed from it, `~/.terraform.versions` holds 69 MB of tfswitch
  downloads, and `.zshrc` still adds the now-empty `~/bin` to PATH.
- **Kubernetes.** The Brewfile comments these out, but `k9s`, `kubectx`,
  and `kustomize` are still installed (last used 2025-09).

### P2: Stale Content in the Repo

- **Zed's agent defaults to an ollama model**, but ollama is no longer in
  the Brewfile. Point it at another provider, or add ollama back.
- **`scripts/loc.sh`** overlaps with `scc` and `loch`.
- **The `.zshrc` block still has `zshconfig` and `ohmyzsh` aliases** that
  call `mate`, which is not installed.
- **`make setup-homebrew`** appends to `~/.zprofile` with `>>` on every
  run, which is why `brew shellenv` appears twice there.
- **Playbook lint.** ansible-lint's production profile flags the
  existing style (short module names, `yes`/`no`, unnamed play). The
  LazyVim clone adds `latest[git]` because it isn't pinned.

### P2: Local Cleanup

- **Two uv installs.** The standalone `~/.local/bin/uv` (0.12.20) shadows
  Homebrew's (0.13.1). Delete `~/.local/bin/uv` and `uvx`, and remove
  the `. "$HOME/.local/bin/env"` line below the block, which the
  standalone installer added.
- **Dead lines outside the `.zshrc` block:** conda init (last used
  2025-03), PATH entries for `openjdk@11`, `node@20`, `node@22`, and
  `postgresql@15`, the pnpm and rye blocks, a duplicate `fpath+=`, a
  second `compinit`, and a duplicate `alias c`.
- **`~/.zprofile`** sources OrbStack's init (the app is gone).
- **Leftover Cursor binaries** at `~/.local/bin/cursor-agent` and
  `~/.local/bin/agent`.

### P3: Worth Considering

- **Global language tools in the Brewfile.** `brew bundle` supports
  `uv`, `go`, `cargo`, and `npm` entries for `ruff`, `vulture`, `gopls`,
  `golangci-lint`, `staticcheck`, `tokei`, and `mermaid-cli`. Drop the
  `go install` copy of `hc`, since the tap provides it.
- **Claude Code config.** `~/.claude/CLAUDE.md` and `settings.json` are
  untracked. Skills already come from `will-wright-eng/skills`.
- **RemoveMacAI decisions are not applied.** None of the 19 keys in
  `removemacai-learnings.md` are set locally.

## Out of Scope

- Project-specific formulae: `apache-spark`, `portaudio`, `go-jsonnet`,
  `jsonnet-bundler`, `dive`, `gonzo`, `cliclick`, `nmap`, `ack`.
- Apps in `/Applications` that look employer-managed (endpoint security,
  VPN, HR tools).
- Firefox and Tailscale, which stay installed outside Homebrew.
- Secrets. Keep sourcing them from an untracked file.

## References

- [Homebrew Bundle and Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [hashicorp/homebrew-tap](https://github.com/hashicorp/homebrew-tap)
- [tfutils/tfenv](https://github.com/tfutils/tfenv)
- [ansible.builtin.blockinfile](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/blockinfile_module.html)
- [ansible.builtin.copy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)
- [Oh My Zsh unattended install](https://github.com/ohmyzsh/ohmyzsh#unattended-install)
- [LazyVim installation](https://www.lazyvim.org/installation)
- [git-config: Includes](https://git-scm.com/docs/git-config#_includes)
- [Zed: auto_install_extensions](https://zed.dev/docs/configuring-zed#auto-install-extensions)
- [uv installation](https://docs.astral.sh/uv/getting-started/installation/)
- [worktrunk](https://worktrunk.dev)
