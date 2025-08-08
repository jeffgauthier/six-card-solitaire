#===============================================================================
# FUNCTION FOR DRAWING CARDS FROM THE STOCK PILE
#===============================================================================
# for simplicity, drawing a card is putting the last card on top
# of the pile
#-------------------------------------------------------------------------------

draw <- function(game) {
  
  # how many cards in pile?
  nb <- length(game$cards)
  
  # IF ONLY one card or 0, cannot draw
  if(nb < 1) {
    
    if(DEBUG_FLAG==TRUE) {
      print("Illegal move! Cannot draw if stock 1 or less")
    }
    
    # return updated game state
    return(game)
    
  } else {
  
    # 2 or more, can draw
    game$cards <- append(
                    game$cards[nb],
                    game$cards[1:(nb-1)]     
                  )
  
    # return updated game state
    return(game)
  
  }
  
}