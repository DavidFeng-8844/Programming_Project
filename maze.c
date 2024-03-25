#include <stdio.h>
#include <stdlib.h>

#define MAX_HEIGHT 50
#define MAX_WIDTH 50

// Function to print the maze
void print_maze(char maze[MAX_HEIGHT][MAX_WIDTH], int height, int width) {
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            printf("%c", maze[i][j]);
        }
        printf("\n");
    }
}

// Function to check if the player can move to a given position
int can_move_to(char maze[MAX_HEIGHT][MAX_WIDTH], int row, int col) {
    return (maze[row][col] == ' ' || maze[row][col] == 'S' || maze[row][col] == 'E');
}

// Function to play the game
void play_game(char maze[MAX_HEIGHT][MAX_WIDTH], int height, int width) {
    int player_row = 0, player_col = 0;

    // Find the starting position
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            if (maze[i][j] == 'S') {
                player_row = i;
                player_col = j;
                break;
            }
        }
    }

    char move;
    while (1) {
        // Print the maze
        print_maze(maze, height, width);

        // Read user input for movement
        printf("Enter your move (W/A/S/D to move, Q to quit): ");
        scanf(" %c", &move);

        // Move the player according to input
        switch (move) {
            case 'W': // Move up
            case 'w':
                if (player_row > 0 && can_move_to(maze, player_row - 1, player_col)) {
                    maze[player_row][player_col] = ' ';
                    player_row--;
                }
                break;
            case 'A': // Move left
            case 'a':
                if (player_col > 0 && can_move_to(maze, player_row, player_col - 1)) {
                    maze[player_row][player_col] = ' ';
                    player_col--;
                }
                break;
            case 'S': // Move down
            case 's':
                if (player_row < height - 1 && can_move_to(maze, player_row + 1, player_col)) {
                    maze[player_row][player_col] = ' ';
                    player_row++;
                }
                break;
            case 'D': // Move right
            case 'd':
                if (player_col < width - 1 && can_move_to(maze, player_row, player_col + 1)) {
                    maze[player_row][player_col] = ' ';
                    player_col++;
                }
                break;
            case 'Q': // Quit
            case 'q':
                printf("Quitting the game.\n");
                return;
            default:
                printf("Invalid move!\n");
        }

        // Check if the player reached the exit
        if (maze[player_row][player_col] == 'E') {
            print_maze(maze, height, width);
            printf("Congratulations! You've reached the exit.\n");
            return;
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <filename> <width> <height>\n", argv[0]);
        return 1;
    }

    char maze[MAX_HEIGHT][MAX_WIDTH];
    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Error: File '%s' not found.\n", argv[1]);
        return 1;
    }

    int width = atoi(argv[2]);
    int height = atoi(argv[3]);

    if (width <= 0 || width > MAX_WIDTH || height <= 0 || height > MAX_HEIGHT) {
        printf("Error: Invalid maze dimensions.\n");
        return 1;
    }

    // Load the maze from file
    for (int i = 0; i < height; i++) {
        if (fgets(maze[i], MAX_WIDTH, file) == NULL) {
            printf("Error: Insufficient rows in maze file.\n");
            return 1;
        }
    }
    fclose(file);

    // Play the game
    play_game(maze, height, width);

    return 0;
}
