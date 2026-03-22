#!/bin/bash
# IronClaw Blue Agent — One-command installer
# Usage: curl -fsSL https://raw.githubusercontent.com/codaki26/ironclaw/main/install-blue.sh | bash
# Or:    bash install-blue.sh

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🛡️  IronClaw Blue Agent — Installer${NC}"
echo "======================================"

# --- Step 1: Check root/sudo ---
echo -e "\n${BLUE}[1/7] Checking permissions...${NC}"
if [ "$EUID" -ne 0 ]; then
  if ! sudo -n true 2>/dev/null; then
    echo -e "${RED}Error: Need sudo access. Run: sudo bash install-blue.sh${NC}"
    exit 1
  fi
  SUDO="sudo"
else
  SUDO=""
fi
echo -e "${GREEN}✅ Permissions OK${NC}"

# --- Step 2: Install Node.js ---
echo -e "\n${BLUE}[2/7] Installing Node.js 22...${NC}"
if command -v node &>/dev/null && [[ $(node -v | cut -d. -f1 | tr -d v) -ge 22 ]]; then
  echo -e "${GREEN}✅ Node.js $(node -v) already installed${NC}"
else
  curl -fsSL https://deb.nodesource.com/setup_22.x | $SUDO bash -
  $SUDO apt install -y nodejs
  echo -e "${GREEN}✅ Node.js $(node -v) installed${NC}"
fi

# --- Step 3: Install OpenClaw ---
echo -e "\n${BLUE}[3/7] Installing OpenClaw...${NC}"
if command -v openclaw &>/dev/null; then
  echo -e "${GREEN}✅ OpenClaw already installed${NC}"
else
  $SUDO npm install -g openclaw@latest
  echo -e "${GREEN}✅ OpenClaw installed${NC}"
fi

# --- Step 4: Install security tools ---
echo -e "\n${BLUE}[4/7] Installing security tools...${NC}"
$SUDO apt update -qq
$SUDO apt install -y -qq nmap nikto testssl.sh dirb curl net-tools jq 2>/dev/null || true
echo -e "${GREEN}✅ Security tools installed${NC}"

# --- Step 5: Setup sudoers for Blue Agent ---
echo -e "\n${BLUE}[5/7] Configuring sudo access...${NC}"
SUDOERS_FILE="/etc/sudoers.d/ironclaw-blue"
if [ ! -f "$SUDOERS_FILE" ]; then
  cat <<'SUDOERS' | $SUDO tee "$SUDOERS_FILE" > /dev/null
# IronClaw Blue Agent — sudo permissions
# Security tools and system management
Defaults !requiretty

# Package management
david ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get, /usr/bin/dpkg

# Firewall
david ALL=(ALL) NOPASSWD: /usr/sbin/ufw, /usr/sbin/iptables, /usr/sbin/nftables

# Services
david ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/sbin/service

# Docker
david ALL=(ALL) NOPASSWD: /usr/bin/docker

# Security tools
david ALL=(ALL) NOPASSWD: /usr/bin/fail2ban-client, /usr/bin/nmap

# Log analysis
david ALL=(ALL) NOPASSWD: /usr/bin/journalctl

# File operations (for hardening)
david ALL=(ALL) NOPASSWD: /usr/bin/chmod, /usr/bin/chown, /usr/bin/chattr
david ALL=(ALL) NOPASSWD: /usr/bin/find
david ALL=(ALL) NOPASSWD: /usr/bin/cat, /usr/bin/tee, /usr/bin/sed
david ALL=(ALL) NOPASSWD: /usr/bin/cp, /usr/bin/mv, /usr/bin/mkdir

# Node/OpenClaw
david ALL=(ALL) NOPASSWD: /usr/bin/node, /usr/bin/npm, /usr/bin/npx
david ALL=(ALL) NOPASSWD: /usr/bin/bash, /usr/bin/sh

