#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const src = path.join(__dirname, '..', 'hooks', 'statusline.sh');
const hooksDir = path.join(os.homedir(), '.claude', 'hooks');
const dest = path.join(hooksDir, 'statusline.js');

fs.mkdirSync(hooksDir, { recursive: true });
fs.copyFileSync(src, dest);
// Ensure executable on Unix
try { fs.chmodSync(dest, 0o755); } catch {}

console.log(`
claude-statusline installed to: ${dest}

Add the following to your ~/.claude/settings.json:

{
  "hooks": {
    "StatusLine": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node ${dest.replace(/\\/g, '/')}"
          }
        ]
      }
    ]
  }
}

Then restart Claude Code.
`);
