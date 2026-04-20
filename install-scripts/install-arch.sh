#!/usr/bin/env bash
# install-arch.sh — Idempotent Arch Linux dev environment bootstrap
# For a fresh vanilla Arch install. Run as a regular user with sudo access.
#
# Usage: bash install-arch.sh
# Requires: base Arch install, sudo, internet connection

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Color helpers
# ─────────────────────────────────────────────────────────────────────────────

RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"

info()  { echo -e "${CYAN}${BOLD}[INFO]${RESET}  $*"; }
ok()    { echo -e "${GREEN}${BOLD}[ OK ]${RESET}  $*"; }
warn()  { echo -e "${YELLOW}${BOLD}[WARN]${RESET}  $*"; }
error() { echo -e "${RED}${BOLD}[ERR ]${RESET}  $*" >&2; }

# ─────────────────────────────────────────────────────────────────────────────
# Guards
# ─────────────────────────────────────────────────────────────────────────────

if [[ $EUID -eq 0 ]]; then
  error "Do not run this script as root. Run as your regular user (with sudo access)."
  exit 1
fi

if ! command -v sudo &>/dev/null; then
  error "sudo not found. Install it and add yourself to the sudoers group first."
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 1: System update
# ─────────────────────────────────────────────────────────────────────────────

info "=== Updating system ==="
sudo pacman -Syu --noconfirm
ok "System up to date."

# ─────────────────────────────────────────────────────────────────────────────
# Section 2: Base build tools (needed for yay and AUR packages)
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing base-devel and git (AUR prerequisites) ==="
sudo pacman -S --noconfirm --needed base-devel git curl wget
ok "Base build tools ready."

# ─────────────────────────────────────────────────────────────────────────────
# Section 3: AUR helper — yay
# ─────────────────────────────────────────────────────────────────────────────

info "=== Bootstrapping yay (AUR helper) ==="
if command -v yay &>/dev/null; then
  ok "yay already installed — skipping."
else
  info "Cloning yay into /tmp/yay..."
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  ok "yay installed."
fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 4: Shell — zsh + oh-my-zsh + plugins
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing zsh ==="
sudo pacman -S --noconfirm --needed zsh
ok "zsh installed."

info "=== Setting zsh as default shell ==="
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" == "/usr/bin/zsh" ]]; then
  ok "zsh is already the default shell."
else
  chsh -s /usr/bin/zsh
  ok "Default shell set to zsh (takes effect on next login)."
fi

info "=== Installing oh-my-zsh ==="
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  ok "oh-my-zsh already installed — skipping."
else
  # RUNZSH=no prevents it from launching an interactive shell; CHSH=no since we already did it
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "oh-my-zsh installed."
fi

OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

info "=== Installing oh-my-zsh plugin: zsh-autosuggestions ==="
ZSH_AUTOSUGG_DIR="$OMZ_CUSTOM/plugins/zsh-autosuggestions"
if [[ -d "$ZSH_AUTOSUGG_DIR" ]]; then
  ok "zsh-autosuggestions already present — skipping."
else
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGG_DIR"
  ok "zsh-autosuggestions installed."
fi

info "=== Installing oh-my-zsh plugin: zsh-syntax-highlighting ==="
ZSH_SYNHI_DIR="$OMZ_CUSTOM/plugins/zsh-syntax-highlighting"
if [[ -d "$ZSH_SYNHI_DIR" ]]; then
  ok "zsh-syntax-highlighting already present — skipping."
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_SYNHI_DIR"
  ok "zsh-syntax-highlighting installed."
fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 5: Terminal — alacritty, starship, tmux, oh-my-tmux, zoxide
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing alacritty ==="
sudo pacman -S --noconfirm --needed alacritty
ok "alacritty installed."

info "=== Installing starship ==="
if sudo pacman -S --noconfirm --needed starship 2>/dev/null; then
  ok "starship installed via pacman."
else
  warn "starship not in pacman repos — trying AUR..."
  yay -S --noconfirm --needed starship
  ok "starship installed via AUR."
fi

info "=== Installing tmux ==="
sudo pacman -S --noconfirm --needed tmux
ok "tmux installed."

info "=== Setting up oh-my-tmux ==="
TMUX_CONF_DIR="$HOME/.config/tmux"
if [[ -d "$TMUX_CONF_DIR/.git" ]]; then
  ok "oh-my-tmux already present — skipping clone."
