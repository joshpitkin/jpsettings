# tmux Remote Resume — jp-hp-envy

Guide to picking up tmux sessions on another machine via SSH.

---

## Current Sessions (as of 2026-04-21)

| Name | Purpose |
|---|---|
| `codex-rxebate` | Codex coding agent, mid-task on rxebate |
| `openclaw-tui` | OpenClaw TUI (Clark) |
| `rxebate-dev` | rxebate-bot dev shell, branch: `feature/hcpc-processing-init` |

---

## How It Works

tmux sessions live **on the server** (jp-hp-envy), not on your client machine. When you close a terminal or SSH connection, the sessions keep running in the background. You can attach to them from anywhere.

**There is no sync between machines** — only one terminal is "active" in a session at a time. If you attach from your laptop, you're looking at the same session that was running on your desktop. They don't diverge; it's one session, one view.

---

## Attaching from Your Laptop

### 1. SSH in

```bash
ssh jp-hp-envy
# or via Tailscale IP if off-network:
ssh jpitkin@100.85.223.14
```

### 2. List sessions

```bash
tmux ls
```

### 3. Attach to a session

```bash
tmux attach -t rxebate-dev
tmux attach -t openclaw-tui
tmux attach -t codex-rxebate
```

### 4. Detach without killing (leave it running)

```
Ctrl+b, then d
```

---

## What Happens to Sessions on the Desktop

They keep running. If you're attached on your laptop and someone attaches on the desktop (or vice versa), **both terminals mirror each other in real time** — same view, same input. You can both type but it gets messy fast.

**Best practice:** detach from one machine before attaching on another.

---

## Quick Reference

| Action | Command |
|---|---|
| List sessions | `tmux ls` |
| Attach to session | `tmux attach -t <name>` |
| Detach (keep running) | `Ctrl+b d` |
| Rename a session | `tmux rename-session -t <old> <new>` |
| New named session | `tmux new-session -d -s <name>` |
| Kill a session | `tmux kill-session -t <name>` |
| Create new window | `Ctrl+b c` |
| Switch window | `Ctrl+b <number>` |
| Split pane horizontal | `Ctrl+b %` |
| Split pane vertical | `Ctrl+b "` |

---

## Tips

- **Name your sessions** — `tmux rename-session -t 4 my-project` makes it obvious what's what
- **Keep OpenClaw TUI running** — detach with `Ctrl+b d`, don't close it; it stays warm
- **Codex sessions** — if a coding agent is mid-prompt, check what it's waiting on before attaching; it may need a keypress to continue
- **SSH alias** — add to `~/.ssh/config` on your laptop for quick access:
  ```
  Host envy
    HostName 100.85.223.14
    User jpitkin
  ```
  Then just: `ssh envy` → `tmux attach -t rxebate-dev`
