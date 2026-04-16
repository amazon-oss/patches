#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

while IFS= read -r patch; do
    rel_path="${patch#$SCRIPT_DIR/}"
    target_subdir="$(dirname "$rel_path")"
    target_dir="$ROOT_DIR/$target_subdir"

    echo "Applying $(basename "$patch") in $target_subdir"

    if [ ! -d "$target_dir" ]; then
        echo "Error: target directory $target_dir does not exist"
        exit 1
    fi

    (cd "$target_dir" && git am "$patch")
done < <(find "$SCRIPT_DIR" -type f -name "*.patch" -not -path "*/.git/*" | sort)

echo "Done."