else
  mkdir -p "$HOME/.config"
  git clone https://github.com/gpakosz/.tmux "$TMUX_CONF_DIR"
  ok "oh-my-tmux cloned."
fi

# Symlink .tmux.conf → oh-my-tmux's config
TMUX_CONF_LINK="$HOME/.tmux.conf"
TMUX_CONF_TARGET="$TMUX_CONF_DIR/.tmux.conf"
if [[ -L "$TMUX_CONF_LINK" && "$(readlink "$TMUX_CONF_LINK")" == "$TMUX_CONF_TARGET" ]]; then
  ok "~/.tmux.conf symlink already correct."
elif [[ -e "$TMUX_CONF_LINK" && ! -L "$TMUX_CONF_LINK" ]]; then
  warn "~/.tmux.conf exists as a regular file — backing up to ~/.tmux.conf.bak"
  mv "$TMUX_CONF_LINK" "${TMUX_CONF_LINK}.bak"
  ln -sf "$TMUX_CONF_TARGET" "$TMUX_CONF_LINK"
  ok "~/.tmux.conf symlinked (old file backed up)."
else
  ln -sf "$TMUX_CONF_TARGET" "$TMUX_CONF_LINK"
  ok "~/.tmux.conf symlinked."
fi

# Create .tmux.conf.local from example if not present
TMUX_LOCAL="$HOME/.tmux.conf.local"
TMUX_LOCAL_EXAMPLE="$TMUX_CONF_DIR/.tmux.conf.local"
if [[ -e "$TMUX_LOCAL" ]]; then
  ok "~/.tmux.conf.local already exists — skipping."
elif [[ -f "$TMUX_LOCAL_EXAMPLE" ]]; then
  cp "$TMUX_LOCAL_EXAMPLE" "$TMUX_LOCAL"
  ok "~/.tmux.conf.local created from oh-my-tmux example."
else
  touch "$TMUX_LOCAL"
  ok "~/.tmux.conf.local created (empty — no example found in repo)."
fi

info "=== Installing zoxide ==="
sudo pacman -S --noconfirm --needed zoxide
ok "zoxide installed."

# ─────────────────────────────────────────────────────────────────────────────
# Section 6: CLI Utilities
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing CLI utilities ==="
sudo pacman -S --noconfirm --needed \
  git \
  github-cli \
  fzf \
  ripgrep \
  bat \
  eza \
  fd \
  stow \
  lnav \
  lazygit
ok "CLI utilities installed."

info "=== Installing lazydocker (AUR) ==="
if yay -Qi lazydocker &>/dev/null 2>&1; then
  ok "lazydocker already installed — skipping."
else
  yay -S --noconfirm --needed lazydocker
  ok "lazydocker installed."
fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 7: Editors — neovim + vscode-insiders
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing neovim ==="
sudo pacman -S --noconfirm --needed neovim
ok "neovim installed."

info "=== Installing VSCode Insiders (AUR) ==="
if yay -Qi visual-studio-code-insiders &>/dev/null 2>&1; then
  ok "visual-studio-code-insiders already installed — skipping."
else
  if yay -S --noconfirm --needed visual-studio-code-insiders 2>/dev/null; then
    ok "visual-studio-code-insiders installed."
  else
    warn "visual-studio-code-insiders not found in AUR or build failed."
    warn "Manual install: https://code.visualstudio.com/insiders/ (download .tar.gz or .rpm and adapt)"
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 8: Infrastructure — Docker, Docker Compose, iptables workaround
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing Docker and Docker Compose ==="
sudo pacman -S --noconfirm --needed docker docker-compose
ok "Docker and Docker Compose installed."

info "=== Enabling and starting Docker daemon ==="
sudo systemctl enable --now docker
ok "Docker daemon enabled and started."

info "=== Adding $USER to docker group ==="
if id -nG "$USER" | grep -qw docker; then
  ok "$USER is already in the docker group."
else
  sudo usermod -aG docker "$USER"
  warn "$USER added to docker group. You'll need to log out and back in (or run 'newgrp docker') for this to take effect."
fi

info "=== Applying iptables-legacy workaround for Docker on Arch (nftables issue) ==="
# Arch Linux uses nftables by default, but Docker's iptables rules target the legacy
# iptables backend. Without this symlink, Docker networking rules silently fail on
# systems where nftables is the active firewall manager. Pointing /usr/local/bin/iptables
# to iptables-legacy ensures Docker finds a compatible backend.
if [[ -L /usr/local/bin/iptables && "$(readlink /usr/local/bin/iptables)" == "/usr/bin/iptables-legacy" ]]; then
  ok "iptables-legacy symlink already in place."
