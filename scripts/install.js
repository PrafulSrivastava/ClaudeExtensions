#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const src = path.join(__dirname, '..', 'hooks', 'statusline.sh');
const claudeDir = path.join(os.homedir(), '.claude');
const hooksDir = path.join(claudeDir, 'hooks');
const dest = path.join(hooksDir, 'statusline.js');

fs.mkdirSync(hooksDir, { recursive: true });
fs.copyFileSync(src, dest);
// Ensure executable on Unix
try { fs.chmodSync(dest, 0o755); } catch {}

// Update ~/.claude/settings.json
const settingsPath = path.join(claudeDir, 'settings.json');
let settings = {};
try { settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8')); } catch {}

settings.statusLine = {
  type: 'command',
  command: `node ${dest.replace(/\\/g, '/')}`
};

fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + '\n');

console.log(`
claude-statusline installed to: ${dest}
settings.json updated at: ${settingsPath}

Restart Claude Code to see the status line.
`);
