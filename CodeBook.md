===============================================================================
Getting and Cleaning Data Course Project
CodeBook.md - Version 1.0
===============================================================================
Overview
===============================================================================
This file describes the original data set, the variables contained, and the 
data procesing that has been performed to clean up the data and arrive at a
tidy dataset.

===============================================================================
Background on the original experiment
===============================================================================

The experiments have been carried out with a group of 30 volunteers within an 
age bracket of 19-48 years. Each person performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded 
accelerometer and gyroscope, the  3-axial linear acceleration and 3-axial 
angular velocity at a constant rate of 50Hz were captured.  The experiments 
have been video-recorded to label the data manually. The obtained dataset has 
been randomly partitioned into two sets, where 70% of the volunteers was 
selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying 
noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 
50% overlap (128 readings/window). The sensor acceleration signal, which has 
gravitational and body motion components, was separated using a Butterworth 
low-pass filter into body acceleration and gravity. The gravitational force is 
assumed to have only low frequency components, therefore a filter with 0.3 Hz 
cutoff frequency was used. From each window, a vector of features was obtained 
by calculating variables from the time and frequency domain. 

Refer http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using
+Smartphones for additional information

The original dataset includes the following files:

'features_info.txt': Shows information about the variables used on the feature
vector.
'features.txt': List of all features.
'activity_labels.txt': Links the class labels with their activity name.
'train/X_train.txt': Training set.
'train/y_train.txt': Training labels.
'test/X_test.txt': Test set.
'test/y_test.txt': Test labels.
'train/subject_train.txt': Each row identifies the subject who performed the 
activity for each window sample. Its range is from 1 to 30.
'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from
the smartphone accelerometer X axis in standard gravity units 'g'. Every row 
shows a 128 element vector. The same description applies for the 
'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal 
obtained by subtracting the gravity from the total acceleration.
'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector 
measured by the gyroscope for each window sample. The units are radians/second.

===============================================================================
Prior to execution
===============================================================================

-The script file run_Analysis.R is organized as a single function mergeData()
-The script requires that the file run_Analysis.R be present in the working 
 directory.
-Please set your working directory with setwd() prior to executing the script.
-The script does not download the files to limit multiple hits to the web URL
 every time the script is executed
-You can download the file for the first time by executing the following 
 snippet.

	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
	unzip("Dataset.zip")

-The script assumes that the same files names and folder structure as the 
 original download is maintained. Reproduced here for reference.
 
 
+---<Working Directory>
  ---run_analysis.R
  +--UCI HAR Dataset
     +--test
     	---subject_test.txt
     	---X_test.txt
     	---y_test.txt
     +--train
     	---subject_train.txt
     	---X_train.txt
     	---y_train.txt
     ---activity_labels.txt
     ---features.txt
     ---features_info.txt

===============================================================================
Transformations Performed
===============================================================================

As outlined above the dataset has been stored in the UCI HAR Dataset directory 
The working directory is the parent directory of UCI HAR Dataset directory

a. Read the test subject file as a single column fixed width file. Override the 
   default column name with the string "Subject"
   
	   file1 <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
	   data1 <- read.fwf(file1, c(1),skip=0)
	   colnames(data1) <- c("Subject")

b. Read the test activity file as a single column fixed width file. Override the 
   default column name with the string "Activity"
   
	   file2 <- ".\\UCI HAR Dataset\\test\\y_test.txt"
	   data2 <- read.fwf(file2, c(1),skip=0)
	   colnames(data2) <- c("Activity")
      
c. Read the test data file as a space delimited file with numerics. Separator not 
   explicity provided as read.table considers single or multiple spaces as 
   separator by default
   
	   file3 <- ".\\UCI HAR Dataset\\test\\X_test.txt"
	   data3 <- read.table(file3, comment.char = "",colClasses="numeric")

d. Combine the three test data frames using cbind to create the test data frame

	   testdata <- cbind(data1,data2,data3)
	   
e. Repeat similar steps (a through d) for training data set and create a single
   training data set

f. Append the test and training data frames using rbind to create a consolidated 
   data frame. This data frame has 10299 records and 563 columns
   
   	   mydata <- rbind(testdata,traindata)
   	   
g. Read the feature file to get the names of the field names

	   file7 <- ".\\UCI HAR Dataset\\features.txt"
	   features <- read.table(file7)
	   
h. Extract the indices corresponding to those features that have 'mean' or 'std' 
   in their name. Manipulate the indices to create the column name for the fields 
   that needs to be extracted
   
	   meanstdindex <- grep("std|mean",features$V2)
	   meanstdcolnames <- paste("V", meanstdindex, sep="")
   
