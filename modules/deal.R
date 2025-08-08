#===============================================================================
# FUNCTION TO DEAL CARDS
#===============================================================================
# first card is top of the deal pile
# when deal is done, pile becomes the stock pile
#-------------------------------------------------------------------------------
deal <- function(game) {
  
  # RESET GAME BEFORE DEALING
  game <- list(
    cards = c(1,2,3,4,5,6),
    pile = numeric(0),
    col1 = numeric(0),
    col2 = numeric(0)
  )
  
  # shuffle cards
  game$cards <- game$cards[sample(game$cards, size = 6, replace = F)]
  
  # put card 1 in col 1
  game$col1 <- append(game$col1, game$cards[1])
  game$cards <- tail(game$cards, -1)
  
  # put two cards in column 2
  game$col2 <- append(game$col2, game$cards[1:2])
  game$cards <- tail(game$cards, -2)
  
  # return updated game
  return(game)
  
}