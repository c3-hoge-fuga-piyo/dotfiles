# If not running interactively, don't do anything.
[[ "$-" != *i* ]] && return

# direnv {{{
if type direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi
#}}}

test -f "$HOME/.bashrc.local" && . "$_"
