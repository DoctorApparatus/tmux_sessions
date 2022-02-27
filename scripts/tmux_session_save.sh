#!/bin/bash

if [ ! -d ~/.tmux/sessions/ ];
then
	mkdir ~/.tmux/sessions/
fi
session_name="$( tmux display-message -p '#S' )"
windows="$( tmux list-windows -t "$session_name" )"

echo -en "" > ~/.tmux/sessions/$session_name.session

#
# SAVE
#
#echo "$session_name:"
while read window; do
	window="$( echo -en $window | egrep -o "[0-9A-Za-z]+:" | sed -e 's/:$//' | tr -d '\n' )"

	#echo "window=$window:"
	path="$( tmux display-message -p -t "$session_name":"$window" '#{pane_current_path}' )"
	#echo "path=$path"

	panes="0"
	while read pane; do

		#echo "pane=$pane:"

		pane_ttys="$( tmux display-message -t "$session_name:$window.$pane" -p '#{pane_tty}' )"
		while read pane_tty; do

			pane_tty="$( echo "$pane_tty" | sed -e 's/\/dev\///g' )"

			save_line="$session_name:$window:$pane:$path:"
			if pgrep --terminal "$pane_tty" "nvim" > /dev/null; then
				echo "$save_line"nvim >> ~/.tmux/sessions/$session_name.session
			else
				echo "$save_line"$SHELL >> ~/.tmux/sessions/$session_name.session
			fi

		done <<< "$pane_ttys"

	done <<< "$panes"

done <<< "$windows"
