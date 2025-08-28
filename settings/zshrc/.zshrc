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

if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
	# startship
	eval "$(starship init zsh)"

	# Access neovim in docker
	if [ -e "$DOTFILES/tools/plaisir-editeur/.bash_nvim" ]; then
		source "$DOTFILES/tools/plaisir-editeur/.bash_nvim"
	fi
fi

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
