#!/usr/bin/env node

const { execSync } = require('child_process');

let input = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (chunk) => { input += chunk; });
process.stdin.on('end', () => {
  let data = {};
  try { data = JSON.parse(input); } catch { }

  // Model short name
  const modelId = (data.model && (data.model.api_model_id || data.model.display_name || data.model.id)) || '';
  let modelShort = 'cl';
  if (/opus/i.test(modelId)) modelShort = 'op';
  else if (/sonnet/i.test(modelId)) modelShort = 'so';
  else if (/haiku/i.test(modelId)) modelShort = 'ha';

  const parts = [];

  // Cost display
  const cost = data.cost && data.cost.total_cost_usd;
  if (cost != null) parts.push(`$${Number(cost).toFixed(2)}`);

  // Context window usage — use pre-calculated used_percentage from docs
  const ctx = data.context_window || {};
  const pct = ctx.used_percentage;
  const ctxSize = ctx.context_window_size;

  if (pct != null && ctxSize) {
    const pctInt = Math.floor(pct);
    const filled = Math.min(Math.floor(pctInt / 10), 10);
    const empty = 10 - filled;
    const bar = '█'.repeat(filled) + '░'.repeat(empty);

    // Token display
    const usage = ctx.current_usage || {};
    const totalTokens = (usage.input_tokens || 0) + (usage.cache_creation_input_tokens || 0) + (usage.cache_read_input_tokens || 0);
    const tokensDisplay = totalTokens >= 1000 ? Math.floor(totalTokens / 1000) + 'K' : String(totalTokens);
    const ctxSizeK = Math.floor(ctxSize / 1000) + 'K';

    // Color coding (ANSI)
    let color;
    if (pctInt >= 80) color = '\x1b[31m';      // Red
    else if (pctInt >= 50) color = '\x1b[33m';  // Yellow
    else color = '\x1b[32m';                     // Green
    const reset = '\x1b[0m';

    parts.push(`${color}${bar}${reset} ${pct.toFixed(1)}% (${tokensDisplay}/${ctxSizeK})`);
  }

  // Git branch info
  try {
    execSync('git rev-parse --git-dir', { stdio: 'pipe' });
    const branch = execSync('git branch --show-current', { stdio: 'pipe', encoding: 'utf8' }).trim();
    if (branch) {
      const dirty = execSync('git status --porcelain', { stdio: 'pipe', encoding: 'utf8' }).trim();
      parts.push(dirty ? `${branch}*` : branch);
    }
  } catch { }

  const output = parts.length ? `[${modelShort}] ${parts.join(' | ')}` : `[${modelShort}]`;
  process.stdout.write(output + '\n');
});
