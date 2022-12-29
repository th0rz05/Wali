# Wali Board Game

## Wali_1

- Guilherme Cunha Seco Fernandes de Almeida (up202008866) - 50%
- Tiago Filipe Magalhães Barbosa (up202004926) - 50%

## Installation and Execution

Provide the necessary instructions for installing and running the game on Linux and Windows environments, including any dependencies or prerequisites (such as installing SICStus Prolog 4.7.1).

## Description of Wali

- Traditional 2-player game from West Africa
- Played on a 5x6 rectangular board or a 8x9 big special board
- Each player has 12 game pieces in his own color or 22 game pieces in case of special big board
- Players initially take turns placing pieces on the board
- On each turn, players take turns dropping one of their stones from the reserve onto an empty space on the board
- The stone must be placed on a space that is not adjacent to any of the player's own stones
- If a player cannot make a legal drop, they must pass their turn
- This continues until all stones have been placed on the board, or until no more stones can be legally dropped.
- After all pieces are placed, players take turns moving their own pieces to empty adjacent spaces on the board
- If a player forms an exact vertical or horizontal 3 in a row with his pieces, he may capture one enemy piece
- The player who captures all enemy pieces until there are only 2 left, leaving the oponent with no chance to make 3 in row, wins the game.

You can check more in:

