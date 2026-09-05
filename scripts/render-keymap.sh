#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
output_dir="$repo_root/docs/keymap"
config="$repo_root/keymap_drawer.config.yaml"
keymap="$repo_root/config/cradio.keymap"
parsed="$output_dir/cradio.yaml"
svg="$output_dir/cradio.svg"

if ! command -v uvx >/dev/null 2>&1; then
    echo 'uvx is required; install uv from https://docs.astral.sh/uv/' >&2
    exit 1
fi

mkdir -p "$output_dir"

uvx --from keymap-drawer==0.23.0 keymap -c "$config" parse \
    --columns 10 \
    --zmk-keymap "$keymap" \
    --output "$parsed"

uvx --from keymap-drawer==0.23.0 keymap -c "$config" draw \
    --zmk-keyboard cradio \
    --output "$svg" \
    "$parsed"

printf 'Rendered %s\n' "$svg"
