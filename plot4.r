# Test if the data file exists in the working directory.
# If not, download and unzip the file.
# Note: I am using Windows 64bit system, without the curl library. I have to set setInternet2 true and download the https files. 

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
pdata <- subset(rdata, rdata$Date == as.Date("1/2/2007", format="%d/%m/%Y") | rdata$Date == as.Date("2/2/2007", format="%d/%m/%Y"))

# Convert the Date and Time variables to Date/Time class.
pdata$Date.Time <- strptime(paste(pdata$Date, pdata$Time),  format = "%Y-%m-%d %H:%M:%S")
# Convert the measurement data to numeric class.
pdata$Global_active_power <- as.numeric(as.character(pdata$Global_active_power))
pdata$Global_reactive_power <- as.numeric(as.character(pdata$Global_reactive_power))
pdata$Voltage <- as.numeric(as.character(pdata$Voltage))
for (i in 7:9) {pdata[, i] <- as.numeric(as.character(pdata[, i]))}

# Adjust plotting parameters.
par(mfcol = c(2, 2), mar=c(4.1, 4, 3, 1))

# plot "Global_active_power" vs. time
plot(pdata$Date.Time, pdata$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

# plot "Energy sub metering" vs time
## get the range for the x and y axis 
xrange <- range(pdata$Date.Time) 
yrange <- range(c(pdata$Sub_metering_1, pdata$Sub_metering_2, pdata$Sub_metering_3))

## set up the plot 
plot(xrange, yrange, type="n", xlab="", ylab="Energy sub metering")

## add lines.
lines(pdata$Date.Time, pdata$Sub_metering_1, type="l", col = "black")
lines(pdata$Date.Time, pdata$Sub_metering_2, type="l", col = "red")  
lines(pdata$Date.Time, pdata$Sub_metering_3, type="l", col = "blue") 

## add a legend.
legend("topright", pch = "-", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", cex = 0.8)

# plot "Voltage" vs datetime.
plot(pdata$Date.Time, pdata$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# plot "Global_reactive_power" vs datetime.
plot(pdata$Date.Time, pdata$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
 
# write the plot to plot4.png file.
dev.copy(png, file = "plot4.png")
dev.off()