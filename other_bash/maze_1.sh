#!/bin/bash

# Function to check if the maze is valid
check_maze_validity() {
    local maze_file="$1"
    local width="$2"
    local height="$3"

    # Check if maze file exists
    if [ ! -f "$maze_file" ]; then
        echo "Maze file '$maze_file' not found."
        return 1
    fi

    # Check if width and height are within the accepted range
    if [[ "$width" -lt 5 || "$width" -gt 100 || "$height" -lt 5 || "$height" -gt 100 ]]; then
        echo "Invalid maze dimensions: width and height must be between 5 and 100."
        return 1
    fi

    # Check if maze dimensions match the specified width and height
    local actual_width=$(awk 'NR==1 { print length($0) }' "$maze_file")
    local actual_height=$(wc -l < "$maze_file")
    if [[ "$actual_width" -ne "$width" || "$actual_height" -ne "$height" ]]; then
        echo "Mismatch in maze dimensions: expected width=$width, height=$height, but actual width=$actual_width, height=$actual_height."
        return 1
    fi

    # Check if maze contains only valid characters
    local invalid_chars=$(grep -vE '^[#S E]+$' "$maze_file")
    if [ -n "$invalid_chars" ]; then
        echo "Invalid characters found in the maze: $invalid_chars"
        return 1
    fi

    echo "Maze is valid."
    return 0
}

# Main script

# Check if correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <maze_file> <width> <height>"
    exit 1
fi

# take the stdin and assign it to the variables
maze_file="$1"
width="$2"
height="$3"

# Check maze validity
check_maze_validity "$maze_file" "$width" "$height"
