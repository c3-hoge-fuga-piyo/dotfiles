# If not running interactively, don't do anything.
[[ "$-" != *i* ]] && return

# Git {{{
show_current_git_branch='true'

if type git &>/dev/null; then

  show_current_git_branch='__git_ps1'
  if type __git_ps1 &>/dev/null; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM=auto
    export GIT_PS1_DESCRIBE_STYLE=default
    export GIT_PS1_SHOWCOLORHINTS=
  else
    function __git_ps1() {
      local current_branch_name
      current_branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [[ -z "$current_branch_name" ]]; then
        echo ''
      else
        echo " ($current_branch_name)"
      fi
    }
  fi

  # Aliases {{{
  alias g='git'
  alias ga='g add'
  alias gb='g branch --verbose'
  alias gc='g commit --verbose'
  alias gd='g diff --ignore-space-change'
  alias gdc='gd --cached'
  alias gdw='gd --word-diff-regex="\w+"'
  alias gdwc='gdw --cached'
  alias gco='g checkout'
  alias gl='g log --graph --decorate --oneline'
  alias gs='g status --short --branch'

  # Autocompletion with aliases
  if type __git_complete &>/dev/null; then
    type __git_main &>/dev/null && __git_complete g __git_main
  fi
  #}}}
fi
#}}}

# direnv {{{
if type direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi
#}}}

# Prompt {{{
export PS1

# Example
#
# [1970-01-01T00:00:00] ~ (master)
# $ _
PS1='\[\e[0;36m\][\D{%FT%T}] \[\e[0;32m\]\W\[\e[0;33m\]$($show_current_git_branch)\n\[\e[0;32m\]\$ \[\e[0m\]'
#}}}

# shellcheck source=/dev/null
test -f "$HOME/.bashrc.local" && . "$_"
