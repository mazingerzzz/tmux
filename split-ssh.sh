#!/bin/bash - 
#===============================================================================
#
#          FILE: split-ssh.sh
# 
#         USAGE: ./split-ssh.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 10/02/2014 16:42
#      REVISION:  ---
#===============================================================================


# From tmux, split the current pane and start a second ssh session if a
# first was running.
# To avoid having to login again, use the ControlMaster and ControlPath
# options of ssh_config(5).

# get the tty of the active pane
CTTY=$(tmux list-panes -F '#{pane_active} #{pane_tty}'| awk -F"/" '/^1/ { print $3"/"$4 }')

# look for processes attached to this tty, checking for the controlling
# one, if it's named "ssh"; print the command as it was launched (same
# arguments)
COMMAND=$(ps faux|grep "$CTTY"|grep -v grep|grep -v bash|grep -i ssh|awk '{print $NF}'|sed -e "s/\/dev\///g")

# no matching process was found
if [ -z "$COMMAND" ]; then
        exit 1
fi

case $1 in
        h) tmux split-window -h "exec ssh $COMMAND -t 'sudo su -'"
                ;;
        v) tmux split-window -v "exec ssh $COMMAND -t 'sudo su -'"
                ;;
        *) tmux new-window "exec ssh $COMMAND -t 'sudo su -'"
                ;;
esac

