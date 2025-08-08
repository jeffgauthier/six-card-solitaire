#===============================================================================
# LOAD GAME FUNCTIONS
#===============================================================================

# initialize a game object and distribute cards
source("deal.R")

# function to draw cards (put last card at 1st position)
source("draw.R")

# function to move cards (accepts legal moves only)
source("mv.R")

# function to play a random game
source("playRandom.R")



#===============================================================================
# TEST PLAY WITH FUNCTIONS
#===============================================================================

# new game
myGame <- deal(myGame)

# all legal moves (N = 9)
myGame <- draw(myGame)
myGame <- mv(myGame, "cards", "pile")
myGame <- mv(myGame, "col1", "pile")
myGame <- mv(myGame, "col2", "pile")
myGame <- mv(myGame, "cards", "col1")
myGame <- mv(myGame, "col1", "col2")
myGame <- mv(myGame, "col2", "col1")
myGame <- mv(myGame, "cards", "col2")
myGame <- mv(myGame, "col2", "col1")

# test illegal move to stock pile
myGame <- mv(myGame, "col1", "cards")

# test illegal "move to itself"
myGame <- mv(myGame, "col1", "col1")



#===============================================================================
# TEST RANDOM PLAY
#===============================================================================

# DEBUGGING FLAG FOR PRINT()
DEBUG_FLAG <- TRUE

# initialize report data frame
myReport <- data.frame(
  start = NA,
  end = NA,
  nb.moves = NA,
  outcome = NA,
  history = NA
)

# test play
myReport[1,] <- playRandom(myReport)


