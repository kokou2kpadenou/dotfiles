#!/bin/sh
###############################################################################
#
#                   ReactJS Development Environment
#                   Based on Tmux 2.7+ and Vim 8.0+
#                           -----0000-----
#                     Write by: Kokou W Kpadenou
#                        ver0.1 of 06/19/2020
#
###############################################################################

# Get the project directory
wrkdir=""

while [ "$wrkdir" = "" ]; do
    if [ "$#" -gt "0" ]; then
        wrkdir=$1
    else
        read -e -p "Project Directory: " wrkdir
    fi
done

if [ -d $wrkdir ]
then
    # Get the last directory from the path
    subdir=$(basename $wrkdir)
    # The name of the session in uppercase
    session=${subdir^^}
    # Check if the session is in the list of tmux opened sessions
    sessionexist=$(tmux ls | grep $session)

    if [ "$sessionexist" = "" ]; then
        tmux new -s $session -d -n DEV -c $wrkdir -x $(tput cols) -y $(tput lines)
        tmux send-keys -t $session:1 'vim .' Enter
        tmux split-window -p 18 -t $session:1 -c $wrkdir
        tmux split-window -h -t $session:1 -c $wrkdir
        tmux select-pane -t 0 
        tmux new-window -t $session:2 -n TEST -c $wrkdir
    fi
    tmux attach -t $session:1
else
    echo "Error: Directory ${wrkdir} DOES NOT exists."
fi
