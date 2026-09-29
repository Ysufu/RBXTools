<div align="center">

# 📋 YUSZX UNIVERSAL MINI IDE

### In-Game Debug Console for Roblox — Works in ANY Game

[![Version](https://img.shields.io/badge/version-v1-blue?style=for-the-badge)](https://github.com/Ysufu)
[![Status](https://img.shields.io/badge/status-active-success?style=for-the-badge)](https://github.com/Ysufu)
[![Universal](https://img.shields.io/badge/universal-all%20games-purple?style=for-the-badge)](https://github.com/Ysufu)
[![License](https://img.shields.io/badge/license-MIT-orange?style=for-the-badge)](LICENSE)

**Split-view console buat debug script di game Roblox manapun.**

</div>

---

## ✨ Fitur

### 🖥️ Split View Layout
- **Atas**: Code editor (paste/ketik kode debug)
- **Bawah**: Output console (auto-capture print & warn)
- **Tombol**: Execute, Copy, Clear, Save

### 🎯 Universal
- ✅ Works di **SEMUA game Roblox**
- ✅ Multi-fallback UI parent (`gethui` → `CoreGui` → `PlayerGui` → `ReplicatedFirst`)
- ✅ Auto-test parent sebelum dipakai
- ✅ Anti-crash (pcall everywhere)
- ✅ Ringan — gak bikin lag

### 📋 Log Features
- **Auto-capture** semua `print()` dan `warn()`
- **Copy to clipboard** — 1 klik, langsung paste di chat
- **Save to file** — backup log ke `.txt`
- **Auto-scroll** — output scroll otomatis ke bawah
- **Max 500 baris** — yang lama auto-hapus

### 🎨 UI Design
- Dark theme (#121212)
- Neon accent (biru + hijau)
- Draggable window
- Rounded corners

---

## 🚀 Cara Pakai

### 1. Execute Script

Copy loadstring di bawah, paste ke executor:
```lua
v1
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ysufu/RBXTools/refs/heads/main/debug-cons.lua"))()
v2
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ysufu/RBXTools/refs/heads/main/debuh-v2.lua"))()