i. Create a new dataframe that has only columns that have the mean and std 
   deviation measurements along with the subject and activity
   
	   myselectdata1 <- subset(mydata, select = 1:2)
	   myselectdata2 <- subset(mydata, select = meanstdcolnames )
	   myselectdata <- cbind(myselectdata1,myselectdata2)
   
j. Substitute the activity values in the data frame by the descriptive activity 
   name
	   myselectdata$Activity <- gsub("1", "WALKING", myselectdata$Activity)
	   myselectdata$Activity <- gsub("2", "WALKING_UPSTAIRS", myselectdata$Activity)
      	   myselectdata$Activity <- gsub("3", "WALKING_DOWNSTAIRS", myselectdata$Activity)
	   myselectdata$Activity <- gsub("4", "SITTING", myselectdata$Activity)
	   myselectdata$Activity <- gsub("5", "STANDING", myselectdata$Activity)
 	   myselectdata$Activity <- gsub("6", "LAYING", myselectdata$Activity)

k. Clean up the column names by removing occurances of () and -.  This is to make 
   future processing of the data easier as R considers the above as reserved 
   keywords
	   tempnames <-features[meanstdindex,]
	   colnames<-c('Subject','Activity',as.character(tempnames$V2))
	   colnames <- gsub("\\()|-","",colnames)
	   colnames(myselectdata) <- c(colnames)
	   
l. Create a second data frame that has the average of each column for each subject
   and activity 
   
	   avgdata<-aggregate(myselectdata[,3:81], 
		     by=list(myselectdata$Subject, myselectdata$Activity), FUN=mean,na.rm=TRUE)

j The two dataframes are extracted as files. myselectdata dataframe is 
  extracted to file 'selectdatafile.txt'. avgdata dataframe is extracted 
  to file 'avgdatafile.txt'
  
	  myselectdatafile <- file("selectdatafile.txt")
	  write.table(myselectdata,myselectdatafile)
	  avgfile <- file("avgdatafile.txt")
	  write.table(avgdata,avgfile)
	  
k. The output dataset consists of the following fields
	Subject
	Activity
	tBodyAccmeanX
	tBodyAccmeanY
	tBodyAccmeanZ
	tBodyAccstdX
	tBodyAccstdY
	tBodyAccstdZ
	tGravityAccmeanX
	tGravityAccmeanY
	tGravityAccmeanZ
	tGravityAccstdX 
	tGravityAccstdY
	tGravityAccstdZ
	tBodyAccJerkmeanX
	tBodyAccJerkmeanY
	tBodyAccJerkmeanZ
	tBodyAccJerkstdX
	tBodyAccJerkstdY
	tBodyAccJerkstdZ
	tBodyGyromeanX
	tBodyGyromeanY
	tBodyGyromeanZ
	tBodyGyrostdX
	tBodyGyrostdY
	tBodyGyrostdZ
	tBodyGyroJerkmeanX 
	tBodyGyroJerkmeanY 
	tBodyGyroJerkmeanZ 
	tBodyGyroJerkstdX
	tBodyGyroJerkstdY
	tBodyGyroJerkstdZ
	tBodyAccMagmean
	tBodyAccMagstd
	tGravityAccMagmean 
	tGravityAccMagstd
	tBodyAccJerkMagmean
	tBodyAccJerkMagstd
	tBodyGyroMagmean
	tBodyGyroMagstd
	tBodyGyroJerkMagmean 
	tBodyGyroJerkMagstd
	fBodyAccmeanX
	fBodyAccmeanY
	fBodyAccmeanZ
	fBodyAccstdX
	fBodyAccstdY
	fBodyAccstdZ
	fBodyAccmeanFreqX
	fBodyAccmeanFreqY
	fBodyAccmeanFreqZ
	fBodyAccJerkmeanX
	fBodyAccJerkmeanY
	fBodyAccJerkmeanZ
	fBodyAccJerkstdX
	fBodyAccJerkstdY
	fBodyAccJerkstdZ
	fBodyAccJerkmeanFreqX
	fBodyAccJerkmeanFreqY
	fBodyAccJerkmeanFreqZ
	fBodyGyromeanX
	fBodyGyromeanY
	fBodyGyromeanZ
	fBodyGyrostdX
	fBodyGyrostdY
	fBodyGyrostdZ
	fBodyGyromeanFreqX
	fBodyGyromeanFreqY
	fBodyGyromeanFreqZ
	fBodyAccMagmean
	fBodyAccMagstd
	fBodyAccMagmeanFreq
	fBodyBodyAccJerkMagmean
	fBodyBodyAccJerkMagstd
	fBodyBodyAccJerkMagmeanFreq
	fBodyBodyGyroMagmean
	fBodyBodyGyroMagstd
	fBodyBodyGyroMagmeanFreq
	fBodyBodyGyroJerkMagmean
	fBodyBodyGyroJerkMagstd
	fBodyBodyGyroJerkMagmeanFreq
