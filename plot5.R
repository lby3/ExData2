#load data.table, ggplot2 and reshape
library(data.table)
library(ggplot2)
library(reshape2)

#Read in the base data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert the PM2.5 values in NEI into a data table, and filter down to Baltimore
dt25<-data.table(NEI)
dt25<-dt25[(fips=="24510"),]

#now convert SCC into a data table
scc<-data.table(SCC)

#Assumption:  Onroad is the only category of motor vehicles - I do not consider
#             airplanes or ships or other types of vehicles as motor vehicles
#subsetting SCC down to only collect codes which are in the category Onroad\
scc<-scc[scc$Data.Category=="Onroad",]

#now merge the two tables
setkey(dt25,SCC)
setkey(scc,SCC)
dt25<-merge(dt25,scc)

#now summarise dt25
m<-dt25
dt25<-dt25[,list(Emissions=sum(Emissions)), by=year]

#create a 720 by 720 PNG file
png(filename="plot5.png", width=720, height=720, units="px")

#now print the emissions, skipping the x-axis - I'll fill that in manually
plot(dt25$Emissions, type="b", main="PM2.5 Emissions from Motor Vehicles", ylab="Total Emissions", xlab="Year", xaxt="n")

#enter the x-axis
axis(side=1, at=1:4, labels=dt25$year)

#save the PNG
dev.off()
