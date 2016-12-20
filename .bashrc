# If not running interactively, don't do anything.
[[ "$-" != *i* ]] && return

# Bash {{{
shopt -s no_empty_cmd_completion

# History Options {{{
export HISTCONTROL=erasedups
export HISTSIZE=5000
export HISTFILESIZE=5000

# History Sharing
shopt -u histappend
export PROMPT_COMMAND_SYNC_HISTORY='history -a; history -c; history -r'
#}}}
#}}}

# Homebrew {{{
if type brew &>/dev/null; then
  # bash-completion {{{
  # shellcheck source=/dev/null
  test -f "$(brew --prefix)/etc/bash_completion" && . "$_"
  #}}}
fi
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
  alias gcm='gc -m'
  alias gcd='cd "$(g rev-parse --show-toplevel)"'
  alias gco='g checkout'
  alias gcom='gco master'
  alias gcob='gco -b'
  alias gd='g diff --ignore-space-change'
  alias gdw='gd --word-diff-regex="\w+"'
  alias gf='g fetch'
  alias gfp='gf --prune'
  alias gl='g log --graph --decorate --oneline'
  alias gm='g merge'
  alias gmm='gm master'
  alias gp='g push'
  alias gpuo='gp -u origin'
  alias gs='g status --short --branch'
  alias grpo='g remote prune origin'
  alias gwt='g worktree'
  alias gwta='gwt add'
  alias gwtp='gwt prune'

  # Autocompletion with aliases
  if type __git_complete &>/dev/null; then
    type __git_main &>/dev/null && __git_complete g __git_main
    type _git_add &>/dev/null && __git_complete ga _git_add
    type _git_branch &>/dev/null && __git_complete gb _git_add
    type _git_commit &>/dev/null && __git_complete gc _git_commit
    if type _git_checkout &>/dev/null; then
      __git_complete gco _git_checkout
      __git_complete gcom _git_checkout
      __git_complete gcob _git_checkout
    fi
    if type _git_diff &>/dev/null; then
      __git_complete gd _git_diff
      __git_complete gdc _git_diff
      __git_complete gdw _git_diff
      __git_complete gdwc _git_diff
    fi
    if type _git_fetch &>/dev/null; then
      __git_complete gf _git_fetch
      __git_complete gfp _git_fetch
    fi
    type _git_log &>/dev/null && __git_complete gl _git_log
    if type _git_merge &>/dev/null; then
      __git_complete gm _git_merge
      __git_complete gmm _git_merge
    fi
    if type _git_push &>/dev/null; then
      __git_complete gp _git_push
      __git_complete gpuo _git_push
    fi
    type _git_status &>/dev/null && __git_complete gs _git_status
    if type _git_remote &>/dev/null; then
      __git_complete grpo _git_remote
    fi
    if type _git_worktree &>/dev/null; then
      __git_complete gwt _git_worktree
      __git_complete gwta _git_worktree
      __git_complete gwtp _git_worktree
    fi
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
# $PS1 {{{
# Example
#
# [1970-01-01T00:00:00] ~ (master)
# $ _
export PS1='\[\e[0;36m\][\D{%FT%T}] \[\e[0;32m\]\W\[\e[0;33m\]$($show_current_git_branch)\n\[\e[0;32m\]\$ \[\e[0m\]'
#}}}

# $PROMPT_COMMAND {{{
function __eval_prompt_commands {
  export EXIT_STATUS="$?"

  local prompt_command
  for prompt_command in ${!PROMPT_COMMAND_*}; do
    eval "${!prompt_command}"
  done
}

export PROMPT_COMMAND='__eval_prompt_commands'
#}}}
#}}}

# shellcheck source=/dev/null
test -f "$HOME/.bashrc.local" && . "$_"
