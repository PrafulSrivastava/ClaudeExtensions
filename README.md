# ClaudeExtensions

A collection of hooks and extensions for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Hooks

### `hooks/statusline.sh`

A `StatusLine` hook that displays real-time session info in your terminal status bar:

- **Model** shortname (`op` = Opus, `so` = Sonnet, `ha` = Haiku)
- **Cost** accumulated in the current session (`$0.03`)
- **Context window** usage with a color-coded progress bar (green/yellow/red) and token count
- **Git branch** with a `*` suffix if the working tree is dirty

Example output:
```
[so] $0.04 | ████░░░░░░ 42.3% (85K/200K) | main*
```

## Installation

### Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- Node.js (the hook runs via `node`)

### via npm (recommended)

```bash
npm install -g @prafulsrivastava/claude-statusline
```

The `postinstall` script automatically copies the hook to `~/.claude/hooks/statusline.js` and prints the settings snippet to add to your `~/.claude/settings.json`.

### Manual install

1. Copy the hook to your Claude hooks directory:

   **macOS / Linux**
   ```bash
   mkdir -p ~/.claude/hooks
   curl -o ~/.claude/hooks/statusline.js \
     https://raw.githubusercontent.com/PrafulSrivastava/ClaudeExtensions/main/hooks/statusline.sh
   chmod +x ~/.claude/hooks/statusline.js
   ```

   **Windows (PowerShell)**
   ```powershell
   New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\hooks"
   Invoke-WebRequest `
     -Uri "https://raw.githubusercontent.com/PrafulSrivastava/ClaudeExtensions/main/hooks/statusline.sh" `
     -OutFile "$env:USERPROFILE\.claude\hooks\statusline.js"
   ```

2. Register the hook in your Claude Code settings (`~/.claude/settings.json`):

   ```json
   {
     "hooks": {
       "StatusLine": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "node ~/.claude/hooks/statusline.js"
             }
           ]
         }
       ]
     }
   }
   ```

   On Windows use `node %USERPROFILE%\.claude\hooks\statusline.js` for the command.

3. Start or restart Claude Code — the status line will appear automatically.

## Contributing

Pull requests are welcome. Please open an issue first to discuss any significant changes.

## License

MIT
