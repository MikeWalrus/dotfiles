#! /usr/bin/bash

main() {
    local is_first_line=true

    while read -r pw_node; do
        if [[ "$is_first_line" == "true" ]]; then
            stream-pw-node.sh "$pw_node" "$@"
            return
        fi
        is_first_line=false
    done < <(PYTHONUNBUFFERED=true xdpss)
}

main "$@"
