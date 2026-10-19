
# ╔══════════════════════════════════════════════════════╗
# ║                  mishk225 .zshrc                     ║
# ╚══════════════════════════════════════════════════════╝

# ─── Powerlevel10k Instant Prompt ────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Terminal ────────────────────────────────────────────
clear() {
    printf '\033[3J\033[2J\033[H'
}

PROMPT_EOL_MARK=''

# ─── Completion ──────────────────────────────────────────
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ─── Weather CLI Completion ──────────────────────────────
_weather() {
    local -a cities languages

    cities=(
        'kattakurgan:Каттакурган / Kattaqoʻrgʻon'
        'samarqand:Самарканд / Samarqand'
        'tashkent:Ташкент / Toshkent'
        'bukhara:Бухара / Buxoro'
    )

    languages=(
        'ru:Русский язык'
        'en:English language'
        'uz:Oʻzbek tili'
    )

    _arguments \
        '(-h --help)'{-h,--help}'[Показать справку]' \
        '(-l --lang)'{-l,--lang}'[Указать язык]:язык:(ru en uz)' \
        '1:город или язык:->arg1' \
        '2:город или язык:->arg2' && return 0

    case "$state" in
        arg1)
            _describe -t cities 'город' cities
            _describe -t languages 'язык' languages
            ;;
        arg2)
            _describe -t languages 'язык' languages
            _describe -t cities 'город' cities
            ;;
    esac
}

compdef _weather weather

# ─── History ─────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# ─── Autosuggestions ─────────────────────────────────────
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#666666'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ─── Keybindings ─────────────────────────────────────────
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

bindkey '^[f' forward-word
bindkey '^[b' backward-word

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# ─── PATH ────────────────────────────────────────────────
typeset -U path

path=(
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "$HOME/flutter/bin"
    "$HOME/development/flutter/bin"
    /opt/zig
    $path
    /snap/bin
)

export PATH

# ─── FZF ─────────────────────────────────────────────────
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
fi

# ─── Aliases: Python ─────────────────────────────────────
alias pa='python3 app.py'
alias pm='python3 main.py'

alias va='vim app.py'
alias vm='vim main.py'
alias vzsh='vim ~/.zshrc'
alias szsh='source ~/.zshrc'

# ─── Aliases: NASM ───────────────────────────────────────
alias ncomp='nasm -f elf64 main.nasm -o main.o'
alias ldcomp='ld main.o -o main'

# ─── Aliases: Files ──────────────────────────────────────
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ─── Aliases: Git ────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate -15'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias ga.='git add .'

# ─── Aliases: Misc ───────────────────────────────────────
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias cls='clear'
alias showpath='echo "$PATH" | tr ":" "\n"'
alias cljm='clojure -M -m main'

# ─── Functions ───────────────────────────────────────────
rmf() {
    rm -r "$@"
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

ff() {
    find . -name "*$1*" 2>/dev/null
}

rg() {
    grep -r --color=auto "$1" . 2>/dev/null
}

ports() {
    ss -tulpn | grep LISTEN
}

archive() {
    tar -czf "${1%/}.tar.gz" "$1" &&
        echo "✓ ${1%/}.tar.gz created"
}

fh() {
    local selected
    selected=$(fc -ln 1 | fzf --tac --no-sort) || return
    print -z -- "$selected"
}

# ─── Syntax Highlighting ─────────────────────────────────
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ─── Powerlevel10k ───────────────────────────────────────
if [[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [[ -f "$HOME/.p10k.zsh" ]]; then
    source "$HOME/.p10k.zsh"
fi


