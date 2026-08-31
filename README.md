# terminal

Windows terminal rice — full setup from fresh install.

## What's Included

| App | Config | Purpose |
|-----|--------|---------|
| Windows Terminal | `windows-terminal/settings.json` | Terminal emulator |
| Oh My Posh | `oh-my-posh/catppuccin_mocha.omp.json` | Prompt theme |
| Starship | `starship/starship.toml` | Alternative prompt |
| Yazi | `yazi/` | File manager |
| Cava | `cava/` | Audio visualizer |
| Fastfetch | `fastfetch/` | System info |
| Winfetch | `winfetch/` | System info (PowerShell) |
| GlazeWM | `glazewm/config.yaml` | Tiling window manager |
| Zebar | `zebar/settings.json` | Status bar |
| Tacky Borders | `tacky-borders/config.yaml` | Window borders |

## Quick Start

```powershell
# Clone the repo
git clone https://github.com/0124212/terminal.git
cd terminal

# Run the installer (as admin)
.\install.ps1
```

This will:
1. Install all apps via winget/scoop
2. Deploy all configs to correct locations
3. Set up PowerShell profile with Oh My Posh + aliases

## Manual Steps After Install

1. **Install JetBrainsMono Nerd Font** — [nerdfonts.com](https://www.nerdfonts.com/)
2. **Launch GlazeWM** — runs as tiling WM, auto-starts Zebar
3. **Launch Tacky Borders** — window border decorations
4. **Set up Element** — log in to your Matrix account

## Keybinds (GlazeWM)

| Bind | Action |
|------|--------|
| `Alt+H/J/K/L` | Focus left/down/up/right |
| `Alt+Shift+H/J/K/L` | Move window |
| `Alt+1-9` | Switch workspace |
| `Alt+Shift+1-9` | Move window to workspace |
| `Alt+T` | Toggle tiling |
| `Alt+F` | Toggle fullscreen |
| `Alt+Shift+Q` | Close window |
| `Alt+Enter` | Open terminal |
| `Alt+Space` | Cycle focus |
| `Alt+Shift+Space` | Toggle floating |

## Color Scheme

**Grey Black** — custom dark theme with muted tones. Configured in Windows Terminal settings.

## License

Do whatever you want with these configs.
