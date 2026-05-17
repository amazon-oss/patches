#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

declare -A SEEN

while IFS= read -r patch; do
    rel_path="${patch#$SCRIPT_DIR/}"
    target_subdir="$(dirname "$rel_path")"
    target_dir="$ROOT_DIR/$target_subdir"

    if [ -n "${SEEN[$target_dir]}" ]; then
        continue
    fi
    SEEN[$target_dir]=1

    if [ ! -d "$target_dir" ]; then
        echo "Skipping $target_subdir: directory does not exist"
        continue
    fi

    echo "Resetting $target_subdir"

    (
        cd "$target_dir"
        if [ -d ".git/rebase-apply" ]; then
            git am --abort || true
        fi
        git reset --hard m/lineage-20.0
    )
done < <(find "$SCRIPT_DIR" -type f -name "*.patch" -not -path "*/.git/*" | sort)

echo "Done."
