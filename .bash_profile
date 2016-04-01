# Bash Options {{{
if type vim &>/dev/null; then
  export EDITOR=vim
fi

# History Options {{{
export HISTCONTROL=erasedups
export HISTSIZE=5000
export HISTFILESIZE=5000
#}}}
#}}}

# XDG Base Directory Specification {{{
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
#}}}

# Go {{{
if type go &>/dev/null; then
  export GOPATH="$XDG_DATA_HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi
#}}}

# ghq {{{
if type ghq &>/dev/null; then
  export GHQ_ROOT="$XDG_DATA_HOME/ghq"
fi
#}}}

# Homebrew {{{
if type brew &>/dev/null; then
  # Homebrew Options {{{
  test -f "$HOME/.homebrew_github_api_token" && . "$_"
  #}}}

  # bash-completion {{{
  test -f "$(brew --prefix)/etc/bash_completion" && . "$_"
  #}}}

  # mono {{{
  if [[ "$(brew --prefix mono)" ]]; then
    export MONO_GAC_PREFIX="$(brew --prefix)"
  fi
  #}}}
fi
#}}}

test -f "$HOME/.bash_profile.local" && . "$_"
test -f "$HOME/.bashrc" && . "$_"
