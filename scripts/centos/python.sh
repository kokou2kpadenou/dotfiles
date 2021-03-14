#!/bin/sh

sudo dnf install python2 python38

python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim
