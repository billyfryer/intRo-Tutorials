# intRo 1
# Basics
# Authors: Billy Fryer with inspiration from Graham Pash and Jason Thompson

##############################################################################
# Data Types
##############################################################################

a <- 10 # this is an INTEGER variable
b <- "Wolfpack" # this is a CHARACTER variable (aka a string)
a
print(a)
b
print(b)

vec1 <- c(1,2,4,5) 
# An integer vector - the c() function is very useful!
vec2 <- 1:5 # another integer vector, the : makes a sequence from 1:5
vec3 <- c("NC State","Wolfpack") # this is a character vector
print(vec1)
print(vec2)
print(vec3)

class(vec1) 
# To see what type a variable/vector is, use the class() function

# What if we want to look at just a certain item from a vector?
vec1[3] # print the 3rd item/element from vec1
vec3[1] # print the 1st item/element from vec3
# SINGLE brackets

# Can we mix variable types in a vector? No
mixedvec <- c(1:4,"Wolfpack") 
# Because Wolfpack is character, all are converted to character
print(mixedvec)
class(mixedvec)

# We CAN mix variable types in a LIST!
testlist1 <- list(vec1,vec3)
testlist1[[1]] # reference list elements using DOUBLE brackets
testlist1[[2]]

# We can even mix object types in a list - lists just collect things
testlist2 <- list(24,c("Basketball","Soccer"))
testlist2[[1]]
testlist2[[2]]

mat <- matrix(1:12,nrow=4,ncol=3) # this is a MATRIX
mat
mat[2,3] # extracts item in 2nd ROW, 3rd COLUMN of the matrix
mat[4,] # extracts the 4th row, ALL columns
mat[,2] # extracts ALL rows, the 2nd column

df <- data.frame(col1 = 1:25, col2 = 25:1) # this is a data.frame
df
df[2,2] # You can still access these the same way
df[2,] # extracts the 2nd row, ALL columns
df[,2] # extracts ALL rows, the 2nd column

# However, you can do a lot more with Data Frames

df <- rbind(df, c(100,100)) # We can add a row
df <- cbind(df, col3 = 1:26) # We can add a new column
df$col3 <- 26:1 # We can reassign columns a lot easier
df$col4 <- letters[1:26] 
# We can also make a new column, and it can mix numeric and characters

##############################################################################
# Commenting Your Code
##############################################################################

# Commenting your code is the most important thing you can do.
# To comment in R, using a #.
# Commenting is super important because it allows you to make notes
# about functions you may be unfamiliar with or to explain your
# reasoning to others. If you don't comment your code, you are a loser.

##############################################################################
# Packages
##############################################################################


#install.packages('tidyverse') 
# packages must first be installed. 
# Once you install it once you're good forever.

library(tidyverse) 
# Tidyverse is the best overall collection of packages in R, 
#includes ggplot2, tibble, tidyr, readr, purrr, dyplyr, 
#stringr, & forcats. We will discuss some of these later

# For more interesting data, we are going to use the Lahman datasets
#install.packages("Lahman")
library(Lahman)

# Let's use some of the interesting functions in tidyverse

lahmanB <- Batting %>% select(c(playerID, yearID, G:H, RBI, HR))
# %>% is called "pipe". It is a nicer way to nest functions and is available
# Through Tidyverse. This code functions the same as
# lahmanB2 <- select(Batting, c(playerID, G:R, RBI))

# The select() function is from the dplyr package in tidyverse. It allows you
# To select certain variables for analysis.

lahmanP <- People %>% select(playerID, nameFirst, nameLast) %>% mutate(name = paste(nameFirst, nameLast))
# The mutate function allows you to add columns to a data frame.
# The paste function allows you to concatenate strings together with a space between words

lahmanP <- lahmanP %>% select(-c(nameFirst, nameLast))
# select can also be used to unselect columns as in the example above

lahmanBig <- merge(lahmanB, lahmanP, by = "playerID")
# The merge function takes two data sets and combines them by a similar column

lahmanBig <- lahmanBig %>% select(name, playerID, everything())
# The select function can also be used to reorder rows.

# The everything function gets all other variables in the same order.
# The everything function is restricted in when it can be used.

lahmanHR <- lahmanBig %>% filter(HR >= 30) %>% arrange(desc(HR), RBI, name)
# filter limits data to only a certain characteristic

# arrange sorts the data in the order of variables listed
# desc() means descending. We sorted by descending number of HRs to see who hit
# the most in one season

##############################################################################
# R Documentation
##############################################################################

# When you don't know how to do something, 
# look at the R Documentation using a ? before the function you want to learn 
# more about

?select 

##############################################################################
# Plots
##############################################################################
plot <- ggplot(lahmanBig, aes(x = debut, y = HR)) + 
  geom_point() # Makes a scatterplot

plot

plot <- plot + ggtitle("Debut Year vs Homeruns") # adds a title 

plot

plot2 <- ggplot(lahmanBig, aes(y = HR)) +
  geom_bar() # bar graph

plot2

plot2 <- plot2 + aes(fill = lgID) + ggtitle("HR by Count") # fill in bars by league
plot2

##############################################################################
# Conclusion
##############################################################################

# This wraps up the bare basics about coding in R. There are of courses MANY
# more things to learn both in other tutorials and through other resources.
# I want to say thanks to former NCSU Sports Analytics Club Board members
# Graham Pash (Twitter: @gtpash) and Jason Thompson (Twitter: @jason24thompson)
# for allowing me to build this tutorial series off of work they previously did.