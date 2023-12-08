export GPG_TTY=$(tty)
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/bin:"$PATH"
export PATH=/usr/local/bin:"$PATH"
export PATH=/usr/bin/vendor_perl:"$PATH"
export PATH="$HOME"/.local/bin:"$PATH"
export PATH="$HOME"/.ghcup/bin:"$PATH"
# export PATH="$HOME"/tmp/pure-ftpd/sbin:"$PATH"

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt INC_APPEND_HISTORY

setopt autopushd

autoload -U colors && colors
PS1="%B%{$fg[red]%}%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%(?..[%?] )%{$fg[red]%}%{$reset_color%}$%b "

source /usr/share/zsh/plugins/zsh-z/zsh-z.plugin.zsh

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit


# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Proxys
export all_proxy=http://127.0.0.1:7890
export ALL_PROXY=http://127.0.0.1:7890
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890

if [ "$TERM" = "linux" ]; then
    /bin/echo -e "
    \e]P0292d3e
    \e]P1f07178
    \e]P2c3e88d
    \e]P3ffcb6b
    \e]P482aaff
    \e]P5c792ea
    \e]P689ddff
    \e]P7c5cdcb
    \e]P8676e95
    \e]P9f07178
    \e]PAc3e88d
    \e]PBffcb6b
    \e]PC82aaff
    \e]PDc792ea
    \e]PE89ddff
    \e]PFffffff
    "
    # get rid of artifacts
    clear
fi

export QT_QPA_PLATFORMTHEME=qt5ct

export EDITOR=vim
export TERMINAL=alacritty
export MANPAGER='nvim +Man!'
# export MANPATH="/usr/local/man:$MANPATH"

alias ls="ls --color=auto"

alias auth='chromium --no-proxy-server'
alias zathura="zathura --fork"
alias za=zathura\ -c\ ~/.config/zathura/translusent
alias syssus="systemctl suspend"
alias vimwiki="vim -c ':VimwikiIndex'"
alias lf=lfub

source /etc/profile.d/lfcd.sh
#alias code="prime-run code"

countdown(){
    date1=$((`date +%s` + $1));
    while [ "$date1" -ge `date +%s` ]; do
        ## Is this more than 24h away?
        days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
        echo -ne "\r$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)";
        sleep 0.1
    done
}
stopwatch(){
    date1=`date +%s`;
    while true; do
        days=$(( $(($(date +%s) - date1)) / 86400 ))
        echo -ne "\r$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)";
        sleep 0.1
    done
}

screencast(){
    ffmpeg \
	-f x11grab \
	-s "$(xdpyinfo | awk '/dimensions/ {print $2;}')" \
	-i "$DISPLAY" \
 	-c:v libx264 -qp 0 -r 30 \
	"$HOME/video-$(date '+%y%m%d-%H%M-%S').mkv"
}

# source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
# Disable the cursor style feature
# ZVM_CURSOR_STYLE_ENABLED=false

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

set -o emacs

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
#bindkey -a '^[[3~' vi-delete-char
bindkey '^[[3~' delete-char

source /usr/share/fzf/completion.zsh

if [[ -e ~/reminder ]]; then
    source ~/reminder
fi

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"

export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod

