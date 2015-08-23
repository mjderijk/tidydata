## You should create one R script run_analysis.R that does the following: 

setwd("Coursera")
setwd("GettingDataTidy")
setwd("project")
## 1 Merges the training and the test sets to create one data set.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("data")) {dir.create("data")}
download.file(fileUrl,destfile = "./data/getdata-projectfiles-UCI HAR Dataset.zip", mode = "wb")
unzip(destfile, exdir = "./data/")
library(dplyr)


## 2 Extracts only the measurements on the mean and standard deviation for each
##   measurement. 

## 3 Uses descriptive activity names to name the activities in the data set

## 4 Appropriately labels the data set with descriptive variable names. 

## 5 From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.

## tip: upload your data set as a txt file created with write.table() using 
##      row.name=FALSE (do not cut and paste a dataset directly into the text 
##      box, as this may cause errors saving your submission).