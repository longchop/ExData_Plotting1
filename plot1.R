# Load libraries up -------------------------------------------------------

library(dplyr) #Easy for data munging
library(sqldf) #Load only required days

# Where doe the file exist in workspace and download? ---------------------------------------

loc_hpc <- "household_power_consumption.txt"

# Does the file exist? If not download the zip file
if (!file.exists(loc_hpc)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, "exdata_data_household_power_consumption.zip")
}

# Does the file exist? If not unzip the zip file
if (!file.exists("loc_hpc")){
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

# Plot1 -------------------------------------------------------------------
# Create a histogram for Global Active Power

png("plot1.png",width = 480, height = 480)

par(mfrow=c(1,1))
tbl_Consumption %>% 
    with(hist(Global_active_power,col = "red"
              ,main="Global Active Power"
              ,xlab="Global Active Power (Kilowatts)"))
dev.off()