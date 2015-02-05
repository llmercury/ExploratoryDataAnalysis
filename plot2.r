# Test if the data file exists in the working directory.
# If not, download and unzip the file.
# Note: I am using Windows 64 system, without the curl library. I have to set setInternet2 true and download the https files. 

if (!file.exists("exdata-data-household_power_consumption.zip") & !file.exists("household_power_consumption.txt")) {
	fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
	setInternet2(TRUE)
	download.file(fileUrl, destfile = "exdata-data-household_power_consumption.zip")
	unzip("exdata-data-household_power_consumption.zip")	
}

# read the raw data and convert the "Date" to date class.
rdata <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", nrows = 70000)	
rdata$Date <- as.Date(rdata$Date, format = "%d/%m/%Y")

# Extract the data from the dates 2007-02-01 and 2007-02-02.
# Convert the Date and Time variables to Date/Time class.
# Convert the Global_active_power data to numeric class.
pdata <- subset(rdata, rdata$Date == as.Date("1/2/2007", format="%d/%m/%Y") | rdata$Date == as.Date("2/2/2007", format="%d/%m/%Y"))
pdata$Date.Time <- strptime(paste(pdata$Date, pdata$Time),  format = "%Y-%m-%d %H:%M:%S")
pdata$Global_active_power <- as.numeric(as.character(pdata$Global_active_power))

# Plot "Global_active_power" vs. Datetime and write the plot to plot2.png file
plot(pdata$Date.Time, pdata$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.copy(png, file = "plot2.png")
dev.off()