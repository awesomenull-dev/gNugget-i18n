#!/usr/bin/env bash
#
# Regenerate the base translation (Nugget_en.ts) of gNugget-i18n from the
# GoldenNugget source code.
#
# The .ts files live at the ROOT of this repository (gNugget-i18n). This script
# runs pyside6-lupdate against a checkout of the GoldenNugget source and writes
# the refreshed Nugget_en.ts here, so new UI strings added to the code reach
# translators automatically.
#
# Usage:
#   ./scripts/update_base_translation.sh <path-to-goldennugget-source>
#
# The GoldenNugget source path is used read-only; nothing there is modified.
set -euo pipefail

GOLDEN_SRC="${1:?usage: update_base_translation.sh <path-to-goldennugget-source>}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TS_FILE="$REPO_ROOT/Nugget_en.ts"

if [[ ! -f "$GOLDEN_SRC/src/gui/main_window.py" ]]; then
  echo "Error: '$GOLDEN_SRC' does not look like a GoldenNugget checkout (no src/gui/main_window.py)." >&2
  exit 1
fi
if [[ ! -f "$TS_FILE" ]]; then
  echo "Error: base translation not found at '$TS_FILE'." >&2
  exit 1
fi

# Source patterns — mirrors the pyside6-lupdate command documented in the
# GoldenNugget README. Glob patterns are expanded in the loop below (array
# elements with literals are NOT expanded by bash, so we expand them here).
PATTERNS=(
  src/gui/main_window.py
  src/gui/pages/page.py
  src/gui/pages/pages_list.py
  src/gui/pages/main/*.py
  src/gui/pages/tools/*.py
  src/gui/dialogs/*.py
  src/gui/ios/*.py
  src/qt/mainwindow.ui
  src/devicemanagement/device_manager.py
  src/exceptions/*.py
  src/tweaks/*.py
  src/tweaks/posterboard/*.py
  src/tweaks/posterboard/template_options/*.py
  src/tweaks/status_bar/*.py
  src/controllers/*.py
)

FILES=()
for pattern in "${PATTERNS[@]}"; do
  # Relative patterns are resolved against the GoldenNugget checkout.
  # Unquoted expansion performs pathname expansion on the pattern.
  for candidate in "$GOLDEN_SRC"/$pattern; do
    [[ -e "$candidate" ]] && FILES+=("$candidate")
  done
done

if (( ${#FILES[@]} == 0 )); then
  echo "Error: no source files matched — nothing to scan." >&2
  exit 1
fi

echo "Updating base translation from GoldenNugget source at '$GOLDEN_SRC' ..."
pyside6-lupdate "${FILES[@]}" -ts "$TS_FILE"
echo "Base translation updated: $TS_FILE"
