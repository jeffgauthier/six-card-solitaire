#===============================================================================
# SIX-CARD KLONDIKE SOLITAIRE     Jeff Gauthier     v0.1.0          2025-08-07
#===============================================================================
# 
# A toy 6-card Klondike implementation in R to learn how to make a solver 
# and study solitaire probabilities.
# 
# This main script computes 100,000 random 6-card solitaire games and
# finds the best solutions by brute-force for each unique winnable draw.
# 
# Everything here is coded in base R, except for a dependency (Rmisc) for
# reporting sample bias at the end (optional, code is commented).
#
#===============================================================================
#
# LAYOUT OF THE GAME
# - Six cards (1,2,3,4,5,6)
# - No suits
# - Two columns (first = two cards, 2nd = two cards)
# - One foundation pile
# - One stock pile
#
# DEALING CARDS
#     - Cards are dealt from index 1 to 6
#     - One card in column 1
#     - Two cards in column 2
#     - then the rest goes in the stock pile.
#     - All cards are visible
#
# GAME RULES
#     - The last card (highest index) in each column or pile
#         is the face-up card.
#     - One card can be moved at at time (no sequence moves)
#     - Drawing a card = putting the face-up card at the bottom
#         (shifting an array to the right)
#
# # Example structure before dealing:
# myGame <- list(
#   cards = c(1,2,3,4,5,6),
#   pile = numeric(0),
#   col1 = numeric(0),
#   col2 = numeric(0)
# )
#
# # Example after a random dealing:
# myGame <- list(
#   cards = c(3,1,5),
#   pile = numeric(0),
#   col1 = 4,
#   col2 = c(2,6)
# )
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

# function to play a random game
source("modules/playRandom.R")



#===============================================================================
# EXPLORING 100,000 RANDOM GAMES
#===============================================================================

# DEBUGGING FLAG FOR PRINT()
DEBUG_FLAG <- FALSE

# initialize report data frame
myReport <- data.frame(
  start = NA,
  end = NA,
  nb.moves = NA,
  outcome = NA,
  history = NA
)

# play 100,000 brute-force random games
for(i in 1:100000) {
  myReport[i,] <- playRandom(myReport)
  print(paste0("Game #", 
               i, 
               " (", 
               myReport[i,]$nb.moves, " moves, ", 
               myReport[i,]$outcome, ")"))
}

# save results to file
write.table(x = myReport, file = "sol6_100k_game_report.txt",
            sep="\t", quote=F, row.names = F)



#===============================================================================
# COMPILE BEST SOLUTIONS FOR EACH UNIQUE WINNABLE DRAW
#===============================================================================

# compile all games that were won
myWins <- myReport[myReport$outcome %in% "Won",]

# initialize "best wins" report
myWins.best <- myWins[FALSE,]

# list of all unique winnable games
myWins.uniq <- sort(unique(myWins$start))

# compile best solutions for every unique game that was won
for(i in 1:length(myWins.uniq)) {
  
  # create tmp report contains all wins for the i-th game
  tmp <- myWins[myWins$start %in% myWins.uniq[i],]
  
  # sort table by number of moves
  tmp <- tmp[order(tmp$nb.moves),]
  
  # keep only top row (solution with fewest moves)
  tmp <- tmp[1,]

  # append data to best wins report
  myWins.best <- rbind(myWins.best, tmp)
  
  # remove temp object
  rm(tmp)
    
}

# write to file
write.table(myWins.best, file = "sol6_100k_best_solutions.txt",
            sep="\t", quote=F, row.names = F)



#===============================================================================
# BONUS: Draw coverage homogeneity
#===============================================================================
# There are 6! = 720 ways to shuffle 6 cards from 1 to 6.
# Here I checked how many unique draws were dealt (should be 720) since
# 100,000 games were played. Then I checked if unique draws were equally 
# sampled (100,000 / 720 = 138.89 ~ 139).
#
# So each unique draw should have been played ~139 times.
# There were 720 unique draws (6!). So all possible games have
# been played at least once.
# 
# Each draw has been played 139 ± 12 times in average.
# 
# Given that:
# - Sample 95% CI = [138, 140] (N = 100,000)
# - Expected value : 100000/720 = 138.8889 ~ 139
# I concluded that draws are equally represented, and that each unique
# draw had an equal chance of having a best solution found.
#
# Un-comment code below after running sol6.R to see by yourself. 
#-------------------------------------------------------------------------------

# # install Rmisc if not installed yet
# if(!require(Rmisc)) install.packages("Rmisc")
# 
# # List frequencies of draws by outcome
# draws.freq <- as.data.frame(
#   table(myReport$start), stringsAsFactors = F
#   )
# names(draws.freq) <- c("start", "Freq")
# 
# # are random draws homogeneous?
# draws.freq.summary <- Rmisc::summarySE(
#   data = draws.freq,
#   measurevar = "Freq"
#   )
# draws.freq.summary$.id <- NULL
# draws.freq.summary <- round(draws.freq.summary, 0)

