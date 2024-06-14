#! /usr/bin/zsh

main() {
    typeset -a email_passwd
    email_passwd=(${(f)"$(< ~/.config/dlercloud)"})
    typeset email=${email_passwd[1]}
    typeset passwd=${email_passwd[2]}
    typeset token=${email_passwd[3]}
    typeset result=$(curl --data-urlencode access_token=$token -X POST https://dler.pro/api/v1/information)
    typeset ret=$(echo $result | jq -r '.["ret"]')
    if [[ $ret != 200 ]]; then
        echo "Logging in ..."
        result=$(curl --data-urlencode "email=$email" --data-urlencode "passwd=$passwd" -X POST https://dler.pro/api/v1/login)
        ret=$(echo $result | jq -r '.["ret"]')
        if [[ $ret != 200 ]]; then
            echo $result
            echo "Failed to log in."
        fi
        typeset token=$(echo $result | jq -r '.["data"].["token"]')
        sed -i "3s/.*/$token/" ~/.config/dlercloud
    fi
    typeset unused=$(echo $result | jq -r '.["data"]["unused"]')
    typeset plan_time=$(echo $result | jq -r '.["data"]["plan_time"]')
    typeset unused_GiB=$(units -t $unused GiB)
    typeset days=$(( ($(date +%s -d $plan_time) - $(date +%s)) / (60 * 60 * 24) ))
    typeset unused_per_day=$(( unused_GiB / days ))
    # echo unused $unused
    # echo plan_time $plan_time
    # echo unused_GiB $unused_GiB
    # echo days $days
    echo ${unused_per_day}GiB left per day for $days day until $plan_time.
}

main
