#! /usr/bin/bash

get_choices() {
    cat /sys/firmware/acpi/platform_profile_choices
}

get_current_profile() {
    cat /sys/firmware/acpi/platform_profile
}

prompt() {
    local choices
    local current_profile
    choices="$1"
    current_profile="$2"
    printf "%s\n" "$choices" |
        rofi -dmenu \
            -p "Platform Profile" \
            -mesg "Also managed by <tt>tlp</tt>." \
            -no-custom \
            -select "$current_profile"
}

main() {
    local choices
    choices="$(get_choices)"
    choices="${choices// /$'\n'}"
    local current_profile
    current_profile="$(get_current_profile)"
    local choice
    choice=$(prompt "$choices" "$current_profile")
    if [[ -z $choice ]]; then
        return
    fi
    printf "%s" "$choice" | pkexec tee /sys/firmware/acpi/platform_profile
}

main
