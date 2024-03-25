#!/bin/bash

# Function to check if the maze is valid using the C program
check_maze_validity() {
    local maze_file="$1"
    local width="$2"
    local height="$3"
    local maze_file_test="$4"
    
    # Run the maze C program with the maze file and dimensions
    ./maze "$maze_file" "$width" "$height" < "$maze_file_test"
    
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
    # local actual_height=$(wc -l < "$maze_file")
    local actual_height=$(awk '/./ { last_non_empty_line = NR } END { print last_non_empty_line }' "$maze_file") # Count non-empty lines
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

    echo "$maze_file is valid."
    return 0
}

# Main script
# Specify the paths for maze files and their test files
maze_files_path="mazes"
maze_files_test_path="mazes_tests"

# Test all the files in the maze_files_test_path
for maze_file_test in $maze_files_test_path/*_test.txt; do
    echo "Testing maze file: $maze_file_test"
    if [ -f "$maze_file_test" ]; then
        # Extract maze file name without the "_test.txt" suffix
        maze_file=$(basename "$maze_file_test" "_test.txt")
        echo "Maze file: $maze_file"
        # Extract maze dimensions from the maze file name
        if [[ "$maze_file" =~ ([0-9]+)x([0-9]+) ]]; then
            width="${BASH_REMATCH[1]}"
            height="${BASH_REMATCH[2]}"
        else
            echo "Failed to extract dimensions from file name: $maze_file"
            continue
        fi

        # Construct the full path of the maze file
        maze_file_full_path="$maze_files_path/$maze_file.txt"

        # Check maze validity using the C program
        check_maze_validity "$maze_file_full_path" "$width" "$height" "$maze_file_test"
    else
        echo "No test file found for maze: $maze_file_test"
    fi
done