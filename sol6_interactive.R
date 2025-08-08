#===============================================================================
# SIX-CARD KLONDIKE INTERACTIVE PLAYER  v0.1.0  Jeff Gauthier     2025-08-07
#===============================================================================
# Trying to make a user interface to allow user to play 6-cars klondike with
# the same functions I used for the solver.
#-------------------------------------------------------------------------------


#===============================================================================
# LOAD GAME FUNCTIONS
#===============================================================================

# initialize a game object and distribute cards
source("modules/deal.R")

# function to draw cards (put last card at 1st position)
source("modules/draw.R")

# function to move cards (accepts legal moves only)
source("modules/mv.R")

# function to view game states in the console
source("modules/viewGameState.R")



#===============================================================================
# TEST INTERACTIVE PROMPT-BASED PLAY
#===============================================================================

# DEBUGGING FLAG FOR MV PRINT() MESSAGES
DEBUG_FLAG <- TRUE

playSelf <- function(game) {
  
  # clear screen
  cat(rep("\n", 200))

  # start new game
  game <- deal(game)
  
  # keep running as long as the game has not been won
  while(!identical(game$pile, c(1,2,3,4,5,6))) {
    
    # show game state
    print(viewGameState(game))
    
    # prompt user for next action
    action <- readline("Next move? (draw, move, quit) ")
    
    # if action is draw; then draw a card
    if(action == "draw") {
      game <- draw(game)
      print("Draw card from stock pile")
      cat("\n")
    }
    
    # else, if user chosses to move, prompt for move to do
    else if(action == "move") {
      
      # prompt source column
      src <- readline("Source column? (cards, pile, col1, col2) ")
      dest <- readline("Destination column? (pile, col1, col2) ")
      game <- mv(game, src, dest)
      print(paste0("Move: ", src, " -> ", dest))
      cat("\n")
      
    }
    
    # if user chooses to quit
    else if(action == "quit") {
      
      # inform user the game is over
      print("GAME OVER")
      
      # return game state
      return(game)
      
    }
    
    # if user chooses unexpected option
    else {
      print("[ERROR] Unexpected move! Try again.")
      cat("\n")
    }
    
  }
  
  # show game state
  print(viewGameState(game))
  
  # GAME HAS BEEN WON; return final game state
  print("You won!")
  return(game)
  
}  

myGame <- playSelf(myGame)
