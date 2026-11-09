#
# ~/.zshrc
#
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.rokit/bin:$PATH"

HISTFILE="$HOME/.zsh_history"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f ~/.cache/wallust/sequences ]] && cat ~/.cache/wallust/sequences

if [[ $TERM != linux ]]; then
  eval "$(starship init zsh)"
else
  PS1='%F{green}%~%f %# '
fi
[[ -f ~/.config/zsh/config.zsh ]] && source ~/.config/zsh/config.zsh
