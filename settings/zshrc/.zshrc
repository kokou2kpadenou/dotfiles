export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="minimal"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	fzf
	golang
	npm
	bundler
	dotenv
	vi-mode
	colored-man-pages
	docker
	docker-compose
	zsh-interactive-cd
)

source $ZSH/oh-my-zsh.sh

# User configuration
if [[ -n $DISPLAY || -n $WAYLAND_DISPLAY || $OSTYPE == darwin* ]]; then
  eval "$(starship init zsh)"

  nvim_docker="$DOTFILES/tools/plaisir-editeur/.bash_nvim"
  [[ -r $nvim_docker ]] && source "$nvim_docker"
fi

# fzf completion and key-bindings
fzf_base="/usr/share/fzf"

if command -v brew >/dev/null 2>&1; then
  if brew_prefix="$(brew --prefix fzf 2>/dev/null)"; then
    fzf_base="$brew_prefix/shell"
  fi
fi

for file in completion.zsh key-bindings.zsh; do
  [[ -r "$fzf_base/$file" ]] && source "$fzf_base/$file"
done
