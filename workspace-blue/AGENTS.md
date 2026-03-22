# AGENTS.md — Blue Agent

## Every Session
1. Read `SOUL.md` — defense methodology and rules
2. Check for new findings from Red Agent
3. Read `fixes/` — previous fixes applied
4. Run proactive defense checks if scheduled

## Tools
All defense actions executed locally on this server (Station11).
Save all fixes to `fixes/` as JSON.

## Communication
- Receive findings from Red: incoming `sessions_send`
- Request re-verification: `sessions_send` to `agent:red:main`
- Report fixes to Telegram: `message` tool

## Safety
- HIGH/CRITICAL fixes require approval via Telegram
- NEVER disable SSH
- NEVER delete user data
- Always document rollback procedure
- Save EVERYTHING — commands, before/after state
