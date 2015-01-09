#Find the time difference in minutes between the beginning
#of first day and beginning of third day (same as end of
#second day). This will be the number of rows to read from
#the .txt file, in which the rows are measurements taken
#in one-minute intervals 

time_diff <- difftime(as.POSIXct("2007-02-03"), as.POSIXct("2007-02-01"),units="mins")
num_rows <- as.numeric(time_diff)

#Find out how many rows to skip in the file before
#finding the difference in minutes from the time of the
#first entry in the .txt to the time of the first entry
#from Februrary 1, 2007

first_entry <-scan("household_power_consumption.txt",skip=1,nlines=1, what="",sep="\n")
first_entry <- strsplit(first_entry, ";")
first_date <- paste(c(first_entry[[1]][1], first_entry[[1]][2]),collapse = " ")
first_date <- as.POSIXct(first_date,format = "%d/%m/%Y %H:%M:%S")
diff_from_first <- difftime(as.POSIXct("2007-02-01 00:00:00"),first_date,units="mins")

#Read only lines from Feb 1 and Feb 2 only
#and turn into matrix
data <- scan("household_power_consumption.txt",skip=abs(as.numeric(diff_from_first)) + 1,nlines=num_rows,what="",sep="\n")
data<-strsplit(data,";")
data<-do.call("rbind",data)

#Read in first line for headers and assign names to
#columns of data frame created from data matrix
col_names <-scan("household_power_consumption.txt",skip=0,nlines=1, what="",sep="\n")
col_names <- strsplit(col_names,";")
colnames(data) <- unlist(col_names)
data <- data.frame(data)

#Add column of POSIXct values for combined date and time
date_and_time <- paste(data$Date,data$Time)
date_and_time <- as.POSIXct(date_and_time,format="%d/%m/%Y %H:%M:%S")
data$POSIXTime <- date_and_time

#make plot and add line for Global Active Power over days
png(filename = "plot2.png",
    width = 480, height = 480, units = "px")
plot(data$POSIXTime,as.numeric(as.character(data$Global_active_power)),type="n",xlab="",ylab="Global Active Power (kilowatts)")
lines(data$POSIXTime,as.numeric(as.character(data$Global_active_power)))
dev.off()