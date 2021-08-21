# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/texlive/2021/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2021/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2021/texmf-dist/doc/info:$INFOPATH

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

autoload -U colors && colors
PS1="%B%{$fg[red]%}%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%(?..[%?] )%{$fg[red]%}%{$reset_color%}$%b "

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

export TERM=xterm-256color

export XIM_PROGRAM=fcitx5
export XIM=fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"

export QT_QPA_PLATFORMTHEME=qt5ct

export MOZ_USE_XINPUT2="1"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias sudo="sudo -E"

alias auth='chromium --no-proxy-server'
alias zathura="zathura --fork"
alias za=zathura\ -c\ ~/.config/zathura/translusent
alias syssus="systemctl suspend"
alias vimwiki="vim -c ':VimwikiIndex'"
#alias code="prime-run code"


# My own functions
dorm () {
	killall picom
	xrandr --output DP3 --mode 2560x1440 --left-of eDP1 --rotate left || xrandr --output DP2 --mode 2560x1440 --left-of eDP1 --rotate left
	bluetoothctl power on
#	nmcli radio wifi off
	auth www.bing.com &
	~/.fehbg 
}

dorm () {
	#killall picom
	xrandr --output DP3 --mode 2560x1440 --above eDP1 || xrandr --output DP2 --mode 2560x1440 --above eDP1
	bluetoothctl power on
	nmcli radio wifi off
	auth www.bing.com &
	~/.fehbg 
}

home () {
	#killall picom
	xrandr --output DP3 --mode 2560x1440 --above eDP1 || xrandr --output DP2 --mode 2560x1440 --above eDP1
	bluetoothctl power on
	~/.fehbg 
}


source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source /usr/share/zsh/plugins/zsh-z/zsh-z.plugin.zsh

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
