# install-arch.sh

Idempotent Arch Linux dev environment bootstrap — gets a fresh vanilla Arch machine to jp's full setup in one shot.

## Prerequisites

- Clean Arch Linux base install
- Regular user account with `sudo` access
- Internet connection
- `base-devel` and `git` (the script will install these if missing, but `sudo` must already work)

## What it installs

| Category | Tools |
|---|---|
| AUR helper | yay |
| Shell | zsh, oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting |
| Terminal | alacritty, starship, tmux, oh-my-tmux, zoxide |
| Dev runtimes | asdf → Node.js, Python, Go (all at `latest`); Rust via rustup |
| Node globals | pnpm, yarn |
| Editors | neovim, VSCode Insiders (AUR) |
| CLI utilities | git, gh, fzf, ripgrep, bat, eza, fd, stow, lnav, lazygit, lazydocker |
| Infrastructure | docker, docker-compose, tailscale |
| Fonts | ttf-nerd-fonts-symbols, CaskaydiaMono Nerd Font (ttf-cascadia-code-nerd) |

All steps are idempotent — safe to re-run if something fails partway through.

## How to run

```bash
git clone https://github.com/joshpitkin/jpsettings.git ~/jpsettings
bash ~/jpsettings/install-scripts/install-arch.sh
```

Or on a truly fresh machine before jpsettings is cloned:

```bash
curl -fsSL https://raw.githubusercontent.com/joshpitkin/jpsettings/main/install-scripts/install-arch.sh | bash
```

## After running

The script prints a full **Next Steps** checklist at the end. Summary:

1. Clone/use jpsettings dotfiles (`stow` targets for alacritty, starship, tmux, zshrc)
2. Run `bash ~/jpsettings/install-scripts/dotfiles/install-nvim-tmux-stack.sh`
3. `sudo tailscale up` — authenticate Tailscale
4. `gh auth login` — authenticate GitHub CLI
5. Add asdf sourcing + zsh init lines to `~/.zshrc` (see `~/jpsettings/zshrc/`)
6. Log out/in for docker group membership to take effect

## Notes

- **Docker + nftables**: The script applies an `iptables-legacy` symlink workaround. Arch uses nftables by default; Docker's iptables rules need the legacy backend or networking silently breaks.
- **VSCode Insiders**: Installed from AUR (`visual-studio-code-insiders`). If the AUR package build fails, the script warns with a manual download link and continues.
- **CaskaydiaMono font**: Installed from AUR (`ttf-cascadia-code-nerd`). Falls back to a warning with the manual install URL.
- **nvim+tmux nav stack**: Intentionally NOT installed here — run the dedicated script after dotfiles are applied.
- **asdf PATH**: If asdf was installed via AUR, it lives at `/opt/asdf-vm/asdf.sh`. If via git clone, `~/.asdf/asdf.sh`. Add the right one to your `~/.zshrc` (jpsettings/zshrc covers this).
