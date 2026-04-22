# Alacritty Launchers

Two launch scripts for Alacritty — one with tmux for local work, one plain zsh for SSH/remote sessions.

## Install

### 1. Copy the scripts

```bash
cp alacritty-tmux alacritty-plain ~/.local/bin/
chmod +x ~/.local/bin/alacritty-tmux ~/.local/bin/alacritty-plain
```

### 2. Install the desktop entries

```bash
cp alacritty-tmux.desktop alacritty-plain.desktop ~/.local/share/applications/
```

### 3. Set up keybinds (in your WM/DE)

Bind two shortcuts:

| Shortcut | Command |
|---|---|
| Primary (everyday) | `~/.local/bin/alacritty-tmux` |
| Secondary (SSH/remote) | `~/.local/bin/alacritty-plain` |

Example for **i3/Sway** in your config:
```
bindsym $mod+Return exec ~/.local/bin/alacritty-tmux
bindsym $mod+Shift+Return exec ~/.local/bin/alacritty-plain
```

## Why two launchers?

Nested tmux sessions are a pain — the outer tmux swallows your prefix key before the inner (remote) session sees it.

- **`alacritty-tmux`** — starts/attaches to a local tmux session named `main`. Use this for local dev work.
- **`alacritty-plain`** — launches plain zsh. Use this when you're going to SSH somewhere that already has a tmux session running.

This way you pick your intent at launch time and never end up fighting nested sessions.

## Nested tmux tip (if you do end up nested)

If you ever find yourself in a nested tmux anyway:

- **Press prefix twice** to send a command to the inner session
  - e.g. `Ctrl+b Ctrl+b d` detaches the *remote* session
  - `Ctrl+b d` detaches the *local* session

- Or give local/remote tmux **different prefixes** in `~/.tmux.conf`:
  ```
  # Local tmux — use Ctrl+a
  set-option -g prefix C-a
  bind C-a send-prefix
  ```
  Then `Ctrl+a` controls local, `Ctrl+b` controls remote.
