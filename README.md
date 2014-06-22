===============================================================================
Getting and Cleaning Data Course Project
README.md - Version 1.0
===============================================================================
Prior to execution
===============================================================================

*The script file run_Analysis.R is organized as a single function mergeData()
*The script requires that the file run_Analysis.R be present in the working directory.
*Please set your working directory with setwd() prior to executing the script.
*The script does not download the files to limit multiple hits to the web URL every time the script is executed
*You can download the file for the first time by executing the following snippet.

	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
	unzip("Dataset.zip")

*The script assumes that the same files names and folder structure as the original download is maintained. Reproduced here for reference.
 
 
*+---<Working Directory>
*  ---run_analysis.R
*  +--UCI HAR Dataset
*     +--test
*     	---subject_test.txt
*     	---X_test.txt
*     	---y_test.txt
*     +--train
*     	---subject_train.txt
*     	---X_train.txt
*     	---y_train.txt
*     ---activity_labels.txt
*     ---features.txt
*     ---features_info.txt


Data processing performed:
======================================

* This function creates performs a series of steps for merging the  
* data fields for machine data files provided and then append the 
* test and training data sets. Additional data cleanup and formatting
* are performed subsequenty and the tidy data set is created by taking
* the mean 

Output
=========================================

* Two data frames are created 
* First data frame 'myselectdata' has the Suject and Activity data along with
* the features on the mean and standard deviation 
* Second data frame 'avgdata' has the average of the selected features 
* for each subject and activity
* The two dataframes are extracted as files. myselectdata dataframe is 
  extracted to file 'selectdatafile.txt'. avgdata dataframe is extracted 
  to file 'avgdatafile.txt'

Reference:
========
The original dataset used for this exercise was published as part of the below research paper

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
Vitoria-Gasteiz, Spain. Dec 2012

