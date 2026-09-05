#!/bin/sh

set -u

status=0

require_fixed() {
    file=$1
    expected=$2

    if ! rg --quiet --fixed-strings "$expected" "$file"; then
        printf 'missing from %s: %s\n' "$file" "$expected" >&2
        status=1
    fi
}

reject_pattern() {
    file=$1
    pattern=$2

    if rg --quiet "$pattern" "$file"; then
        printf 'unexpected in %s: %s\n' "$file" "$pattern" >&2
        status=1
    fi
}

require_fixed config/cradio.conf 'CONFIG_ZMK_SLEEP=y'
require_fixed config/cradio.conf 'CONFIG_ZMK_IDLE_SLEEP_TIMEOUT=1800000'
require_fixed config/cradio.conf 'CONFIG_ZMK_POINTING_SMOOTH_SCROLLING=y'

require_fixed config/cradio.keymap 'require-prior-idle-ms = <125>;'
require_fixed config/cradio.keymap '&caps_word'
require_fixed config/cradio.keymap '&msc MOVE_LEFT'
require_fixed config/cradio.keymap '&msc MOVE_DOWN'
require_fixed config/cradio.keymap '&msc MOVE_UP'
require_fixed config/cradio.keymap '&msc MOVE_RIGHT'

reject_pattern config/cradio.keymap '&key_repeat|MB4|MB5|studio_unlock'
reject_pattern config/cradio.conf 'ZMK_STUDIO'

exit "$status"
