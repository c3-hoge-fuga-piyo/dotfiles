# Bash {{{
if type vim &>/dev/null; then
  export EDITOR=vim
fi
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

# Java {{{
if [[ -f /usr/libexec/java_home ]]; then
  JAVA_HOME="$(/usr/libexec/java_home)"
  export JAVA_HOME
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
  # shellcheck source=/dev/null
  test -f "$HOME/.homebrew_github_api_token" && . "$_"

  export HOMEBREW_NO_ANALYTICS=1
  #}}}

  # mono {{{
  if [[ "$(brew --prefix mono)" ]]; then
    export MONO_GAC_PREFIX
    MONO_GAC_PREFIX="$(brew --prefix)"
  fi
  #}}}
fi
#}}}

# shellcheck source=/dev/null
test -f "$HOME/.bash_profile.local" && . "$_"
# shellcheck source=/dev/null
test -f "$HOME/.bashrc" && . "$_"
