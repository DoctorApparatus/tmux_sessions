#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key S run-shell "$CURRENT_DIR/scripts/tmux_session_save.sh"
tmux bind-key L run-shell "$CURRENT_DIR/scripts/tmux_session_load.sh"
