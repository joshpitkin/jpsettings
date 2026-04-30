# OpenCode Configuration

oh-my-opencode-slim setup with GitHub Copilot and OpenRouter presets.

---

## What Changed from oh-my-openagent

**oh-my-openagent was removed.** It was burning through tokens because `ANTHROPIC_BASE_URL` was set to `https://openrouter.ai/api`, which proxied every Anthropic model call through OpenRouter at full pay-per-token cost. oh-my-opencode-slim delegates to specialist sub-agents more sparingly by design and uses GitHub Copilot's per-seat billing instead.

**oh-my-opencode-slim is now the sole plugin.** It provides 7 specialist agents (Orchestrator, Oracle, Explorer, Librarian, Designer, Fixer, and optional Council) with routing handled automatically by the Orchestrator.

---

## Prerequisites

| Credential | How it's set |
|---|---|
| GitHub Copilot | `opencode auth login` (OAuth) |
| OpenRouter | `OPENROUTER_API_KEY` env var |
| GitHub PAT (MCP) | `~/.config/opencode/.secrets/github-pat` |

> **ANTHROPIC_BASE_URL note:** If `ANTHROPIC_BASE_URL=https://openrouter.ai/api` is set in your environment, any `anthropic/` prefix calls will route through OpenRouter (not GitHub Copilot). All GitHub Copilot presets use `github-copilot/` prefix and are **not affected**. OpenRouter presets use `openrouter/` prefix explicitly.

---

## Preset Summary

Switch presets at runtime inside opencode: `/preset <name>`

### GitHub Copilot Presets

All three use GitHub Copilot Business ($19/user) with per-AI-credit billing.  
Multipliers shown are **post-June 1, 2026** (when the new model multiplier table takes effect).

#### `copilot-lean` — Budget (recommended default multiplier ~0.33x)

| Agent | Model | Multiplier |
|---|---|---|
| orchestrator | `gpt-4.1` (OpenAI) | **0.33x** |
| oracle | `gemini-2.5-pro` (Google) | **1x** ← best-value reasoning, stays 1x |
| explorer | `gpt-5-mini` (OpenAI) | 0.33x |
| librarian | `claude-haiku-4.5` (Anthropic) | 0.33x |
| designer | `gemini-3-flash-preview` (Google) | 0.33x |
| fixer | `gpt-4.1` (OpenAI) | 0.33x |

Use for: routine coding, quick iterations, token-conscious sessions.

---

#### `copilot-balanced` — Sweet Spot ⭐ (active default)

Exploits the two models that **stay at 1x** after June 1 while equivalents like Claude Sonnet 4.6 jump to 6–9x:

| Agent | Model | Multiplier |
|---|---|---|
| orchestrator | `claude-sonnet-4` (Anthropic) | **1x** ← stays 1x! (claude-sonnet-4.6 = 9x) |
| oracle | `gemini-2.5-pro` (Google) | **1x** ← stays 1x! |
| explorer | `gpt-5-mini` (OpenAI) | 0.33x |
| librarian | `gpt-4.1` (OpenAI) | 0.33x |
| designer | `gemini-3-flash-preview` (Google) | 0.33x |
| fixer | `gpt-5.2` (OpenAI) | **3x** ← step-up for code quality |

Use for: everyday complex development work. Best credits-per-quality ratio post-June.

---

#### `copilot-power` — Premium

| Agent | Model | Multiplier |
|---|---|---|
| orchestrator | `gpt-5.5` (OpenAI) | token-based ($5/$30/M) |
| oracle | `claude-sonnet-4.6` (Anthropic) | **6x** (high variant) |
| explorer | `gpt-4.1` (OpenAI) | 0.33x ← cheap for scouting |
| librarian | `gemini-3.1-pro-preview` (Google) | **6x** ← large-context doc retrieval |
| designer | `gemini-2.5-pro` (Google) | **1x** ← best value for UI/UX |
| fixer | `gpt-5.2-codex` (OpenAI) | **3x** ← coding specialist |

Use for: critical architecture work, hard debugging, high-stakes multi-file refactors.

---

### OpenRouter Presets

Require `OPENROUTER_API_KEY`. All models verified to have `tool_call: true` in the OpenCode model registry. Priced per token consumed (credits-based), not per request.

#### `openrouter-budget` — Ultra Low Cost

