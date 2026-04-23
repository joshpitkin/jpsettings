#!/usr/bin/env bash
# install-nvim-tmux-stack.sh
# Sets up the full nvim + tmux dev stack on a fresh Arch Linux machine.
# Based on jp's "forever workflow" setup.
# Usage: bash install-nvim-tmux-stack.sh

set -e

echo "==> Installing packages..."
sudo pacman -S --needed --noconfirm \
  neovim tmux fzf ripgrep fd zsh zoxide lazygit

echo "==> Installing Nerd Font (JetBrains Mono)..."
yay -S --needed --noconfirm ttf-jetbrains-mono-nerd 2>/dev/null \
  || echo "  [skip] yay not available — install ttf-jetbrains-mono-nerd manually or via your AUR helper"

# ── tmux ──────────────────────────────────────────────────────────────────────
echo "==> Setting up tmux..."

# oh-my-tmux
if [ ! -d "$HOME/.tmux" ]; then
  git clone --depth 1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
  ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
else
  echo "  [skip] ~/.tmux already exists"
fi

# copy tmux.conf.local from this repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/../tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
echo "  Copied tmux.conf.local"

# TPM
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "  Installed TPM — run prefix+I inside tmux to install plugins"
else
  echo "  [skip] TPM already installed"
fi

# ── tmux-sessionizer ──────────────────────────────────────────────────────────
echo "==> Installing tmux-sessionizer..."
mkdir -p "$HOME/bin"
cp "$SCRIPT_DIR/../tmux/tmux-sessionizer.sh" "$HOME/bin/tmux-sessionizer"
chmod +x "$HOME/bin/tmux-sessionizer"
echo "  Installed to ~/bin/tmux-sessionizer"

# ── Neovim / LazyVim ──────────────────────────────────────────────────────────
echo "==> Setting up Neovim (LazyVim)..."

if [ -d "$HOME/.config/nvim" ]; then
  echo "  Existing nvim config found — backing up to ~/.config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"

# Copy jp's nvim extras (init.lua, harpoon, etc.)
if [ -d "$SCRIPT_DIR/../nvim" ]; then
  cp -r "$SCRIPT_DIR/../nvim/." "$HOME/.config/nvim/"
  echo "  Copied nvim config from repo"
fi

echo "  LazyVim installed — launch nvim once to auto-install plugins"

# ── zsh setup ─────────────────────────────────────────────────────────────────
echo "==> Configuring zsh..."

if ! grep -q 'zoxide init zsh' "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" << 'EOF'

# ── jp dev stack ──────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"
export PATH="$HOME/bin:$PATH"
alias vim="nvim"
alias v="nvim"
alias lg="lazygit"
bindkey -s ^f "tmux-sessionizer\n"
EOF
  echo "  Added zsh config block to ~/.zshrc"
else
  echo "  [skip] zsh config already present"
fi

# Set zsh as default shell
if [ "$SHELL" != "/bin/zsh" ]; then
  chsh -s /bin/zsh
  echo "  Set zsh as default shell (re-login to apply)"
fi

echo ""
echo "✅ Done! Next steps:"
echo "  1. Start tmux, then hit prefix+I to install plugins"
echo "  2. Launch nvim — LazyVim will auto-install everything"
echo "  3. Restart your shell (or: source ~/.zshrc)"
echo "  4. Test Ctrl-f in zsh or tmux for the sessionizer"