- [Wali](https://www.di.fc.ul.pt/~jpn/gv/wali.htm)
- [BoardGameGeek](https://boardgamegeek.com/boardgame/66351/wali)
- [Wikipedia](https://en.wikipedia.org/wiki/Wali_(game))

## Game logic

### Start of the game

The `play/0` predicate, which is in charge of displaying the start menu and launching `play_game/6` in accordance with the selected game choice and board size, initializes the game. The choices Human vs Human, Human vs Computer, Computer vs Human, Computer vs Computer , Instructions and Exit are the viable options. If a game option is selected the `game_cycle/7` predicate is called to start the game loop. The user is prompted to select the difficulty level if a computer-based game mode is selected. Input verification is done for both the game mode , the board size and the AI level selections, and if either is incorrect, the user is prompted to enter their selection again.

### Internal representation of the state of the game

To represent our game we need a way to represent the board , the number of pieces for each player, the current turn and the current phase.

- The 5x6 or 8x9 board is represented as 2d list with numbers where 0 represents empty cell, 1 represents white pieces and 2 represents black pieces.

- The number of pieces for each player is represented with a simple number. In phase 1 this number represents the number of pieces in the reserve and in phase 2 represents the number of pieces on the board.

- The current turn is represented with `whiteturn` or `blackturn`

- The current phase is represented with the number 1 or 2 indicating drop or move phase respectively

#### Examples

- Initial game state

<div style="display: block;  width: 50%; text-align: left">

```prolog
board :[[0,0,0,0,0,0],  WhitePieces: 12
        [0,0,0,0,0,0],  BlackPieces: 12
        [0,0,0,0,0,0],  Turn: whiteturn
        [0,0,0,0,0,0],  Phase: 1
        [0,0,0,0,0,0]]  
```

</div>

- Intermediate phase 1 game state

<div style="display: block;  width: 50%; text-align: left">

```prolog
board :[[1,0,1,0,2,0],  WhitePieces: 5
        [0,1,0,1,0,0],  BlackPieces: 6
        [2,0,2,0,2,0],  Turn: blackturn
        [0,2,0,1,0,2],  Phase: 1
        [0,0,1,0,1,0]]  
```

</div>

- Intermediate phase 2 game state

<div style="display: block;  width: 50%; text-align: left">

```prolog
board :[[1,0,1,0,2,0],  WhitePieces: 4
        [0,1,0,1,0,0],  BlackPieces: 7
        [2,2,2,0,2,0],  Turn: blackturn
        [0,0,0,0,0,2],  Phase: 2
        [0,0,2,0,0,0]]  
```

</div>

- Final game state

<div style="display: block;  width: 50%; text-align: left">

```prolog
board :[[1,0,1,0,0,0],  WhitePieces: 2
        [0,0,0,0,0,0],  BlackPieces: 5
        [2,2,2,0,2,0],  Turn: blackturn
        [0,0,0,0,0,2],  Phase: 2
        [0,0,0,0,0,0]]  

Winner: Black
```

</div>

### Game state view

The visualization of the game is all implemented in the `output.pl` module.

To display all the banners with text in our program we use the `draw_menu/2` predicate that draws the borders and the items of the banner. With this predicate we developed the following predicates:

- `display_start_menu`
- `display_select_board_menu`
- `display_select_difficulty_menu/1`
- `display_instructions`
- `display_phase/1`
- `display_nr_pieces/2`
- `display_turn/1`
- `display_3_in_a_row`
- `congratulate_winner/1`
- `press_any_key_to_continue/1`

All this predicates are used to display information to the user in an aesthetically pleasing manner.

We also created a `display_board/1` predicate that given a 2d list representing the board displays it with special box drawing unicode characters.

With all this predicates defined we can use the `display_game/5` predicate that displays the current game state using the above explained predicates.

#### Examples

- Start menu and instructions

<p align="center">
  <img src="doc/start_menu_instructions.png" width="65%">
</p>

- Start game

<p align="center">
  <img src="doc/start_game.png" width="65%">
</p>

- End Phase1

<p align="center">
  <img src="doc/end_phase1.png" width="65%">
</p>

- Phase2

<p align="center">
  <img src="doc/phase2.png" width="65%">
</p>

- Phase2 3 in a row

<p align="center">
  <img src="doc/phase2_3_in_a_row.png" width="65%">
</p>

- End of game

<p align="center">
  <img src="doc/end_game.png" width="65%">
</p>

To deal with user input we created the `input.pl` module where we have all the predicates to receive and validate the input for option in the menu and moves in game.

To validate menu options we use `read_until_between/3` that asks the user for a number continuously until it is between 2 numbers.

To validate input for the moves we use the `read_move/3` and `read_move/4` predicate to read a string from the user and parse it to a move with `parse_move/3` and `parse_move/5` to transform the move into X and Y positions of the board. If the X and Y are not valid the process is repeated until a valid input is given.

#### Examples

- Menu options

<p align="center">
  <img src="doc/menu_option.png" width="65%">
</p>

- Move in phase1 (a9 and j1 are not possible places on the board and a2 is not valid because it is neighbor of an existing friendly piece)

<p align="center">
  <img src="doc/phase1_move.png" width="65%">
</p>

- Move in phase2 (a3l and a3u are not valid moves)

<p align="center">
  <img src="doc/phase2_move.png" width="65%">
</p>

### Moves Execution

To obtain the move from the user as we above explained we use the `parse_move/3` and `parse_move/5` to transform inputs with the format < letter >< number > into and X and Y position and inputs < letter >< number >< [u-d-l-r] > into X, Y, NewX and NewY (Ex: a2 -> X=0 ; Y=1 and b3d -> X=1 ; Y=2 ;NewX=1 ; Y=3 ). If the above formats are not respected then the predicate fails.

If the predicate succeeds , then we call `validate_place_piece/4`, `validate_remove_piece/4` or `validate_move_piece/6` depending on the type of move. This predicates will see if the X and Y positions are inside the board and verify if the move respects the game rules by using predicates like `not_occupied/3` and `no_neighbours/4` for placing pieces, `has_enemy/4` for removing pieces and `has_piece/4` and `not_occupied/3` for moving pieces.

If the above predicates succeed then the move is valid and we can call `place_piece/5` , `remove_piece/5` or `move_piece/7` depending on the type of move. This predicate will take the current board and the parsed move in the form of X and Y positions and return a new board after the move.

[Note: We did not follow the conventional `move` name because our game has various type of moves and by addopting different names we improved the code readability]

### List of Valid Moves

- List of valid moves: describe the obtaining of a list of possible moves. The predicate should be called `valid_moves(+GameState, +Player, -ListOfMoves)`.

### End of Game

- End of game: describe the verification of the end of the game, with identification of the winner. The predicate should be called `game_over(+GameState, -Winner)`.

### Board Evaluation

- Board evaluation: describe the method(s) of evaluating the game state. The predicate should be called `value(+GameState, -Value)`.

### Computer move

- Choice of the move to be performed by the computer, depending on
the difficulty level. The predicate should be called choose_move(+GameState, +Player,
+Level, -Move). Level 1 should return a random valid move. Level 2 should return the
best move at the moment (greedy algorithm), taking into account the evaluation of the
game state.

## Conclusions

Reflect on the process of developing the game and discuss any difficulties or learnings acquired during the project. Also, you can include suggestions for potential future improvements.

## Bibliography

 Listing of books, articles, Web pages and other resources used during the development