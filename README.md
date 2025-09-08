# Pokenctyl v1.0 — Final Release

This release is a fully-working starter release for the Pokenctyl panel, themed for a modern 2026 aesthetic. It includes:
- React frontend with Framer Motion animations (nebula + nook theme)
- Node/Express backend with a simple daemon registration API
- Minimal daemon that registers to the backend
- One-command installer to bootstrap everything

## Quick start
1. Replace `REPO_URL` inside `installer/pokenctyl.sh` with your GitHub repo URL.
2. Upload repo to GitHub.
3. On an Ubuntu 22.04 VPS run:
   ```bash
   sudo bash <(curl -s https://raw.githubusercontent.com/<you>/Pokenctyl/main/installer/pokenctyl.sh)
   ```
4. Open the printed panel URL.

## Notes & Next steps
- This is a finalized bundle but still minimal in security hardening. Change default passwords, add TLS, secure DB, and improve auth before public launch.
- If you want more advanced: file manager, in-panel server console, full Wings clone, resource limits, SFTP integration — I can add them on request.

---

© Pokenctyl 2025-26