# Network
david ALL=(ALL) NOPASSWD: /usr/bin/ss, /usr/bin/netstat, /usr/sbin/ss
SUDOERS
  $SUDO chmod 440 "$SUDOERS_FILE"
  echo -e "${GREEN}✅ Sudo configured${NC}"
else
  echo -e "${GREEN}✅ Sudo already configured${NC}"
fi

# --- Step 6: Create workspace ---
echo -e "\n${BLUE}[6/7] Creating Blue Agent workspace...${NC}"
OPENCLAW_DIR="$HOME/.openclaw"
WORKSPACE="$OPENCLAW_DIR/workspace-blue"
mkdir -p "$WORKSPACE/fixes" "$WORKSPACE/defense-log"

# SOUL.md
cat <<'SOUL' > "$WORKSPACE/SOUL.md"
# SOUL.md — Blue Agent 🔵

You are IronClaw's **Blue Agent** — an autonomous security defender.

## Mission
Protect this server. Monitor for threats. Fix vulnerabilities.
Harden the system continuously. Report all actions.

## Identity
- **Name:** Blue
- **Role:** Defender / Security Engineer
- **Emoji:** 🔵

## You have FULL sudo access to this server.
Use it responsibly. Document everything.

## Defense Methodology

### When Receiving a Finding
1. Assess severity and impact
2. Apply fix based on severity:
   - INFO/LOW/MEDIUM → auto-fix + report
   - HIGH/CRITICAL → alert Telegram + wait for approval
3. Document the fix (JSON in fixes/)
4. Request re-verification

### Proactive Defense (scheduled)
1. Check pending security updates
2. Review running services and ports
3. Check file permissions (SUID, world-writable)
4. Monitor disk/memory/CPU
5. Review fail2ban status and bans
6. Check Docker container health
7. Review access logs for anomalies
8. Check SSL certificate expiry
9. Verify firewall rules

## Fix Documentation
Every fix saved as JSON in fixes/:
```json
{
  "id": "BLUE-YYYY-MM-DD-NNN",
  "finding_id": "RED-...",
  "timestamp": "ISO8601",
  "severity": "CRITICAL|HIGH|MEDIUM|LOW|INFO",
  "title": "What was fixed",
  "commands_executed": ["..."],
  "before_state": "...",
  "after_state": "...",
  "rollback": "How to undo",
  "status": "applied|pending_approval|rolled_back"
}
```

## Safety Rules
### Auto-fix (no approval)
- Security patches (apt upgrade --security)
- Close unnecessary ports
- Fix file permissions
- Update fail2ban rules
- Add security headers

### Requires approval (Telegram)
- Changing firewall rules
- Modifying SSH configuration
- Restarting services
- Changing Docker configuration

### NEVER
- Delete user data
- Disable SSH
- Stop production services without approval
- Change credentials without informing admin
SOUL

# AGENTS.md
cat <<'AGENTS' > "$WORKSPACE/AGENTS.md"
# AGENTS.md — Blue Agent

## Every Session
1. Read SOUL.md
2. Check for new findings
3. Read fixes/ for history
4. Run proactive checks if scheduled

## Safety
- HIGH/CRITICAL fixes require Telegram approval
- Document rollback for every fix
- Save everything
AGENTS

echo -e "${GREEN}✅ Workspace created at $WORKSPACE${NC}"

# --- Step 7: Summary ---
echo -e "\n${BLUE}[7/7] Setup complete!${NC}"
echo "======================================"
echo -e "${GREEN}🛡️  IronClaw Blue Agent is ready!${NC}"
echo ""
echo "Next steps:"
echo "  1. Run: openclaw configure"
echo "     - Add your AI provider key (Anthropic/OpenAI)"
echo "     - Add Telegram bot token"
echo "  2. Run: openclaw gateway start"
echo ""
echo "Workspace: $WORKSPACE"
echo "Fixes log: $WORKSPACE/fixes/"
echo "Defense log: $WORKSPACE/defense-log/"
echo ""
echo -e "${BLUE}Blue Agent will protect this server 🛡️${NC}"
