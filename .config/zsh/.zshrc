setopt PRINT_EIGHT_BIT

if type brew &>/dev/null; then
  # zsh-completions {{{
  local zsh_completions_dir="$(brew --prefix)/share/zsh-completions"
  if [ -d $zsh_completions_dir ]; then
    fpath=($zsh_completions_dir $fpath)
  fi
  #}}}
fi

autoload -Uz compinit && compinit
autoload -Uz colors && colors

# History {{{
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
#}}}

if type ghq &>/dev/null && type peco &>/dev/null; then
  function ghqcd() {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -d "$selected_dir" ]; then
      if [ -t 1 ]; then
        cd ${selected_dir}
      fi
    fi
  }
fi