elif command -v iptables-legacy &>/dev/null; then
  sudo ln -sf /usr/bin/iptables-legacy /usr/local/bin/iptables
  ok "iptables-legacy symlink created at /usr/local/bin/iptables."
else
  warn "iptables-legacy not found. Install iptables package or enable iptables service instead of nftables."
fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 9: Tailscale
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing Tailscale ==="
sudo pacman -S --noconfirm --needed tailscale
sudo systemctl enable --now tailscaled
ok "Tailscale installed and daemon enabled. (Run 'sudo tailscale up' to authenticate.)"

# ─────────────────────────────────────────────────────────────────────────────
# Section 10: Dev runtimes — asdf
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing asdf version manager ==="

# Prefer asdf-vm from AUR; fall back to git clone
if command -v asdf &>/dev/null; then
  ok "asdf already installed — skipping."
else
  if yay -S --noconfirm --needed asdf-vm 2>/dev/null; then
    ok "asdf installed via AUR (asdf-vm)."
    # asdf-vm AUR package typically sources via /opt/asdf-vm/asdf.sh — source it now for the rest of this script
    if [[ -f /opt/asdf-vm/asdf.sh ]]; then
      # shellcheck source=/dev/null
      source /opt/asdf-vm/asdf.sh
    fi
  else
    warn "asdf-vm AUR package unavailable — cloning from GitHub..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch "$(git ls-remote --tags https://github.com/asdf-vm/asdf.git | grep -o 'v[0-9]*\.[0-9]*\.[0-9]*$' | sort -V | tail -1)"
    # shellcheck source=/dev/null
    source "$HOME/.asdf/asdf.sh"
    ok "asdf installed via git clone to ~/.asdf."
  fi
fi

# Ensure asdf is sourced for the remainder of this script session
if ! command -v asdf &>/dev/null; then
  # Try common source locations
  for asdf_sh in \
    /opt/asdf-vm/asdf.sh \
    "$HOME/.asdf/asdf.sh"; do
    if [[ -f "$asdf_sh" ]]; then
      # shellcheck source=/dev/null
      source "$asdf_sh"
      break
    fi
  done
fi

if ! command -v asdf &>/dev/null; then
  warn "asdf is not in PATH after install attempts. Skipping asdf-managed runtimes."
  warn "You may need to add asdf sourcing to ~/.zshrc and re-run this script."
  ASDF_OK=false
else
  ASDF_OK=true
fi

# ─── asdf plugins + runtimes ──────────────────────────────────────────────────

if [[ "$ASDF_OK" == "true" ]]; then

  # --- Node.js ---
  info "=== asdf: nodejs ==="
  if asdf plugin list 2>/dev/null | grep -q "^nodejs$"; then
    ok "asdf nodejs plugin already added."
  else
    asdf plugin add nodejs
    ok "asdf nodejs plugin added."
  fi
  if asdf current nodejs &>/dev/null; then
    ok "asdf nodejs version already set — skipping install."
  else
    asdf install nodejs latest
    asdf global nodejs latest
    ok "asdf nodejs (latest) installed and set as global."
  fi

  # --- Python ---
  info "=== asdf: python ==="
  # python build deps
  sudo pacman -S --noconfirm --needed \
    openssl zlib bzip2 readline sqlite libffi xz tk
  if asdf plugin list 2>/dev/null | grep -q "^python$"; then
    ok "asdf python plugin already added."
  else
    asdf plugin add python
    ok "asdf python plugin added."
  fi
  if asdf current python &>/dev/null; then
    ok "asdf python version already set — skipping install."
  else
    asdf install python latest
    asdf global python latest
    ok "asdf python (latest) installed and set as global."
  fi

  # --- Go ---
  info "=== asdf: golang ==="
  if asdf plugin list 2>/dev/null | grep -q "^golang$"; then
    ok "asdf golang plugin already added."
  else
    asdf plugin add golang
    ok "asdf golang plugin added."
  fi
  if asdf current golang &>/dev/null; then
    ok "asdf golang version already set — skipping install."
  else
    asdf install golang latest
    asdf global golang latest
    ok "asdf golang (latest) installed and set as global."
  fi

  # --- pnpm (after node) ---
  info "=== Installing pnpm (via npm) ==="
  if command -v pnpm &>/dev/null; then
    ok "pnpm already installed — skipping."
  else
    npm install -g pnpm
    ok "pnpm installed."
  fi

  # --- yarn (after node) ---
  info "=== Installing yarn (via npm) ==="
  if command -v yarn &>/dev/null; then
    ok "yarn already installed — skipping."
  else
    npm install -g yarn
    ok "yarn installed."
  fi

fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 11: Rust via rustup
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing Rust via rustup ==="
if command -v rustup &>/dev/null; then
  ok "rustup already installed — skipping."
elif command -v cargo &>/dev/null; then
  ok "cargo already present (rust may be installed another way) — skipping rustup."
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # Source cargo env for remainder of script
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
  ok "Rust installed via rustup."
fi

# ─────────────────────────────────────────────────────────────────────────────
# Section 12: Fonts
# ─────────────────────────────────────────────────────────────────────────────

info "=== Installing Nerd Fonts symbols (pacman) ==="
sudo pacman -S --noconfirm --needed ttf-nerd-fonts-symbols
ok "ttf-nerd-fonts-symbols installed."

info "=== Installing CaskaydiaMono Nerd Font ==="
if yay -Qi ttf-cascadia-code-nerd &>/dev/null 2>&1; then
  ok "ttf-cascadia-code-nerd already installed — skipping."
else
  if yay -S --noconfirm --needed ttf-cascadia-code-nerd 2>/dev/null; then
    ok "ttf-cascadia-code-nerd installed via AUR."
  else
    warn "ttf-cascadia-code-nerd not found in AUR or build failed."
    warn "Manual install: https://www.nerdfonts.com/font-downloads — download CascadiaMono and place in ~/.local/share/fonts/, then run 'fc-cache -fv'."
  fi
fi

# Refresh font cache
if command -v fc-cache &>/dev/null; then
  fc-cache -fv &>/dev/null
  ok "Font cache refreshed."
fi

# ─────────────────────────────────────────────────────────────────────────────
# DONE — Next Steps
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  install-arch.sh complete!${RESET}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
echo ""
echo -e "${CYAN}${BOLD}=== Next Steps ===${RESET}"
echo ""
echo -e "  1. Clone jpsettings (if not already done):"
echo -e "     ${BOLD}git clone https://github.com/joshpitkin/jpsettings.git ~/jpsettings${RESET}"
echo ""
echo -e "  2. Apply dotfiles from jpsettings:"
echo -e "     ${BOLD}cd ~/jpsettings && stow alacritty starship tmux zshrc${RESET}"
echo -e "     (or follow the dotfiles README for exact stow targets)"
echo ""
echo -e "  3. Run the nvim + tmux navigation stack installer:"
echo -e "     ${BOLD}bash ~/jpsettings/install-scripts/dotfiles/install-nvim-tmux-stack.sh${RESET}"
echo ""
echo -e "  4. Authenticate Tailscale:"
echo -e "     ${BOLD}sudo tailscale up${RESET}"
echo ""
echo -e "  5. Authenticate GitHub CLI:"
echo -e "     ${BOLD}gh auth login${RESET}"
echo ""
echo -e "  6. Add asdf sourcing + zsh additions to ~/.zshrc:"
echo -e "     See ${BOLD}~/jpsettings/zshrc/${RESET} for the canonical config."
echo -e "     Typical additions:"
echo -e "       ${BOLD}. /opt/asdf-vm/asdf.sh${RESET}        # if installed via AUR"
echo -e "       ${BOLD}. \$HOME/.asdf/asdf.sh${RESET}         # if installed via git clone"
echo -e "       ${BOLD}eval \"\$(zoxide init zsh)\"${RESET}"
echo -e "       ${BOLD}eval \"\$(starship init zsh)\"${RESET}"
echo ""
echo -e "  7. ${YELLOW}${BOLD}REMINDER:${RESET} Log out and back in (or run 'newgrp docker') for"
echo -e "     the docker group membership to take effect."
echo ""
echo -e "  8. ${YELLOW}${BOLD}REMINDER:${RESET} Reopen your terminal in zsh to get your new shell."
echo ""
echo -e "${GREEN}${BOLD}Done. Welcome home.${RESET}"
echo ""
