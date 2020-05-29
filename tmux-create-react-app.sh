#!/bin/sh
###############################################################################
#
#
#
#
###############################################################################

# Read the project directory
read -e -p "Project Directory: " wrkdir
# Get the last directory from the path
subdir=$(basename $wrkdir)
session=${subdir^^}

if [ -d $wrkdir ]
then
    if ! tmux has-session -t $session; then
        tmux new -s $session -d -n DEV -c $wrkdir
        tmux send-keys -t $session:1 'vim .' Enter
        tmux split-window -p 8 -t $session:1 -c $wrkdir
        tmux send-keys -t $session:1.1 'npm start' Enter
        tmux split-window -h -t $session:1 -c $wrkdir
        tmux select-pane -t 0 
        tmux new-window -t $session:2 -n TEST -c $wrkdir
    fi
    tmux attach -t $session:1
else
    echo "Error: Directory ${wrkdir} DOES NOT exists."
fi
