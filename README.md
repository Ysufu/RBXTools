<div align="center">

# 🛠️ YUSZX RBX TOOLS

### Kumpulan Tools Universal untuk Roblox

[![Version](https://img.shields.io/badge/version-v2-blue?style=for-the-badge)](https://github.com/Ysufu/RBXTools)
[![Status](https://img.shields.io/badge/status-active-success?style=for-the-badge)](https://github.com/Ysufu/RBXTools)
[![Universal](https://img.shields.io/badge/universal-all%20games-purple?style=for-the-badge)](https://github.com/Ysufu/RBXTools)
[![License](https://img.shields.io/badge/license-MIT-orange?style=for-the-badge)](LICENSE)

**Tools universal buat Roblox — Mini IDE, Search Engine, dan lain-lain.**

</div>

---

## 📦 Daftar Tools

| # | Tools | Fungsi | Status |
|---|-------|--------|--------|
| 1 | 📋 **Mini IDE** | In-game console + output capture | ✅ Stable |
| 2 | 🔍 **Search Engine** | Cari apa aja dari internet in-game | ✅ Stable |
| 3 | 📝 **Debug Console** | Console versi simple | ✅ Stable |

---

## 📋 Mini IDE

**Split-view console** — paste kode debug, liat output, copy hasil. Works di **semua game Roblox**.

### ✨ Fitur
- 🖥️ **Split View Layout** — Atas: code editor, Bawah: output console
- 🎯 **Universal** — Works di SEMUA game Roblox
- 🔄 **Multi-fallback UI parent** (`gethui` → `CoreGui` → `PlayerGui` → `ReplicatedFirst`)
- 📋 **Auto-capture** `print()` & `warn()`
- 💾 **Save to file** — backup log ke `.txt`
- 📌 **Minimize & Close** — UI compact
- 🎨 **Animated border glow** — Mutational color
- ✨ **Anti-crash** — `pcall` everywhere

### 🚀 Loadstring

**Mini IDE v1:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ysufu/RBXTools/refs/heads/main/debug-cons.lua"))()
```

**Mini IDE v2:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ysufu/RBXTools/refs/heads/main/debuh-v2.lua"))()
```

### 📋 Cara Pakai
1. **Execute** script di game manapun
2. **Paste kode debug** di textbox atas
3. **Klik ▶ RUN**
4. **Liat output** di bawah
5. **Klik 📋 COPY** buat copy hasilnya

---

## 🔍 Search Engine

**Web search in-game** — cari apa aja dari internet tanpa keluar dari Roblox.

### ✨ Fitur
- 🔍 **Search Box** — Ketik keyword, tekan Enter atau klik Cari
- 🌐 **DuckDuckGo** — Search engine (Google block scraping)
- 📊 **20 Hasil** — Max 20 result per search
- 📋 **Tap = Copy** — Klik result → link di-copy ke clipboard
- 🎨 **Modern UI** — Design clean & profesional
- 💀 **Loading Skeleton** — Shimmer animation pas loading
- 🎯 **Focus States** — Search bar border nyala pas di-klik
- ✨ **Hover Effects** — Card naik + border nyala pas di-hover

### 🚀 Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ysufu/RBXTools/refs/heads/main/search-engine.lua"))()
```

### 📋 Cara Pakai
1. **Execute** script di game manapun
2. **Search bar auto-focus**
3. **Ketik keyword** — misal "roblox lua tutorial"
4. **Tekan Enter** atau klik **Cari**
5. **Result muncul** — tap buat copy link
6. **Paste di browser** HP

---

## 📝 Debug Console

**Console simple** — output log auto-capture, tombol copy 1 klik.

### 🚀 Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Ysufu/RBXTools/refs/heads/main/debug-cons.lua"))()
```

### 📋 Cara Pakai
1. **Execute** script
2. **Semua `print()` & `warn()`** otomatis ke-capture
3. **Klik 📋 COPY** buat copy log
4. **Klik 💾 SAVE** buat backup ke file

---

## 📋 Requirement

| Kebutuhan | Keterangan |
|-----------|------------|
| **Executor** | Delta, Codex, Fluxus, Arceus X, atau apapun dengan `gethui()` |
| **Game** | Roblox apapun (universal) |
| **File I/O** | Optional — buat save log |
| **Koneksi** | Internet (load script + search engine) |

---

## 🎨 Tema UI

Semua tools pakai **tema konsisten**:

| Warna | Hex | Usage |
|-------|-----|-------|
| Background | `#0F0F14` | Latar utama |
| Card | `#16161E` | Panel / card |
| Border | `#2D2D3C` | Stroke / divider |
| Accent | `#00B4FF` | Biru neon |
| Green | `#50DC78` | Status sukses |
| Purple | `#9650FF` | Gradient |

---

## 🔧 Troubleshooting

### UI Gak Muncul
- Coba executor lain (Delta recommended)
- Cek console buat error
- Restart game + execute ulang

### Output Gak Ke-capture
- Pastiin pakai Mini IDE v2 (yang udah fix)
- Cek `setfenv` support di executor
- Screenshot error → report

### Search Gak Muncul
- Cek koneksi internet
- Coba keyword lain
- Ganti search engine (lihat config di script)

### Config Gak Kesave
- Executor harus support `readfile`/`writefile`
- Cek folder `/Delta/Workspace/`
- Kalau gak support, config reset tiap execute

---

## 📊 Fitur Status

| Tools | Status | Notes |
|-------|--------|-------|
| Mini IDE v1 | ✅ Stable | Basic console |
| Mini IDE v2 | ✅ Stable | Fixed output capture |
| Search Engine | ✅ Stable | DuckDuckGo powered |

---

## 🔧 Changelog

### v2 (Latest)
- 🔍 **Search Engine** — Web search in-game (Professional Edition)
- 🎨 **UI Redesign** — Modern clean layout
- ✨ **Animated glow** — Top gradient animation
- 💀 **Loading skeleton** — Shimmer animation

### v1
- 📋 **Mini IDE** — Split view console
- 📝 **Debug Console** — Basic log capture
- 🎨 **Dark theme** — Neon accent

---

## ⚠️ Disclaimer

> **Tools ini dibuat untuk tujuan edukasi & debugging.**
>
> - Gunakan dengan **bijak** dan **risiko sendiri**
> - Kami **tidak bertanggung jawab** atas banned / kerugian
> - **Jangan pakai buat cheat di game kompetitif**
> - Selalu ikuti **Terms of Service Roblox**
>
> Kalau kamu gak setuju, **jangan pakai tools ini**.

---

## 🙏 Credits

- **Script by** [@Ysufu](https://github.com/Ysufu)
- **UI inspired by** VS Code, Spotify, Discord
- **Search powered by** DuckDuckGo
- **Made with** ❤️ by Yuszx

---

## 📞 Kontak

Kalau ada bug / saran:

- **GitHub Issues**: [Buat Issue](https://github.com/Ysufu/RBXTools/issues)
- **Discord**: (isi kalau ada)

---

<div align="center">

**⭐ Jangan lupa kasih STAR kalau tools ini berguna! ⭐**

Made with ❤️ by Yuszx

</div>
