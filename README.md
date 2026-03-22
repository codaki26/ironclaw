# 🦀🛡️ IronClaw

**AI-powered Red Team / Blue Team security system.**

Built on [OpenClaw](https://github.com/openclaw/openclaw). Continuously attacks and defends your servers using AI agents.

---

## What is IronClaw?

IronClaw is an autonomous security system with two AI agents:

- **🔴 Red Agent** — Attacks your server. Scans, probes, finds vulnerabilities, attempts exploits.
- **🔵 Blue Agent** — Defends your server. Monitors, patches, hardens, fixes vulnerabilities.

They work in a continuous cycle:

```
Red finds vulnerability → sends to Blue
Blue fixes it → asks Red to re-verify  
Red re-tests → confirms fix or finds new issue
Repeat forever. Server gets harder to crack every day.
```

All findings and fixes are logged as structured data — perfect for training security AI models.

## Architecture

```
┌─────────────────────────────┐
│  Attack Server              │
│  OpenClaw + Red Agent 🔴    │
│  Scans, probes, exploits    │
└──────────────┬──────────────┘
               │ attacks
               ▼
┌─────────────────────────────┐
│  Target Server              │
│  OpenClaw + Blue Agent 🔵   │
│  Monitors, patches, hardens │
│  + your production services │
└─────────────────────────────┘
```

## Quick Start

### 1. Clone
```bash
git clone https://github.com/codaki26/ironclaw.git
cd ironclaw
```

### 2. Install
```bash
npm install
```

### 3. Configure
```bash
cp ironclaw.example.json openclaw.json
# Edit openclaw.json with your:
#   - AI provider key (Anthropic/OpenAI)
#   - Telegram bot token
#   - Target server details
```

### 4. Run
```bash
npm start
```

## Features

- 🔴 **Automated penetration testing** — nmap, nikto, testssl, gobuster
- 🔵 **Automated defense** — patching, hardening, firewall, monitoring
- 📊 **Security scoring** — track your security posture over time
- 📱 **Telegram alerts** — real-time notifications for critical findings
- 🔄 **Continuous cycle** — Red attacks, Blue defends, repeat
- 📝 **Full audit trail** — every command, finding, and fix logged as JSON
- 🤖 **AI-driven** — agents decide what to attack/defend based on context
- 🧠 **Training data** — all sessions exportable for ML training

## Safety

IronClaw has strict safety boundaries:
- Red Agent ONLY attacks whitelisted targets
- Critical fixes require human approval
- All actions are logged
- Rollback procedures documented for every fix

## License

MIT — see [LICENSE](LICENSE)

---

Built by [Codaki](https://codaki.com) 🦀
