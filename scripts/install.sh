#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
target="${HOME}/.cursor/skills/flutter-update-app-icon"

mkdir -p "${HOME}/.cursor/skills"
ln -sfn "$root" "$target"

echo "Installed: $target -> $root"
echo "В новом чате Cursor вызови /flutter-update-app-icon"
