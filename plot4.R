# Load libraries up -------------------------------------------------------

library(dplyr) #Easy for data munging
library(sqldf) #Load only required days
library(tcltk)
# Where doe the file exist in workspace and download? ---------------------------------------

loc_hpc <- "household_power_consumption.txt"

# Does the file exist? If not download the zip file
if (!file.exists(loc_hpc)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, "exdata_data_household_power_consumption.zip")
}

# Does the file exist? If not unzip the zip file
if (!file.exists(loc_hpc)){
    unzip("exdata_data_household_power_consumption.zip")
}

# Load data ---------------------------------------------------------------

# Read the table for the 1/2/07 and 2/2/07,
# Convert the date to a date class
# Create a date time column
tbl_Consumption <- tbl_df(read.csv.sql(loc_hpc,sql = "
                                       SELECT *
                                       FROM file
                                       WHERE Date='1/2/2007' OR
                                       Date='2/2/2007'",header = TRUE,sep = ";")) %>% 
    mutate(Date=as.Date(Date,"%d/%m/%Y"),
           DateTime=as.POSIXct(paste(Date,Time),format = "%Y-%m-%d %H:%M:%S"))
closeAllConnections()

# Plot 4 ------------------------------------------------------------------
# Create 2 by 2 trellis charts showing
# (1,1) Global Active Power line chart between 1/2/07 to 2/2/07
# (1,2) Voltage line chart between 1/2/07 to 2/2/07
# (2,1) Sub metering line chart between 1/2/07 to 2/2/07
# (2,2) Global Reactive Power line chart between 1/2/07 to 2/2/07

png("plot4.png",width = 480, height = 480)

par(mfrow = c(2,2))
tbl_Consumption %>% 
    with(plot(DateTime, Global_active_power,xlab="",ylab="Global Active Power",pch=NA_integer_)) 
    with(tbl_Consumption,lines(DateTime, Global_active_power))

tbl_Consumption %>% 
    with(plot(DateTime, Voltage,xlab="datetime",ylab="Voltage",pch=NA_integer_)) 
    with(tbl_Consumption,lines(DateTime, Voltage))      

tbl_Consumption %>% 
    with(plot(DateTime, Sub_metering_1,xlab="",ylab="Energy sub metering",pch=NA_integer_)) 
    with(tbl_Consumption,lines(DateTime, Sub_metering_1,col="Black"))
    with(tbl_Consumption,lines(DateTime, Sub_metering_2,col="Red"))
    with(tbl_Consumption,lines(DateTime, Sub_metering_3,col="Blue"))
    legend("topright",lwd = 1,col=c("Black","Red","Blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty = "n")

tbl_Consumption %>% 
    with(plot(DateTime, Global_reactive_power,xlab="datetime",ylab="Global_reactive_power",pch=NA_integer_)) 
with(tbl_Consumption,lines(DateTime, Global_reactive_power))  

dev.off()   