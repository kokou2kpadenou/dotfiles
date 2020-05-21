#!/bin/sh
###############################################################################
#                                                                             #
#                                                                             #
#                                                                             #
#                                                                             #
###############################################################################

# Session Name
session="MYAPPSS"

if ! tmux has-session -t $session; then
    ##########################################################################
    #   PUT THE PROJECT SESSION SCRIPT HERE
    ##########################################################################
    
    tmux new -s $session -d -n FRONT-END -c ~/Documents/pratice/tosee
    tmux new-window -t $session:2
    tmux split-window -t $session:2 -v
    tmux send-keys -t $session:1 'vim .' Enter
    tmux send-keys -t $session:2.0 'echo my prefere are' Enter
    tmux send-keys -t $session:2.1 'echo Here we are again' Enter
    tmux new-window -t $session:3 mongo
    tmux split-window -t $session:3 top
    tmux rename-window -t $session:2 BACK-END
    tmux rename-window -t $session:3 DATABASE

    ##########################################################################
fi
tmux attach -t $session:1
