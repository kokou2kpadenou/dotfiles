export DOTFILES="$HOME/.config/.dotfiles"
export DNVIM_WRKDIR="$HOME/Documents"
export DNVIM_MEMORY=4g
export EDITOR=vim
export TERMINAL=alacritty

if [[ -z "$WAYLAND_DISPLAY" && -n "$DISPLAY" ]]; then
  # Your X11-specific command here
  export DNVIM_XAUTH=/tmp/.docker.xauth
fi

export GOPATH="$HOME/go"

# Define the list of folders
folders_to_add=(
  "$HOME/.local/bin"
  "$GOPATH/bin"
)

# Loop through each folder
for folder in "${folders_to_add[@]}"; do
  if [[ -d "$folder" && ":$PATH:" != *":$folder:"* ]]; then
    PATH="$folder:$PATH"
  fi
done

export PATH

export LANG=en_US.UTF-8
