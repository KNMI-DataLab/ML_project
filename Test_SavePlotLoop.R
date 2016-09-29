library(ggplot2)
Econom <-economics

The_names <- colnames(Econom)
The_list <- list()

# These plots don't save because basic graphics draw directly on the graphics device
for (i in 2:6){
  print(i)
  print(colnames(Econom)[i])
  The_list[[i]] <- plot(Econom[ ,i])
  
}

# These plots do save because you use the ggplot package to plot: The qplot function
# Plots a bar plot
# ALL BAR PLOTS ARE IDENTICAL
for (i in seq_along((The_names))){
  print(i)
  print(colnames(Econom)[i])
  The_list[[i]] <- qplot(Econom[ ,i])
  
}


# This line of code does the same as the for loop above
# Plots a bar plot
The_plots <- apply(Econom[, 1:6], 2, qplot)

# Lapply instead of apply
The_plots_2 <- lapply(Econom[, 1:6], qplot)

# The reason qplot doesn't save in a for loop is described on the stackoverflow site below
# http://stackoverflow.com/questions/22895265/qplot-call-overwrites-list-elements 
# If you apply the solution provided here you get: 

The_names <- colnames(Econom)
The_list_2 <- list()

for (i in seq_along((The_names))){
  print(i)
  The_list_2[[i]] <- ggplot(data.frame(x=Econom[ ,i]), aes(x))+geom_histogram()

}

# In order to make a point plot with y = variable of interest and x = index number use: 
The_list_3 <- list()

for (i in seq_along((The_names))){
  print(i)
  The_list_3[[i]] <- ggplot(data.frame(x=Econom[ ,i], y = seq_along(Econom[, i])), aes(x, y))+geom_point()
  
}










