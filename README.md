# six-card-solitaire
A toy implementation of a miniaturized 6-card Klondike solitaire game (no suits, two columns, one foundation pile). 

I made this to learn how to make a card game solver and (trying to attempt to maybe one day...) make a decent user interface for interactive play. 

All coded in base R except for one library (Rmisc) to compile statistics. The script will attempt to install it if not already installed. 

---

# Contents

## sol6_100k.R 
Brute-force solver.
 - Plays 100,000 random games by brute-force until: it wins ("Won") or quits after either 50 illegal consecutive moves ("Unsolved") or 500 valid moves ("Timeout").
 - Report start and end states, number of valid moves and outcome for each game (Won, Unsolved or Timeout). Stores results in `sol6_100k_game_report.txt`.
 - Finds the shortest solution for each unique winnable draw. Stores results in `sol6_100k_best_solutions.txt`.

## sol6_interactive.R
A playable game interface that uses the same modules than the ones used for the solver (see subfolder `modules`). Lets you play the game in the R console.

## modules/
This folder contains functions that are essential for the above script to work.
 - deal.R (initializes a new game object and distributes cards)
 - draw.R (puts the last card on the stock pile at the bottom. I did not implement a waste pile here.)
 - mv.R (a spaghetti of nested if-else statements to move card between columns while checking for the validity of the moves.)
 - playRandom.R (creates a new game and plays it with random moves. This is the "engine" of the `sol6_100k` solver.
 - viewGameState.R (used for the interactive player to show the game object as columns of cards, which is nicer than printing the game object itself.) 

---

# GAME DEFINITION

## LAYOUT OF THE GAME
 - Six cards (1,2,3,4,5,6)
 - No suits
 - Two columns (first = two cards, 2nd = two cards)
 - One foundation pile
 - One stock pile

## DEALING CARDS
 - Cards are dealt from index 1 to 6
 - One card in column 1
 - Two cards in column 2
 - then the rest goes in the stock pile.
 - All cards are visible

## GAME RULES
 - The last card (highest index) in each column or pile is the face-up card.
 - One card can be moved at at time (no sequence moves)
 - Drawing a card = putting the face-up card at the bottom (shifting an array to the right)
