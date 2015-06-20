#load data.table
library(data.table)

#Read in the base data files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert the PM2.5 values in NEI into a data table, then sum by year
dt25<-data.table(NEI)
dt25<-dt25[(fips=="24510"),]
dt25<-dt25[,list(Emissions=sum(Emissions)), by=year]

#now plot the PM2.5 emissions for Baltimore
#create a 720 by 720 PNG file
png(filename="plot2.png", width=720, height=720, units="px")

#now print the emissions, skipping the x-axis - I'll fill that in manually
plot(dt25$Emissions, type="b", main="PM2.5 Emissions (Baltimore)", ylab="Total Emissions", xlab="Year", xaxt="n")

#enter the x-axis
axis(side=1, at=1:4, labels=dt25$year)

#save the PNG
dev.off()
