#load data.table, ggplot2 and reshape
library(data.table)
library(ggplot2)
library(reshape2)

#Read in the base data files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert the PM2.5 values in NEI into a data table
dt25<-data.table(NEI)

#now convert SCC into a data table
scc<-data.table(SCC)

#subsetting SCC down to collect anything with:
# 1:  EI.Sector including Coal; or
# 2:  Both Short.Name including Coal AND SCC.Level.One including Combustion
#This should take care of the coal combustion-related sources
scc<-scc[EI.Sector %like% "Coal" | (Short.Name %like% "Coal" & SCC.Level.One %like% "Combustion")]

#now merge the two tables
setkey(dt25,SCC)
setkey(scc,SCC)
dt25<-merge(dt25,scc)

#now summarise dt25
dt25<-dt25[,list(Emissions=sum(Emissions)), by=year]

#create a 720 by 720 PNG file
png(filename="plot4.png", width=720, height=720, units="px")

#now print the emissions, skipping the x-axis - I'll fill that in manually
plot(dt25$Emissions, type="b", main="PM2.5 Emissions from Coal Combustion-related Sources", ylab="Total Emissions", xlab="Year", xaxt="n")

#enter the x-axis
axis(side=1, at=1:4, labels=dt25$year)

#save the PNG
dev.off()
