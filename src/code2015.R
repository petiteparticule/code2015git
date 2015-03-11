library(ggplot2)
library(zoo)
library(DAAG)
library(mapdata) #for canada map from worldhires database
library(ggmap)


code2015_govfund <- function()
{
	allcit <- NULL
	allcit2 <- NULL

	#data set from here http://open.canada.ca/data/en/dataset/c34ca68e-85bb-43d6-a261-7b42ce9b31e8
	#beware: some table names I have changed "-" to "_"; also change path

	#read government financing table
	allcittmp <- read.csv("data/2011_SFGSME_EFCPME_T14_eng.csv", sep=",", header=TRUE, colClasses = "character")
	#read Overall External Financing Request Rate and Reason for Not Seeking External Financing table
	allcittmp2 <- read.csv("data/2011_SFGSME-EFCPME_T1_eng.csv", sep=",", header=TRUE, colClasses = "character")

	#cast data to proper format from character for both data frames
	allcittmp[,4] <- as.numeric(allcittmp[,4])
	allcittmp[,7] <- as.numeric(allcittmp[,7])
	allcittmp[,10] <- as.numeric(gsub(",","",allcittmp[,10]))
	allcittmp[,13] <- as.numeric(gsub(",","",allcittmp[,13]))

	allcittmp2[,4] <- as.numeric(allcittmp2[,4])
	allcittmp2[,7] <- as.numeric(allcittmp2[,7])
	#the next ones don't have data for all cities
	allcittmp2[,10] <- as.numeric(allcittmp2[,10])
	allcittmp2[,13] <- as.numeric(allcittmp2[,13])
	allcittmp2[,16] <- as.numeric(allcittmp2[,16])
	allcittmp2[,19] <- as.numeric(allcittmp2[,19])

	#get only relevant columns to a new data frame
	allcit <- allcittmp[,c(1,2,4,7,10,13)]
	allcit2 <- allcittmp2[,c(1,2,4,7)]

	print(allcit)
	print(allcit2)

	#delete temp data frames for hygiene
	allcittmp <- NULL
	allcittmp2 <- NULL

	#what do these headers mean
	#s_level = survey level (provincial, municipal etc)
	#city = city
	#gov_fin_req = Requested government financing in 2011 - %
	#approval_p = Outcome of government financing request - Approved - Total Approval Rate - %
	#approval_a = Outcome of government financing request - Approved - Total amount of government financing provided - $
	#approval_avg = Outcome of government financing request - Approved - Average amount of government financing provided - $
	#ext_fin_req = Requested external financing in 2011 - %
	#reas_fin_not_need = Reason for not requesting external financing in 2011 - Financing not needed - %

	#give somewhat sensible column names to the 2 data frames
	colnames(allcit) <- c("s_level","city","gov_fin_req","approval_p","approval_a","approval_avg")
	#colnames(allcit2) <- c("s_level","city","ext_fin_req","reas_fin_not_need","reas_req_turned_down","reas_time_consum","reas_cost","reas_other")
	colnames(allcit2) <- c("s_level","city","ext_fin_req","reas_fin_not_need")

	#join the 2 data frames by columns s_level and city
	allcit <- merge(allcit, allcit2, by=c("s_level","city"))

	#keep only CMA level data (Census Metropolitan Level)
	allcit <- subset(allcit, allcit[,1]=='CMA Level')

	#clean up NA's
	allcit <- na.omit(allcit)

	#colnames(allcit) <- c("s_level","city","gov_fin_req","approval_p","approval_a","approval_avg")
	print("===== allcit cleaned up version =====")
	print(allcit)

	#quick look at corelations
	plot((allcit[,c(3,4,5,7,8)]), gap=0)

	#produce an index based on the above parameters
	#(naiively!!) startup_ind proportional to approval_p, gov_fin_req^-1, ext_fin_req^-1
	allcit$startup_ind <- allcit$approval_p/(allcit$gov_fin_req * allcit$ext_fin_req)

	#order df by new found index
	allcit <- allcit[order(allcit$startup_ind),]
	print("best cities, according to startup_index:")
	print(allcit[,c(2,3,4,5,7,8,9)])

	plmap <- mapcit3(allcit$city, allcit$startup_ind)

	return(plmap)

}

mapcit <- function(citiesM, indM)
{

	#concatenate Canada to city names:
	citiesM <- paste(citiesM,", Canada", sep="")

	freqM <- data.frame(citiesM, indM) #make dataframe
	lonlat <- geocode(citiesM) #courtesy of google, logitude, lattitude (gives two var's lon, lat among others)
	cities <- cbind(freqM,lonlat) #make new df with long/latt
	map2 <- get_map(location = 'Winnipeg, MB', zoom = 4) #Montreal, QC as you would put in the search box in google maps
	mappts2 <- ggmap(map2) +
	geom_point(data=cities, inherit.aes=F, aes(x=lon, y=lat, size=indM), colour="red", alpha=.8) +
	geom_text(data=cities, inherit.aes=F, size=2, aes(x=lon, y=lat, label=citiesM), vjust=1, colour="red", alpha=.5)

	return(mappts2)
}


mapcit3 <- function(citiesM, indM)
{
	#concatenate Canada to city names:
	citiesM <- paste(citiesM,", Canada", sep="")

	freqM <- data.frame(citiesM, indM) #make dataframe
	lonlat <- geocode(citiesM) #courtesy of google, logitude, lattitude (gives two var's lon, lat among others)
	citiesC <- cbind(freqM,lonlat) #make new df with long/latt

	mappts2 <- ggplot(citiesC, aes(lon, lat)) +
		borders(regions="canada", name="borders") +
		coord_equal() +
		geom_point(data=citiesC, inherit.aes=F, aes(x=lon, y=lat, size=indM), colour="red", alpha=.8) +
		geom_text(data=citiesC, inherit.aes=F, size=2, aes(x=lon, y=lat, label=citiesM), vjust=1, colour="red", alpha=.5)

	return(mappts2)
}
