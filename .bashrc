# If not running interactively, don't do anything.
[[ "$-" != *i* ]] && return

# Bash {{{
shopt -s no_empty_cmd_completion
#}}}

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
  alias gcd='cd "$(g rev-parse --show-toplevel)"'
  alias gco='g checkout'
  alias gd='g diff --ignore-space-change'
  alias gdw='gd --word-diff-regex="\w+"'
  alias gl='g log --graph --decorate --oneline'
  alias gp='g push'
  alias gs='g status --short --branch'

  # Autocompletion with aliases
  if type __git_complete &>/dev/null; then
    type __git_main &>/dev/null && __git_complete g __git_main
    type _git_add &>/dev/null && __git_complete ga _git_add
    type _git_branch &>/dev/null && __git_complete gb _git_add
    type _git_commit &>/dev/null && __git_complete gc _git_commit
    type _git_checkout &>/dev/null && __git_complete gco _git_checkout
    if type _git_diff &>/dev/null; then
      __git_complete gd _git_diff
      __git_complete gdc _git_diff
      __git_complete gdw _git_diff
      __git_complete gdwc _git_diff
    fi
    type _git_log &>/dev/null && __git_complete gl _git_log
    type _git_push &>/dev/null && __git_complete gp _git_push
    type _git_status &>/dev/null && __git_complete gs _git_status
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
