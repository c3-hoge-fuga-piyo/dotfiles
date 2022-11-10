# XDG Base Directory Specification {{{
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
#}}}

# Zsh {{{
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export LANG=ja_JP.UTF-8

setopt NO_GLOBAL_RCS
setopt COMBINING_CHARS
#}}}

# $PATH {{{
typeset -U path
if test -x /usr/libexec/path_helper; then
  eval `"$_" -s`
else
  ;
fi
#}}}

# Homebrew {{{
# Homebrew on Linux
test -x "$HOME/.linuxbrew/bin/brew" && eval $("$_" shellenv)
test -x "/home/linuxbrew/.linuxbrew/bin/brew" && eval $("$_" shellenv)

if [ "$(uname)" = 'Darwin' ] && [ "$(uname -m)" = 'arm64' ]; then
  # Homebrew on Apple M1
  test -x "/opt/homebrew/bin/brew" && eval $("$_" shellenv)
fi

if (( $+commands[brew] )); then
  # https://docs.brew.sh/Manpage#environment {{{
  # HOMEBREW_GITHUB_API_TOKEN
  test -f "$HOME/.homebrew_github_api_token" && . "$_"

  export HOMEBREW_NO_ANALYTICS=true
  # }}}
fi
#}}}

# ghq {{{
if (( $+commands[ghq] )); then
  export GHQ_ROOT="$XDG_DATA_HOME/ghq"
fi
#}}}

test -f "$ZDOTDIR/.zshenv.local" && . "$_"
