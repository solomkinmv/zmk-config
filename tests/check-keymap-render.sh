#!/bin/sh

set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

"$repo_root/scripts/render-keymap.sh"

yaml="$repo_root/docs/keymap/cradio.yaml"
svg="$repo_root/docs/keymap/cradio.svg"

test -s "$yaml"
test -s "$svg"

for layer in 'Base' 'Media & Navigation' 'Bluetooth & Mouse' 'Numbers & Functions' 'Symbols'; do
    grep -Fq "$layer" "$yaml"
done

for activator in 'h: Nav' 'h: Mouse' 'h: Num/Fn' 'h: Sym'; do
    grep -Fq "$activator" "$yaml"
done

for label in 'Caps Word' 'Mouse Left' 'Mouse Right' 'Scroll Left' 'Scroll Down' 'Scroll Up' 'Scroll Right'; do
    grep -Fq "$label" "$yaml"
done

grep -q 'class="keymap"' "$svg"

if grep -Eq '&(caps_word|mkp|mmv|msc)' "$yaml"; then
    echo 'raw ZMK bindings remain in parsed keymap' >&2
    exit 1
fi
