setopt PRINT_EIGHT_BIT

if (( $+commands[brew] )); then
  local brew_prefix="$(brew --prefix)"

  # zsh-completions {{{
  test -d "$brew_prefix/share/zsh-completions" && fpath=("$_" $fpath)
  #}}}

  # git-prompt {{{
  test -f "$brew_prefix/etc/bash_completion.d/git-prompt.sh" && . "$_"
  #}}}

  # git/contrib {{{
  local git_contrib_path="$brew_prefix/share/git-core/contrib"
  if [ -d $git_contrib_path ]; then
    # diff-highlight
    test -d "$git_contrib_path/diff-highlight" && path=("$_" $path)
  fi
  #}}}
fi

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

autoload -Uz colors && colors

# History {{{
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
#}}}

local show_vcs_info="true"

# Git {{{
if (( $+commands[git] )); then
  if (( $+functions[__git_ps1] )); then
    show_vcs_info="__git_ps1"
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWSTASHSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    export GIT_PS1_SHOWUPSTREAM=auto
    export GIT_PS1_DESCRIBE_STYLE=default
    export GIT_PS1_SHOWCOLORHINTS=true
  fi
fi
#}}}

if (( $+commands[ghq] && $+commands[peco] )); then
  function ghqcd() {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -d "$selected_dir" ]; then
      if [ -t 1 ]; then
        cd ${selected_dir}
      fi
    fi
  }
fi

# Prompt {{{
setopt PROMPT_SUBST

local timestamp="${fg[cyan]}[%D{%Y-%m-%d}T%*]"
local workspace="${fg[green]}%c${reset_color}"'$($show_vcs_info)'
local prompt="${fg[green]}%#"
PROMPT="$timestamp $workspace"$'\n'"$prompt ${reset_color}"
#}}}

test -f "$ZDOTDIR/.zshrc.local" && . "$_"
