setopt NO_GLOBAL_RCS
setopt COMBINING_CHARS
export LANG=ja_JP.UTF-8

# $PATH {{{
typeset -U path
if test -x /usr/libexec/path_helper; then
  eval `"$_" -s`
else
  ;
fi

# Homebrew on Linux
test -x "$HOME/.linuxbrew/bin/brew" && eval $("$_" shellenv)
test -x "/home/linuxbrew/.linuxbrew/bin/brew" && eval $("$_" shellenv)
#}}}

# XDG Base Directory Specification {{{
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
#}}}

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ghq {{{
if (( $+commands[ghq] )); then
  export GHQ_ROOT="$XDG_DATA_HOME/ghq"
fi
#}}}
