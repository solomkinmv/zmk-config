#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

"$repo_root/scripts/render-keymap.sh"

yaml="$repo_root/docs/keymap/cradio.yaml"
svg="$repo_root/docs/keymap/cradio.svg"

test -s "$yaml"
test -s "$svg"

for layer in 'Base' 'Media & Navigation' 'Bluetooth & Mouse' 'Numbers & Functions' 'Symbols'; do
    rg --quiet --fixed-strings "$layer" "$yaml"
done

for activator in 'h: Nav' 'h: Mouse' 'h: Num/Fn' 'h: Sym'; do
    rg --quiet --fixed-strings "$activator" "$yaml"
done

for label in 'Caps Word' 'Mouse Left' 'Mouse Right' 'Scroll Left' 'Scroll Down' 'Scroll Up' 'Scroll Right'; do
    rg --quiet --fixed-strings "$label" "$yaml"
done

rg --quiet 'class="keymap"' "$svg"

if rg --quiet '&(caps_word|mkp|mmv|msc)' "$yaml"; then
    echo 'raw ZMK bindings remain in parsed keymap' >&2
    exit 1
fi
