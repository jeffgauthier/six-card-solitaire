#===============================================================================
# PLAY A RANDOM GAME
#===============================================================================
# 
# Function to play a game by brute-force (random moves until the 
# foundation pile is c(1,2,3,4,5,6) ).
#
# Depends on the deal, draw and mv functions.
#  
# It initializes a game object and deals the cards with deal() 
# and then moves the cards randomly with draw() or mv().
#
# Requires a report data frame as input, structured as follows:
#
# --------------------------------
# |# initialize report data frame
# |report <- data.frame(
# |  start = NA,
# |  end = NA,
# |  nb.moves = NA,
# |  outcome = NA,
# |  history = NA
# |)
# --------------------------------
#
# Then, when this function is run:
# report <- playRandom(report)
# 
# It then appends a row to the report data frames.
#
# The report's five columns are:
#
#   1) Start state (one-liner snapshot of the columns' contents)
#
#   2) End state (one-liner snapshot of the columns' contents)
#
#   3) How many (legal) moves were made
#
#       - Illegal moves are rejected by the mv function, and
#         therefore do not alter the game object
#
#   4) Outcome (Won, Unsolved, Timeout)
#
#       - Unsolved: After 50 consecutive illegal moves, the game is
#           over and declared "Unsolved". The end state is reported
#           as well as the number of legal moves that were done.
#           (truth: I don't know yet how to check if a game is solvable)
#
#       - Timeout: When 500 legal moves have been done, the game is
#           cancelled (the solution, if any, is likely inefficient)
#
#       - Won: When game is won, the end state should be:
#             cards()_pile(1,2,3,4,5,6)_col1()_col2()
#
#   5) Move history (one-liner with all legal moves regardless of outcome)
#
#       - Example: cards>pile col1>pile draw ...
#       - ";" separates the moves;
#       - ">" separates source and destination columns
#
#-------------------------------------------------------------------------------

playRandom <- function(report) {
  
  # start new game
  game <- deal(game)
  
  # initialize report data frame
  report <- data.frame(
    start = NA,
    end = NA,
    nb.moves = NA,
    outcome = NA,
    history = NA
  )
  
  # record initial state snapshot
  report$start = paste0(
    "cards(", paste0(game$cards, collapse = ","), ")_",
    "pile(", paste0(game$pile, collapse = ","), ")_",
    "col1(", paste0(game$col1, collapse = ","), ")_",
    "col2(",paste0(game$col2, collapse = ","), ")"
  )
  
  # define winning foundation
  win <- c(1,2,3,4,5,6)
  
  # initialize move counter
  legal.moves <- 0
  
  # initialize illegal sequence counter (shortcut for "unsolvable")
  illegal.moves <- 0
  
  # initialize moves history
  move_history <- character(0)
  
  #-----------------------------------------------------------------------------
  # as long as the foundation is not full, i.e. c(1,2,3,4,5,6)...
  #-----------------------------------------------------------------------------
  while(!identical(game$pile, win)) {
    
    # capture previous state
    previous <- game
    
    #---------------------------------------------------------------------------
    # randomly choose to draw a card or not
    # there are 9 legal moves in my game including the draw
    #---------------------------------------------------------------------------
    if(sample(1:9, 1, F) == 2) {
      
      # draw a card from the stock pile
      draw(game)
      
      # if game changed, move was legal = add 1 move to counter
      if(!identical(previous, game)) {
      
       # increment counter
       legal.moves <- legal.moves + 1
      
        # if(DEBUG_FLAG == TRUE) print move
        if(DEBUG_FLAG == TRUE) print(
          paste0("[LEGAL] Move: draw")
          )
        
        # reset illegal sequence to zero
        illegal.moves <- 0
      
        # add move to history
        move_history <- append(move_history, "draw")
      
      } else {
        
        # increment counter
        illegal.moves <- illegal.moves + 1
        
      }
    
    #---------------------------------------------------------------------------
    # did not draw, go to col-to-col move
    #---------------------------------------------------------------------------
    } else {
      
      # randomly choose source and destination columns
      source <- sample(c("cards", "pile", "col1", "col2"), 1, F)
      destination <- sample(c("pile", "col1", "col2"), 1, F)
      
      # make a move, whether it is illegal or not
      game <- mv(game, source, destination)
      
      # if game changed, move was legal = add 1 move to counter
      if(!identical(previous, game)) {
        
        # increment counter
        legal.moves <- legal.moves + 1
        
        # if(DEBUG_FLAG == TRUE) print move
        if(DEBUG_FLAG == TRUE) print(
          paste0("[LEGAL] Move: ", source, " -> ", destination)
        )
        
        # reset illegal sequence to zero
        illegal.moves <- 0
        
        # add move to history
        move_history <- append(
          move_history, paste0(source, ">", destination)
        )
        
      } else {
        
        # increment counter
        illegal.moves <- illegal.moves + 1
        
      }
      
    }
    
    #---------------------------------------------------------------------------
    # if >50 consecutive illegal moves (= can't find a legal move)
    # quit game and return status "unsolved"
    #---------------------------------------------------------------------------
    if(illegal.moves == 50) {
      
      # report game's end state
      report$end = paste0(
        "cards(", paste0(game$cards, collapse = ","), ")_",
        "pile(", paste0(game$pile, collapse = ","), ")_",
        "col1(", paste0(game$col1, collapse = ","), ")_",
        "col2(",paste0(game$col2, collapse = ","), ")"
      )
      
      # report nb. legal moves
      report$nb.moves <- legal.moves
      
      # report outcome
      report$outcome <- "Unsolved"
      
      # report move history
      report$history <- paste0(move_history, collapse=" ")
      
      # game over, return game report
      return(report)
      
    }
    
    #---------------------------------------------------------------------------
    # if too much legal moves, solution is likely inefficient = timeout
    #---------------------------------------------------------------------------
    if(legal.moves == 500) {
      
      # report game's end state
      report$end = paste0(
        "cards(", paste0(game$cards, collapse = ","), ")_",
        "pile(", paste0(game$pile, collapse = ","), ")_",
        "col1(", paste0(game$col1, collapse = ","), ")_",
        "col2(",paste0(game$col2, collapse = ","), ")"
      )
      
      # report nb. legal moves
      report$nb.moves <- legal.moves
      
      # report outcome
      report$outcome <- "Timeout"
      
      # report move history
      report$history <- paste0(move_history, collapse=" ")
      
      # game over, return game report
      return(report)
      
    }
    
  }
  
  #-----------------------------------------------------------------------------
  # game has been won, report number of legal moves
  #-----------------------------------------------------------------------------
  
  report$nb.moves <- legal.moves
  
  # report that game was won
  report$outcome <- "Won"
  
  # report game's end state
  report$end = paste0(
    "cards(", paste0(game$cards, collapse = ","), ")_",
    "pile(", paste0(game$pile, collapse = ","), ")_",
    "col1(", paste0(game$col1, collapse = ","), ")_",
    "col2(",paste0(game$col2, collapse = ","), ")"
  )
  
  # report move history
  report$history <- paste0(move_history, collapse=" ")
  
  # when game is done, return game report
  return(report)
  
}