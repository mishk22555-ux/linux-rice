# enable powerlevel10k instant prompt. should stay close to the top of ~/.zshrc.
# initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${xdg_cache_home:-$home/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${xdg_cache_home:-$home/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ╔══════════════════════════════════════════════════════╗
# ║                  mishk225 .zshrc                     ║
# ╚══════════════════════════════════════════════════════╝

# ─── terminal ────────────────────────────────────────────
clear() {
    printf '\033[3j\033[2j\033[h'
}

prompt_eol_mark=''

# ─── completion ──────────────────────────────────────────
autoload -uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)ls_colors}
zstyle ':completion:*' matcher-list 'm:{a-z}={a-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%f{yellow}-- %d --%f'

# ─── weather cli completion ──────────────────────────────
_weather() {
    local -a cities languages

    cities=(
        'kattakurgan:каттакурган / kattaqoʻrgʻon'
        'samarqand:самарканд / samarqand'
        'tashkent:ташкент / toshkent'
        'bukhara:бухара / buxoro'
    )

    languages=(
        'ru:русский язык'
        'en:english language'
        'uz:oʻzbek tili'
    )

    _arguments \
        '(-h --help)'{-h,--help}'[показать справку]' \
        '(-l --lang)'{-l,--lang}'[указать язык]:язык:(ru en uz)' \
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

# ─── history ─────────────────────────────────────────────
histfile="$home/.zsh_history"
histsize=10000
savehist=10000

setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
setopt hist_reduce_blanks

# ─── autosuggestions ─────────────────────────────────────
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

zsh_autosuggest_highlight_style='fg=#666666'
zsh_autosuggest_strategy=(history completion)

# ─── keybindings ─────────────────────────────────────────
bindkey '^[[a' history-search-backward
bindkey '^[[b' history-search-forward

bindkey '^[f' forward-word
bindkey '^[b' backward-word

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# ─── path ────────────────────────────────────────────────
export path="$home/.local/bin:$path"
export path="$home/.npm-global/bin:$path"
export path="$home/flutter/bin:$path"
export path="$home/development/flutter/bin:$path"
export path="/opt/zig:$path"
export path="$path:/snap/bin"

# ─── fzf ─────────────────────────────────────────────────
export fzf_default_opts='--height=40% --layout=reverse --border --info=inline'

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
fi

# ─── aliases: python ─────────────────────────────────────
alias pa='python3 app.py'
alias pm='python3 main.py'

alias va='vim app.py'
alias vm='vim main.py'
alias vzsh='vim ~/.zshrc'
alias szsh='source ~/.zshrc'

# ─── aliases: nasm ───────────────────────────────────────
alias ncomp='nasm -f elf64 main.nasm -o main.o'
alias ldcomp='ld main.o -o main'

# ─── aliases: files ──────────────────────────────────────
alias ll='ls -la --color=auto'
alias la='ls -a --color=auto'
alias l='ls -cf --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ─── aliases: git ────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -a'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate -15'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias ga.='git add .'

# ─── aliases: misc ───────────────────────────────────────
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias cls='clear'
alias path='echo "$path" | tr ":" "\n"'
alias cljm='clojure -m -m main'

# ─── functions ───────────────────────────────────────────
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
    ss -tulpn | grep listen
}

archive() {
    tar -czf "${1%/}.tar.gz" "$1" &&
        echo "✓ ${1%/}.tar.gz created"
}

fh() {
    local command
    command=$(fc -ln 1 | fzf --tac --no-sort) || return
    print -z -- "$command"
}

# ─── syntax highlighting ─────────────────────────────────
# load near the end of .zshrc
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ─── powerlevel10k ───────────────────────────────────────
if [[ -f "$home/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source "$home/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [[ -f "$home/.p10k.zsh" ]]; then
    source "$home/.p10k.zsh"
fi

# to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

