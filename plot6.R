#load data.table, ggplot2 and reshape
library(data.table)
library(ggplot2)
library(reshape2)

#Read in the base data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert the PM2.5 values in NEI into a data table, and filter down to Baltimore
dt25<-data.table(NEI)
dt25<-dt25[(fips =="24510" | fips== "06037"),]

#now change fips into the location names
setnames(dt25, "fips", "Location")
dt25$Location[dt25$Location=="24510"]<-"Baltimore City"
dt25$Location[dt25$Location=="06037"]<-"Los Angeles County"

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
dt25<-dt25[,list(Emissions=sum(Emissions)), by=list(Location, year)]

#define colours for the lines
colours<-data.table(Location=unique(dt25$Location),colour=c("red","blue"),key="Location")
setkey(dt25,Location)

#add colours to the table by type
dt25[colours,colour:=i.colour]

#now plot to p, grouping by location and adding labels, so that can see both number and trend
p<-ggplot(dt25, aes(x=year, y=Emissions, colour=Location, label=round(Emissions, digits=2))) 
p<-p + geom_line() 
p<-p + geom_text(vjust=1)

#create a 720 by 720 PNG file
png(filename="plot6.png", width=720, height=720, units="px")

#now print the plot
print(p)

#save the PNG
dev.off()
