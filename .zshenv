export LANG=ja_JP.UTF-8

# PATH
if test -x /usr/libexec/path_helper; then
  eval `"$_" -s`
else
  ;
fi

# XDG Base Directory Specification {{{
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
#}}}

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ghq {{{
if type ghq > /dev/null; then
  export GHQ_ROOT="$XDG_DATA_HOME/ghq"
fi
#}}}

setopt NO_GLOBAL_RCS
setopt COMBINING_CHARS
