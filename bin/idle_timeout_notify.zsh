#! /usr/bin/zsh

pid_file=/tmp/idle_timeout_notify.zsh.pid

get_time() {
    date "+%s.%N"
}

sleep_until() {
    typeset -F until=$1
    typeset -F current_time
    current_time=$(get_time)
    typeset diff=$(( until - current_time ))
    sleep $diff
}

notify() {
    typeset -F start_time=$(get_time)
    typeset -i secs=$1
    printf $$ > $pid_file

    for i in {0..$secs}; do
        id=$(
            notify-send \
                --print-id \
                --expire-time 2000 \
                "Suspend" "in <tt>$(($secs - i))</tt> seconds" \
                --hint int:value:$((100 * i / $secs)) \
                $replace_id[@]
        )
        replace_id=(--replace-id $id)
        sleep_until $(( start_time + i + 1 ))
    done
}

TRAPINT() {
    echo trap int
    if [[ ! -z $id ]]; then
        makoctl dismiss -n $id
        echo dismiss
    fi
    exit
}

cancel() {
    read pid < $pid_file
    pkill -INT -P $pid
    kill -INT $pid
    rm $pid_file
}

subcommand=$1
$subcommand $2
