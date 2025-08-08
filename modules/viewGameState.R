#===============================================================================
# VIEW GAME STATE
#===============================================================================
#
# This function prints a game object in a clean column by column layout
# instead of the raw list format.
#-------------------------------------------------------------------------------

viewGameState <- function(game) {
  
  # initialize 6 by 4 matrix
  game.view <- matrix(rep("", 24), nrow=6)
  
  # put stock pile in matrix col 1 
  if(length(game$cards >0)) game.view[1:length(game$cards),1] <- game$cards
  
  # put col1 in matrix col 2
  if(length(game$col1 >0)) game.view[1:length(game$col1),2] <- game$col1
  
  # put col2 in matrix col 3
  if(length(game$col2 >0)) game.view[1:length(game$col2),3] <- game$col2
  
  # put foundation pile in matrix col 4
  if(length(game$pile >0)) game.view[1:length(game$pile),4] <- game$pile
  
  # convert to data frame
  game.view <- as.data.frame(game.view)
  names(game.view) <- c("cards", "col1", "col2", "pile")
  row.names(game.view) <- c("A |", "B |", "C |", "D |", "E |", "F |")
  
  # view result
  return(game.view)
  
}