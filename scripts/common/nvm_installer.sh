#!/bin/bash

if [ "$1" = "" ]; then
  NODEVERSION="12"
fi

(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash) && \
  source ~/.bashrc && \
  nvm inatall ${NODEVERSION} && \
  npm i -g neovim

