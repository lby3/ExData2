#load data.table, ggplot2 and reshape
library(data.table)
library(ggplot2)
library(reshape2)

#Read in the base data files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert the PM2.5 values in NEI into a data table, then sum by year
dt25<-data.table(NEI)
dt25<-dt25[(fips=="24510"),]
dt25<-dt25[,list(Emissions=sum(Emissions)), by=list(year, type)]

#define colours for the lines
colours<-data.table(type=unique(dt25$type),colour=c("red","green","blue","yellow"),key="type")
setkey(dt25,type)

#add colours to the table by type
dt25[colours,colour:=i.colour]

#now plot to p, grouping by emission type and adding labels
p<-ggplot(dt25, aes(x=year, y=Emissions, colour=type, label=round(Emissions, digits=2))) 
p<-p + geom_line() 
p<-p + geom_text(vjust=1)

#create a 720 by 720 PNG file
png(filename="plot3.png", width=720, height=720, units="px")

#now print the plot
print(p)

#save the PNG
dev.off()
