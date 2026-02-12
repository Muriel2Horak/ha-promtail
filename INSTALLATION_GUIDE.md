# Návod: Přidání HA Promtail Addonu do Home Assistant

## ✅ OVĚŘENÍ - Repository je správně na GitHubu

Repository struktura je validní a obsahuje:
- ✓ `/repository.yaml` - konfigurace repository
- ✓ `/ha_promtail/config.yaml` - addon konfigurace (v0.1.5)
- ✓ `/ha_promtail/build.yaml` - build konfigurace
- ✓ `/ha_promtail/icon.png` - ikona
- ✓ `/ha_promtail/logo.png` - logo
- ✓ Všechny soubory jsou validní

URL: https://github.com/Muriel2Horak/ha-promtail

---

## 📋 POSTUP PŘIDÁNÍ DO HOME ASSISTANT

### Krok 1: Otevřete Add-on Store

1. V Home Assistant jděte do: **Settings** (Nastavení)
2. Klikněte na: **Add-ons**
3. Klikněte na: **Add-on Store** (vpravo dole)

### Krok 2: Přidejte Repository

1. V pravém horním rohu klikněte na **⋮** (tři tečky)
2. Vyberte: **Repositories**
3. Do pole vložte:
   ```
   https://github.com/Muriel2Horak/ha-promtail
   ```
4. Klikněte na **Add** nebo **Přidat**

### Krok 3: Obnovte seznam

1. Zavřete dialog s repositories
2. Znovu klikněte na **⋮** menu
3. Vyberte: **Check for updates** nebo **Zkontrolovat aktualizace**
4. **DŮLEŽITÉ**: Hard refresh prohlížeče:
   - **Windows/Linux**: Ctrl + F5
   - **macOS**: Cmd + Shift + R

### Krok 4: Najděte addon

Po refreshi by se měl addon objevit v Add-on Store:
- **Název**: HA Promtail
- **Verze**: 0.1.5
- **Popis**: Promtail for HAOS with journald scraping
- **Ikona**: Modrý placeholder (můžete později nahradit)

---

## 🔍 POKUD ADDON NENÍ VIDĚT

### Možnost 1: Zkontrolujte Supervisor logy

1. Jděte do: **Settings** → **System** → **Logs**
2. V dropdown menu vyberte: **Supervisor**
3. Hledejte chyby s textem: "repository", "ha_promtail", nebo "yaml"

### Možnost 2: Odstraňte a přidejte repository znovu

1. **⋮** → **Repositories**
2. Najděte `https://github.com/Muriel2Horak/ha-promtail`
3. Klikněte na **Remove** (odebrat)
4. Zavřete dialog
5. Znovu přidejte repository (Krok 2 výše)

### Možnost 3: Restart Supervisoru

Pokud nic nepomáhá:
1. Jděte do: **Settings** → **System**
2. Klikněte na: **Restart**
3. Vyberte: **Restart Supervisor**

---

## 🎯 CO OČEKÁVAT

Po úspěšném přidání byste měli vidět:

```
┌─────────────────────────────────────┐
│  📦 HA Promtail                     │
│  Muriel HA Add-ons                  │
│  Version: 0.1.5                     │
│  [Install]                          │
└─────────────────────────────────────┘
```

---

## ⚙️ INSTALACE ADDONU

Po zobrazení v Add-on Store:

1. Klikněte na **HA Promtail**
2. Klikněte na **Install**
3. Po instalaci:
   - Přejděte na **Configuration** tab
   - Nastavte **Loki URL**: `http://VASE_LOKI_IP:3100/loki/api/v1/push`
   - Případně nastavte autentizaci
4. Klikněte na **Start**

---

## 📝 KONFIGURACE

Základní nastavení:

```yaml
client:
  url: "http://10.0.0.160:3100/loki/api/v1/push"
  username: ""       # Volitelné
  password: ""       # Volitelné
  cafile: ""         # Volitelné - cesta k CA certifikátu
  certfile: ""       # Volitelné - cesta k client certifikátu
  keyfile: ""        # Volitelné - cesta k client klíči
  servername: ""     # Volitelné - server name pro TLS
log_level: info      # trace|debug|info|notice|warning|error|fatal
```

---

## 🐛 DEBUG

Pokud addon nefunguje po instalaci:

1. **Zkontrolujte logy**:
   - V addonu klikněte na **Log** tab
   - Hledejte chyby spojené s Promtail nebo Loki

2. **Zkontrolujte připojení k Loki**:
   ```bash
   curl http://VASE_LOKI_IP:3100/ready
   ```

3. **Zkontrolujte health endpoint**:
   - Addon vystavuje port 9080
   - Health check: `http://VASE_HA_IP:9080/ready`

---

## 📞 PODPORA

Pokud máte problémy:
- GitHub Issues: https://github.com/Muriel2Horak/ha-promtail/issues
- Zkontrolujte Supervisor logy
- Ověřte síťové připojení k Loki serveru

---

**Vytvořeno:** 2026-02-12
**Verze addonu:** 0.1.5
**Promtail verze:** 3.3.2
