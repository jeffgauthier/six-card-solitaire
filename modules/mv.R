#===============================================================================
# FUNCTION FOR MOVING CARDS
#===============================================================================
#
# Arguments:
# game = a game object: list(cards,pile,col1,col2)
# source = source column
# destination = destination column
#
# EXAMPLE:
# 
# myGame <- list(
#   cards = c(3,2,4),
#   pile = character(0),
#   col1 = 1,
#   col2 = c(5,6)
# )
#
# # Move card in col1 (1) to the foundation pile
# myGame <- mv(myGame, "col1", "pile")
#
# myGame is now:
#   cards = c(3,2,4),
#   pile = 1,
#   col1 = character(0),
#   col2 = c(5,6)
# )
#
# If move is illegal, the returned game state is unchanged
# and an explanatory error message is printed to screen if the global
# var DEBUG_FLAG is set to TRUE.
#
# This function takes the game object as input,
# (= a list of columns cards, pile, col1 and col2),
# and the name in ("double quotes") of the source
# and destination columns.
#
# Since no sequence moves are allowed (because I don't
# know how to do this yet!!!) only the source face-up card
# can be moved to its destination column. There is no need
# to specify which cards are moved, only which columns are
# source and destination.
#
# More accurately, it appends the source column's last item's
# value in the destination column, then it removes the last item
# in the source column (the one that was moved.)
# This is more like "copy and delete the original after".
#
# Before doing the move, it checks that the move is allowed
# using a series of nasty nested if/else statements:
#
#-------------------------------------------------------------------------------
# 1) is source column empty?
#   YES: cancel move; return unchanged game object
#    NO: continue
#
# 2) is user trying to move card to its own column?
#   YES: cancel move; return unchanged game object
#    NO: continue
#
# 3) is user trying to move a card to the stock pile (highly illegal)
#   YES: cancel move; return unchanged game object
#    NO: continue
#
# 4) is destination col1 or col2?
#
#   YES: is destination column empty?
#
#       YES: accept move; update and return game object
#        NO: is destination top card N+1 of the card to move? (from 6 to 1)
#           YES: accept move; update and return game object
#            NO: cancel move; return unchanged game object
#
#    NO: is destination the foundation?
#
#       YES: is foundation column empty?
#           YES: is the source column's last item = 1?
#               YES: accept move; update and return game object
#                NO: cancel move; return unchanged game object
#            NO: is destination top card N-1 of the card to move? (from 1 to 6)
#               YES: accept move; update and return game object
#                NO: cancel move; return unchanged game object
#-------------------------------------------------------------------------------

mv <- function(game, x, y) {
  
  #-----------------------------------------------------------------------------
  # CAPTURING SOME ILLEGAL MOVES INVOLVING SOURCE COLUMN
  #-----------------------------------------------------------------------------
  
  # is source column empty?
  if(length(game[[x]]) == 0) {
    
    # cancel move and update game state
    if(DEBUG_FLAG == TRUE) print("Illegal move! Source column is empty")
    return(game) 
    
    # is user trying to move card to its own column?    
  } else if(x %in% y) {
    
    # cancel move and update game state
    if(DEBUG_FLAG == TRUE) print("Illegal move! Card moved to its own column")
    return(game) 
    
    # is user trying to move a card to the stock pile (highly illegal)    
  } else if(y %in% "cards") {
    
    # cancel move and update game state
    if(DEBUG_FLAG == TRUE) print("Illegal move! Cannot move card to the stock pile")
    return(game)  
    
  }
  
  
  #-----------------------------------------------------------------------------
  # SOURCE COLUMN IS NOT EMPTY; CONTINUE
  #-----------------------------------------------------------------------------  
  
  # get value of top source card
  xval <- tail(game[[x]], 1)
  
  # is destination a column?
  if(y %in% c("col1", "col2")) {
    
    #---------------------------------------------------------------------------
    # if destination column empty?
    if(length(game[[y]]) == 0) {
      
      # append source top val to dest column
      game[[y]] <- append(game[[y]], xval)
      
      # remove top source card, it has been moved
      game[[x]] <- head(game[[x]], -1)
      
      # update game state
      return(game)
      
      #---------------------------------------------------------------------------  
      # if destination column is not empty
    } else if(length(game[[y]]) != 0) {
      
      # get value of top destination card
      yval <- tail(game[[y]], 1)
      
      #-------------------------------------------------------------------------
      # is destination value source value +1?
      if(yval == xval +1) {
        
        # append source top val to dest column
        game[[y]] <- append(game[[y]], xval)
        
        # remove top source card, it has been moved
        game[[x]] <- head(game[[x]], -1)
        
        # update game state
        return(game)
        
        #-------------------------------------------------------------------------
      } else {
        
        # cancel move and update game state
        if(DEBUG_FLAG == TRUE) print("Illegal move! Destination card != Source value +1")
        return(game)
        
      }
      
    }
    
    #-----------------------------------------------------------------------------  
    # is destination the foundation?
  } else if(y %in% "pile") {
    
    #---------------------------------------------------------------------------
    # is it empty?
    if(length(game[[y]]) == 0) {
      
      #-------------------------------------------------------------------------
      # then source must be 1
      if(xval == 1) {
        
        # append source top val to dest column
        game[[y]] <- append(game[[y]], xval)
        
        # remove top source card, it has been moved
        game[[x]] <- head(game[[x]], -1)
        
        # update game state
        return(game)
        
        #-------------------------------------------------------------------------
      } else {
        
        # cancel move and update game state
        if(DEBUG_FLAG == TRUE) print("Illegal move! Foundation is empty and source card is not 1")
        return(game)
      }
      
      #---------------------------------------------------------------------------  
      # if foundation is not empty
    } else if(length(game[[y]]) != 0) {
      
      # get value of top destination card
      yval <- tail(game[[y]], 1)
      #-------------------------------------------------------------------------
      # is destination value == source value -1?
      if(yval == xval -1) {
        
        # append source top val to destination column
        game[[y]] <- append(game[[y]], xval)
        
        # remove top source card, it has been moved
        game[[x]] <- head(game[[x]], -1)
        
        # update game state
        return(game)
        
        #-------------------------------------------------------------------------
      } else {
        
        # cancel move and update game state
        if(DEBUG_FLAG == TRUE) print("Illegal move! Destination card != Source value -1")
        return(game)
        
      }
      
    }
    
  }
  
}