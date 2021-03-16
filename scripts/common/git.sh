git config --global user.name "$1"
git config --global user.email "$2"

git config --global color.status auto
git config --global color.branch auto
git config --global color.interactive auto
git config --global color.diff auto

git config --global merge.conflictstyle diff3

git config --global core.editor "$3"

