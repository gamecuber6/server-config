#!/bin/bash

# Define the name of our tmux session
SESSION="dashboard"

# Check if the session already exists
tmux has-session -t $SESSION 2>/dev/null

# If the session does NOT exist ($? is not 0), build the layout
if [ $? != 0 ]; then
    # 1. Create a new detached session, name it, and start it
    tmux new-session -d -s $SESSION -n "monitor"

    # 2. Left Pane (Pane 0): Start journalctl updating in real-time
    tmux send-keys -t $SESSION:monitor.0 'journalctl -f' C-m

    # 3. Split the window horizontally to create a right side
    # -p 40 means the new right pane takes up 40% of the screen width
    tmux split-window -h -p 40 -t $SESSION:monitor

    # 4. Top Right Pane (Pane 1): Run htop
    tmux send-keys -t $SESSION:monitor.1 'htop' C-m

    # 5. Split the right pane vertically to create a bottom right area
    # -p 45 means the bottom pane takes up 45% of the right column's height
    tmux split-window -v -p 45 -t $SESSION:monitor

    # 6. Bottom Right Pane (Pane 2): Run fastfetch, leaving the prompt open
    # We run 'clear' first to keep it tidy, then 'fastfetch'
    tmux send-keys -t $SESSION:monitor.2 'clear; fastfetch' C-m

    # 7. Select the bottom right pane so your cursor defaults there for typing commands
    tmux select-pane -t $SESSION:monitor.2
fi

# Attach to the session (whether it was just created or already existed)
tmux attach-session -t $SESSION
