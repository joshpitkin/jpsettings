# nvim + tmux Setup Guide
> Based on: [My Forever Dev Workflow](https://www.youtube.com/watch?v=_YaI2vDbk0o) (March 2024)
> ⚠️ Note: YouTube blocked transcript extraction. This guide is based on the video title/date, community knowledge of the same-era "forever workflow" stack, and best practices for the nvim+tmux setup as of 2024. Forge should cross-reference when scripting.

---

## The Stack

| Layer | Tool |
|---|---|
| Terminal | WezTerm (or Alacritty) |
| Multiplexer | tmux + tmux-sessionizer |
| Editor | Neovim (LazyVim or custom) |
| Git UI | lazygit |
| File nav | Oil.nvim or neo-tree |
| Fuzzy find | Telescope.nvim |
| Buffer jump | Harpoon v2 |
| LSP | nvim-lspconfig + mason.nvim |
| Completion | nvim-cmp |
| Theme | Catppuccin or TokyoNight |
| Shell | zsh + zoxide |

---

## 1. tmux — The Multiplexer Foundation

### Install
```bash
# Arch
sudo pacman -S tmux

# Plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### ~/.tmux.conf essentials
```bash
# Remap prefix to Ctrl-a or Ctrl-s
set -g prefix C-s
unbind C-b
bind-key C-s send-prefix

# Vim-style pane navigation
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

# Split panes with sane keys
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Start windows/panes at 1
set -g base-index 1
set -g pane-base-index 1

# Mouse support
set -g mouse on

# 256 color + true color
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'catppuccin/tmux'

# Auto-save sessions
set -g @continuum-restore 'on'

run '~/.tmux/plugins/tpm/tpm'
```

### Install plugins
In tmux: `prefix + I`

---

## 2. tmux-sessionizer — Project Jumping

The core of "forever workflow" — fuzzy-jump to any project, auto-creates tmux session.

```bash
# Save as ~/bin/tmux-sessionizer (chmod +x)
#!/usr/bin/env bash
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/projects ~/work ~/ -mindepth 1 -maxdepth 2 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
```

### Bind in zsh + tmux
```bash
# ~/.zshrc
bindkey -s ^f "tmux-sessionizer\n"

# ~/.tmux.conf
bind-key -r f run-shell "tmux neww ~/bin/tmux-sessionizer"
```

---

## 3. Neovim — LazyVim as the Base

### Install (Arch)
```bash
sudo pacman -S neovim
# Or latest:
sudo pacman -S neovim-git  # from AUR
```

### LazyVim bootstrap
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Install LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

Then launch nvim — LazyVim auto-installs everything.

### Key plugins (on top of LazyVim defaults)

**Harpoon v2** — mark files, jump instantly
```lua
-- lua/plugins/harpoon.lua
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
  end,
}
```

**Telescope** — fuzzy finding everything
```lua
-- Already in LazyVim, but key bindings:
-- <leader>ff  → find files
-- <leader>fg  → live grep
-- <leader>fb  → buffers
-- <leader>fh  → help tags
```

**vim-tmux-navigator** — seamless pane switching
```lua
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft", "TmuxNavigateDown",
    "TmuxNavigateUp", "TmuxNavigateRight",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
  },
}
```

**lazygit.nvim** — Git UI in a float
```lua
return {
  "kdheepak/lazygit.nvim",
  keys = { { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
}
```

---

## 4. WezTerm (optional terminal upgrade)

```lua
-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
return {
  font = wezterm.font("JetBrains Mono", { weight = "Regular" }),
  font_size = 14.0,
  color_scheme = "Catppuccin Mocha",
  enable_tab_bar = false,
  window_padding = { left = 4, right = 4, top = 4, bottom = 4 },
  -- Let tmux handle multiplexing
  default_prog = { "zsh", "-l" },
}
```

---

## 5. Shell — zsh + zoxide

```bash
sudo pacman -S zsh zoxide fzf ripgrep fd
chsh -s /bin/zsh

# ~/.zshrc additions
eval "$(zoxide init zsh)"  # smart cd
export PATH="$HOME/bin:$PATH"
alias vim="nvim"
alias v="nvim"
alias lg="lazygit"
```

---

## 6. Fonts

Install a Nerd Font for icons:
```bash
# Arch AUR
yay -S ttf-jetbrains-mono-nerd
# or
yay -S ttf-meslo-nerd-font-powerlevel10k
```

---

## Cheatsheet

| Action | Key |
|---|---|
| Jump to project | `Ctrl-f` (sessionizer) |
| New tmux session | `prefix + :new -s name` |
| Tmux pane nav | `Ctrl-h/j/k/l` |
| Nvim file search | `<leader>ff` |
| Nvim live grep | `<leader>fg` |
| Add to Harpoon | `<leader>a` |
| Harpoon menu | `Ctrl-e` |
| Open lazygit | `<leader>gg` |
| Tmux resurrect save | `prefix + Ctrl-s` |
| Tmux resurrect restore | `prefix + Ctrl-r` |

---

## Dotfiles / References

- [LazyVim starter](https://github.com/LazyVim/starter)
- [ThePrimeagen tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles) — the OG sessionizer script
- [Harpoon v2](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [WezTerm](https://wezfurlong.org/wezterm/)

> 🎬 Original video: https://www.youtube.com/watch?v=_YaI2vDbk0o
