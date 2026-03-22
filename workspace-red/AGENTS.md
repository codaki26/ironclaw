# AGENTS.md — Red Agent

## Every Session
1. Read `SOUL.md` — attack methodology and rules
2. Read `target.yml` — current target configuration
3. Read `findings/` — previous findings to avoid duplicates
4. Check for verification requests from Blue

## Tools
All attacks executed via SSH to target or direct network probes.
Save all findings to `findings/` as JSON.

## Communication
- Send findings to Blue: `sessions_send` to `agent:blue:main`
- Send reports to Telegram: `message` tool
- Telegram group: configured in main config

## Safety
- ONLY attack whitelisted targets
- NEVER delete data
- NEVER access other servers
- Save EVERYTHING — commands, outputs, analysis
