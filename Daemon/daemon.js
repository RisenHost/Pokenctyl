// Minimal daemon - registers itself and stays alive. Replace with a full wings-like daemon for production.
const axios = require('axios');
const TOKEN = process.env.DAEMON_TOKEN || 'local-demo-token';
const PANEL = process.env.PANEL_URL || 'http://localhost:8080/api';

async function register() {
  try {
    const ip = require('os').networkInterfaces();
    const hostname = require('os').hostname();
    await axios.post(`${PANEL}/daemons/register`, { token: TOKEN, hostname, ip: Object.keys(ip)[0] });
    console.log('Daemon registered');
  } catch (err) {
    console.error('Registration failed', err.message);
  }
}

register();
setInterval(() => { console.log('Daemon heartbeat'); }, 60_000);
