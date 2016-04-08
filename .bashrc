# If not running interactively, don't do anything.
[[ "$-" != *i* ]] && return

# Prompt {{{
# Git {{{
show_current_git_branch='true'
if type git &>/dev/null; then
  show_current_git_branch='__git_ps1'

  if type __git_ps1 &>/dev/null; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM=1
  else
    function __git_ps1() {
      local current_branch_name
      current_branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [[ -z "$current_branch_name" ]]; then
        echo ''
      else
        echo " (${current_branch_name})"
      fi
    }
  fi
fi
#}}}

export PS1
PS1='\[\e[0;36m\][\D{%FT%T}] \[\e[0;32m\]\W\[\e[0;33m\]$(${show_current_git_branch})\n\[\e[0;32m\]\$ \[\e[0m\]'
#}}}

# direnv {{{
if type direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi
#}}}

# shellcheck source=/dev/null
test -f "$HOME/.bashrc.local" && . "$_"
