use std::io;

const PLAYER_X: char = 'X';
const PLAYER_O: char = 'O';
const BOARD_SIZE: usize = 3;

// 2D Array Type
type Board = [[char; BOARD_SIZE]; BOARD_SIZE];

fn initialize_board() -> Board {
    [[' '; BOARD_SIZE]; BOARD_SIZE]
}

fn print_board(board: &Board) {
    println!("\n    0   1   2 ");  // Column headers
    println!("  -------------");

    for (i, row) in board.iter().enumerate() {
        print!("{} |", i); // Row header
        for cell in row.iter() {
            print!(" {} |", cell);
        }
        println!("\n  -------------");
    }
}

fn get_player_move(current_player: char, board: &Board) -> (usize, usize) {
    loop {
        println!("Player {} input row and column (e.g., 1,2):", current_player);
        let mut input = String::new();
        io::stdin().read_line(&mut input).expect("Failed to read input");

        let parts: Vec<&str> = input.trim().split(',').collect();
        
        if parts.len() == 2 {
            if let (Ok(row), Ok(col)) = (parts[0].parse::<usize>(), parts[1].parse::<usize>()) {
                if row < BOARD_SIZE && col < BOARD_SIZE && board[row][col] == ' ' {
                    return (row, col);
                }
            }
        }
        println!("Invalid input, please enter as 'row,col' (e.g., 1,2)");
    }
}

fn check_winner(current_player: char, board: &Board) -> bool {
    for row in 0..BOARD_SIZE {
        if board[row][0] == current_player && board[row][1] == current_player && board[row][2] == current_player {
            return true;
        }
    }

    for col in 0..BOARD_SIZE {
        if board[0][col] == current_player && board[1][col] == current_player && board[2][col] == current_player {
            return true;
        }
    }

    if (board[0][0] == current_player && board[1][1] == current_player && board[2][2] == current_player)
        || (board[0][2] == current_player && board[1][1] == current_player && board[2][0] == current_player)
    {
        return true;
    }

    false
}

fn check_draw(board: &Board) -> bool {
    for row in board {
        for cell in row {
            if *cell == ' ' {
                return false;
            }
        }
    }
    true
}

fn play_game() {
    loop {
        let mut board = initialize_board();
        let mut current_player = PLAYER_X;

        loop {
            print_board(&board);
            let (row, col) = get_player_move(current_player, &board);
            board[row][col] = current_player;

            if check_winner(current_player, &board) {
                print_board(&board);
                println!("🎉 Player {} is the winner! 🎉", current_player);
                break;
            }
            if check_draw(&board) {
                print_board(&board);
                println!("It's a draw! 🤝");
                break;
            }

            current_player = if current_player == PLAYER_X { PLAYER_O } else { PLAYER_X };
        }

        if !ask_play_again() {
            println!("Thanks for playing! 👋");
            break;
        }
    }
}

fn ask_play_again() -> bool {
    loop {
        println!("Do you want to play again? (y/n):");
        let mut input = String::new();
        io::stdin().read_line(&mut input).expect("Failed to read input");
        let choice = input.trim().to_lowercase();

        match choice.as_str() {
            "y" => return true,
            "n" => return false,
            _ => println!("Invalid input! Please enter 'y' or 'n'."),
        }
    }
}

fn main() {
    println!("Welcome to Tic Tac Toe Game!");
    play_game();
}
