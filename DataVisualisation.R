# Clear Workspace
rm(list = ls())

# Necessary libraries
library(ggplot2)
library(GGally)
library(lattice)


# Set seed for reproducibility and also set working directory
set.seed(1)
<<<<<<< HEAD
setwd("C:/Users/User/Documents/GitHub/Cardiotocography")
load(file = "dat/raw_data.rda")



#png(filename = "pairs.png", width = 2000, height = 2000)
#ggpairs(raw_data[,1:15], color= raw_data$NSP)
#dev.off()



ggplot(raw_data, aes(x = Width, y = Min, colour = NSP)) + geom_point(size = 3) + scale_colour_brewer(palette = 11) + theme(panel.background = element_rect(fill = "gray42"))


=======
load(file = "dat/raw_data.rda")
>>>>>>> origin/master


png(filename = "AC_hist.png", width = 800, height = 600)
plot1 = qplot(AC, data=raw_data, geom="histogram", color = NSP, fill=I("gray"))
plot1 +  scale_colour_brewer(palette = 1) 
dev.off()


ggplot(raw_data, aes(x=AC, fill=NSP)) +
        geom_histogram(position="dodge") +
        scale_fill_brewer(palette = cbPalette)

