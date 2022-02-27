#!/bin/bash

session_name="$( tmux display-message -p '#S' )"

config="$( cat ~/.tmux/sessions/$session_name.session )"

if tmux info &> /dev/null; then 
  continue
else
	tmux start-server
fi

while read line; do
	session="$(cut -d':' -f1 <<< "$line")"
	window="$(cut -d':' -f2 <<< "$line")"
	pane="$(cut -d':' -f3 <<< "$line")"
	directory="$(cut -d':' -f4 <<< "$line")"
	command="$(cut -d':' -f5 <<< "$line")"

	tmux has-session "$session" 2>/dev/null
	if [ $? != 0 ]; then
		tmux new -s $session
	fi

	tmux has-session -t "$session:$window" 2>/dev/null
	if [ $? != 0 ]; then
		tmux new-window -t $session:$window 
	fi

	tmux send-keys -t $session:$window "cd $directory; clear" Enter

	if [ "$command" == "nvim" ]; then
		tmux send-keys -t $session:$window "nvim -S" Enter
	fi

done <<< "$config"
