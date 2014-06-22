## This function creates performs a series of steps for merging the  
## data fields for machine data files provided and then append the 
## test and training data sets. Additional data cleanup and formatting
## are performed subsequenty and the tidy data set is created

mergeData <- function() {

library(doBy)

## Read the test subject file as a single column fixed width file
## Override the default column name with the string "Subject"
file1 <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
data1 <- read.fwf(file1, c(1),skip=0)
colnames(data1) <- c("Subject")

## Read the test activity file as a single column fixed width file
## Override the default column name with the string "Activity"
file2 <- ".\\UCI HAR Dataset\\test\\y_test.txt"
data2 <- read.fwf(file2, c(1),skip=0)
colnames(data2) <- c("Activity")

## Read the test data file as a space delimited file with numerics
## Separator not explicity provided as read.table considers single or
## multiple spaces as separator by default
file3 <- ".\\UCI HAR Dataset\\test\\X_test.txt"
data3 <- read.table(file3, comment.char = "",colClasses="numeric")
         
## Combine the three test data frames using cbind to create the test 
## data frame
testdata <- cbind(data1,data2,data3)

## Read the training subject file as a single column fixed width file
## Override the default column name with the string "Subject"
file4 <- ".\\UCI HAR Dataset\\train\\subject_train.txt"
data4 <- read.fwf(file4, c(1),skip=0)
colnames(data4) <- c("Subject")

## Read the training activity file as a single column fixed width file
## Override the default column name with the string "Activity"
file5 <- ".\\UCI HAR Dataset\\train\\y_train.txt"
data5 <- read.fwf(file5, c(1),skip=0)
colnames(data5) <- c("Activity")

## Read the training data file as a space delimited file with numerics
## Separator not explicity provided as read.table considers single or
## multiple spaces as separator by default
file6 <- ".\\UCI HAR Dataset\\train\\X_train.txt"
data6 <- read.table(file6, comment.char = "",colClasses="numeric")

## Combine the three training data frames using cbind to create the training
## data frame
traindata <- cbind(data4,data5,data6)

## Append the test and training data frames using rbind to create a 
## consolidated data frame
mydata <- rbind(testdata,traindata)

## Read the feature file to get the names of the field names
file7 <- ".\\UCI HAR Dataset\\features.txt"
features <- read.table(file7)

## Extract hte indices corresponding to those features that have 'mean' or
## 'std' in their name
meanstdindex <- grep("std|mean",features$V2)

## Manipulate the indices to create the column name for the field that
## needs to be extracted
meanstdcolnames <- paste("V", meanstdindex, sep="")

## Extract the first two columns as it is corresponds to subject and activity
myselectdata1 <- subset(mydata, select = 1:2)
## Extract only the columns that have the mean and std deviation measurements
myselectdata2 <- subset(mydata, select = meanstdcolnames )
# Merge the extracted columns with subject and activity
myselectdata <- cbind(myselectdata1,myselectdata2)

## Substitute the activity values in the data frame by the descriptive
## activity name
myselectdata$Activity <- gsub("1", "WALKING", myselectdata$Activity)
myselectdata$Activity <- gsub("2", "WALKING_UPSTAIRS", myselectdata$Activity)
myselectdata$Activity <- gsub("3", "WALKING_DOWNSTAIRS", myselectdata$Activity)
myselectdata$Activity <- gsub("4", "SITTING", myselectdata$Activity)
myselectdata$Activity <- gsub("5", "STANDING", myselectdata$Activity)
myselectdata$Activity <- gsub("6", "LAYING", myselectdata$Activity)

## Clean up the column names by removing occurances of () and -
## This is to make future processing of the data easier as R considers
## the above as reserved keywords
tempnames <-features[meanstdindex,]
colnames<-c('Subject','Activity',as.character(tempnames$V2))
colnames <- gsub("\\()|-","",colnames)
colnames(myselectdata) <- c(colnames)

## Create a second data frame that has the average of each column for
## each subject and activity 
avgdata<-aggregate(myselectdata[,3:81], 
          by=list(myselectdata$Subject, myselectdata$Activity), FUN=mean,na.rm=TRUE)

names(avgdata)[1]<-paste("Subject")
names(avgdata)[2]<-paste("Activity")

## Write the myselectdata dataframe to a text file
myselectdatafile <- file("selectdatafile.txt")
write.table(myselectdata,myselectdatafile)

## Write the avgdata dataframe to a text file
avgfile <- file("avgdatafile.txt")
write.table(avgdata,avgfile)

}