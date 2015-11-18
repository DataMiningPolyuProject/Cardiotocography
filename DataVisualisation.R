# Clear Workspace
rm(list = ls())

# Necessary libraries
library(ggplot2)
library(GGally)
library(lattice)


# Set seed for reproducibility and also set working directory
set.seed(1)

setwd("C:/Users/User/Documents/GitHub/Cardiotocography")
load(file = "dat/raw_data.rda")



#png(filename = "pairs.png", width = 800, height = 600)
#ggpairs(raw_data[,1:15], color= raw_data$NSP)
#dev.off()


png(filename = "width_vs_min.png", width = 800, height = 600)
width_vs_min <- ggplot(raw_data, aes(x = Width, y = Min, colour = NSP)) +
        geom_point(size = 3) + scale_colour_brewer(palette = 11) +
        theme(panel.background = element_rect(fill = "gray42"))
width_vs_min
dev.off()




#png(filename = "AC_hist.png", width = 800, height = 600)
#ac_hist <- qplot(AC, data=raw_data, geom="histogram", color = NSP, fill=I("white"))+
#        scale_colour_brewer(palette = 11) +
#        theme(panel.background = element_rect(fill = "gray42"))
#ac_hist
#dev.off()


png(filename = "AC_hist.png", width = 800, height = 600)
ac_hist <- ggplot(raw_data, aes(x=AC, fill=NSP)) +
        geom_histogram(position="dodge") +
        scale_fill_brewer(palette = 11) +
        theme(panel.background = element_rect(fill = "gray42"))
ac_hist
dev.off()



png(filename = "variance_boxplot.png", width = 800, height = 600)
variance_boxplot <- ggplot(raw_data, aes(x= NSP, y=Variance, fill=NSP)) +
            geom_boxplot() +
            scale_fill_brewer(palette = 11) +
            theme(panel.background = element_rect(fill = "gray42"))
variance_boxplot
dev.off()