| Agent | Model | Approx Cost |
|---|---|---|
| orchestrator | `moonshotai/kimi-k2.6` | ~$0.12/$0.30 per M |
| oracle | `deepseek/deepseek-v3.2` | ~$0.27/$1.10 per M |
| explorer | `openai/gpt-oss-20b:free` | **FREE** |
| librarian | `google/gemma-4-26b-a4b-it:free` | **FREE** |
| designer | `mistralai/devstral-small-2507` | very cheap |
| fixer | `xiaomi/mimo-v2-flash` | ~$0.09/$0.29 per M |

Use for: exploratory sessions, low-stakes tasks, when on a tight credit budget.

---

#### `openrouter-fast` — Low-Cost Coding Focus

| Agent | Model | Notes |
|---|---|---|
| orchestrator | `qwen/qwen3-coder` | Alibaba coding-specialized |
| oracle | `moonshotai/kimi-k2.6` | strong reasoning + long context |
| explorer | `z-ai/glm-4.7-flash` | fast and cheap |
| librarian | `google/gemini-2.5-flash` | great at retrieval/context |
| designer | `mistralai/devstral-medium-2507` | better UI reasoning |
| fixer | `deepseek/deepseek-v4-flash` | fast targeted code fixes |

Use for: serious dev work where you want OpenRouter's breadth but still want to keep costs minimal.

---

## Council

Council runs multiple models **in parallel** — use deliberately, not for every task. Invoked manually:

```
@council compare these two architectures
```

Three named council presets mirror the Copilot presets:

| Council Preset | Councillors | Default? |
|---|---|---|
| `lean` | claude-haiku-4.5, gemini-3-flash, gpt-4.1 | |
| `balanced` | claude-sonnet-4, gemini-2.5-pro, gpt-5.2 | ✓ |
| `power` | claude-sonnet-4.6 (high), gemini-3.1-pro, gpt-5.5 | |

---

## June 1, 2026 Pricing Change Warning

GitHub Copilot's model multiplier table changes on **June 1, 2026**. Notable shifts:

| Model | Current | Post-June 1 |
|---|---|---|
| `gpt-4.1` | **0x (free!)** | 0.33x |
| `gpt-5-mini` | **0x (free!)** | 0.33x |
| `claude-sonnet-4` | 1x | **1x** ← unchanged! |
| `claude-sonnet-4.5` | 1x | **6x** ← big jump |
| `claude-sonnet-4.6` | 1x | **9x** ← big jump |
| `gpt-5.4-mini` | 0.33x | **6x** ← huge jump |
| `gemini-2.5-pro` | 1x | **1x** ← unchanged! |
| `claude-opus-4.6` | 3x | **27x** |

The `copilot-balanced` preset was specifically designed around `claude-sonnet-4` and `gemini-2.5-pro` which are the two premium models that remain at 1x post-June.

---

## Files

| File | Purpose |
|---|---|
| `~/.config/opencode/oh-my-opencode-slim.jsonc` | Active plugin config (JSONC takes precedence over .json) |
| `~/.config/opencode/opencode.json` | Core opencode config (plugin registration, MCP, LSP) |
| `opencode/oh-my-opencode-slim.jsonc` | Tracked copy of plugin config (this repo) |
| `opencode/opencode.json` | Tracked copy of core config (this repo) |

> The `.jsonc` file in `~/.config/opencode/` is the live config. The copies in this repo are for version control and reference.

---

## Quick Reference

```bash
# Open opencode
opencode

# Switch presets at runtime (inside opencode)
/preset copilot-lean
/preset copilot-balanced
/preset copilot-power
/preset openrouter-budget
/preset openrouter-fast

# Ping all agents
ping all agents

# Refresh model list
opencode models --refresh

# Re-auth if needed
opencode auth login
opencode auth list
```

---

## Plugin Docs

- [oh-my-opencode-slim README](https://github.com/alvinunreal/oh-my-opencode-slim)
- [Configuration reference](https://github.com/alvinunreal/oh-my-opencode-slim/blob/master/docs/configuration.md)
- [Preset switching](https://github.com/alvinunreal/oh-my-opencode-slim/blob/master/docs/preset-switching.md)
- [GitHub Copilot models & pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)
- [OpenRouter model explorer](https://openrouter.ai/models)
- [models.dev](https://models.dev) — cross-provider model reference
