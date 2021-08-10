#!/bin/bash

git config --file ~/.gitconfig.local user.name "$1"
git config --file ~/.gitconfig.local user.email "$2"
