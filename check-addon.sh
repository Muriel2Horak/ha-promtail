#!/usr/bin/env bash
#
# HA Promtail Addon - Diagnostický skript
# Ověří, zda je repository správně viditelné z Home Assistant
#

set -e

echo "================================================"
echo "  HA Promtail Addon - Diagnostika"
echo "================================================"
echo ""

REPO_URL="https://github.com/Muriel2Horak/ha-promtail"

echo "🔍 Kontrola 1: GitHub repository dostupnost"
echo "-------------------------------------------"
if curl -s -o /dev/null -w "%{http_code}" "https://github.com/Muriel2Horak/ha-promtail" | grep -q "200"; then
    echo "✓ Repository je dostupné na GitHubu"
else
    echo "✗ Repository není dostupné!"
    exit 1
fi
echo ""

echo "🔍 Kontrola 2: repository.yaml"
echo "-------------------------------------------"
if curl -s "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/repository.yaml" | grep -q "name:"; then
    echo "✓ repository.yaml existuje a je validní"
    curl -s "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/repository.yaml"
else
    echo "✗ repository.yaml není validní!"
    exit 1
fi
echo ""

echo "🔍 Kontrola 3: addon config.yaml"
echo "-------------------------------------------"
if curl -s "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/ha_promtail/config.yaml" | grep -q "slug: ha_promtail"; then
    echo "✓ ha_promtail/config.yaml existuje"
    echo ""
    echo "Důležité údaje:"
    curl -s "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/ha_promtail/config.yaml" | grep -E "^name:|^slug:|^version:|^stage:"
else
    echo "✗ ha_promtail/config.yaml není validní!"
    exit 1
fi
echo ""

echo "🔍 Kontrola 4: Povinné soubory addonu"
echo "-------------------------------------------"
REQUIRED_FILES=(
    "ha_promtail/config.yaml"
    "ha_promtail/build.yaml"
    "ha_promtail/Dockerfile"
    "ha_promtail/README.md"
    "ha_promtail/CHANGELOG.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if curl -s -o /dev/null -w "%{http_code}" "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/$file" | grep -q "200"; then
        echo "✓ $file"
    else
        echo "✗ $file CHYBÍ!"
    fi
done
echo ""

echo "🔍 Kontrola 5: Volitelné soubory"
echo "-------------------------------------------"
OPTIONAL_FILES=(
    "ha_promtail/icon.png"
    "ha_promtail/logo.png"
)

for file in "${OPTIONAL_FILES[@]}"; do
    if curl -s -o /dev/null -w "%{http_code}" "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/$file" | grep -q "200"; then
        echo "✓ $file"
    else
        echo "⚠ $file chybí (volitelný)"
    fi
done
echo ""

echo "🔍 Kontrola 6: YAML syntaxe"
echo "-------------------------------------------"
echo "Kontrola repository.yaml:"
if python3 -c "import sys; [sys.exit(1) if '\t' in line else None for line in open('/dev/stdin')]" < <(curl -s "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/repository.yaml"); then
    echo "✓ Žádné tabulátory (správně)"
else
    echo "✗ Obsahuje tabulátory!"
fi

echo "Kontrola config.yaml:"
if python3 -c "import sys; [sys.exit(1) if '\t' in line else None for line in open('/dev/stdin')]" < <(curl -s "https://raw.githubusercontent.com/Muriel2Horak/ha-promtail/main/ha_promtail/config.yaml"); then
    echo "✓ Žádné tabulátory (správně)"
else
    echo "✗ Obsahuje tabulátory!"
fi
echo ""

echo "================================================"
echo "  SHRNUTÍ"
echo "================================================"
echo ""
echo "Repository URL pro přidání do HA:"
echo "  $REPO_URL"
echo ""
echo "Postup:"
echo "  1. Settings → Add-ons → Add-on Store"
echo "  2. ⋮ menu → Repositories"
echo "  3. Přidat: $REPO_URL"
echo "  4. Ctrl+F5 (refresh) a Check for updates"
echo ""
echo "Pokud addon není vidět:"
echo "  - Zkontrolujte Supervisor logy (Settings → System → Logs → Supervisor)"
echo "  - Zkuste odstranit a znovu přidat repository"
echo "  - Restartujte Supervisor"
echo ""
