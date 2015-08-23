## This R script run_analysis.R does the following: 
## 1 Merges the training and the test sets to create one data set.
## 2 Extracts only the measurements on the mean and standard deviation for each
##   measurement. 
## 3 Uses descriptive activity names to name the activities in the data set
## 4 Appropriately labels the data set with descriptive variable names. 
## 5 From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.

## 1 Merge the training and the test sets to create one data set.

## load the column variables from 'features.txt'
dfFeatures <- read.table("./data/UCI HAR Dataset/features.txt")

## load the training and test sets into data frames, using dfFeatures$V2 for column names
dfTrainingSet <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = dfFeatures$V2)
dfTestSet <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = dfFeatures$V2)

## load the Subject and Activity data for the training and test data sets
dfTrainingSubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
dfTrainingActivities <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "Activity")

dfTestSubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
dfTestActivities <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "Activity")

## finally we can combine the data sets
dfCombinedTrainingSet <- cbind(dfTrainingSubjects, dfTrainingActivities, dfTrainingSet)
dfCombinedTestSet <- cbind(dfTestSubjects, dfTestActivities, dfTestSet)
dfCombinedSet <- rbind(dfCombinedTrainingSet, dfCombinedTestSet)


## 2 Extract only the measurements on the mean and standard deviation for each measurement. 

## use the dplyr package for this, and subsequent use
library(dplyr)
## select the columns we want, using a regular expression in 'matches'
dfReduced <- dfCombinedSet %>% select(Subject, Activity, matches("(.mean.)|(.std.)"))

## 3 Use descriptive activity names to name the activities in the data set

## load the labels into a dataframe, and clean it by replacing "_" with " "
dfActivityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt") %>%
        mutate_each(funs(gsub("_", " ", .)), V2)
## now merge the data, and since merge re-orders data, arrange the data to our liking
dfMerged <- merge(dfReduced, dfActivityLabels, by.x = "Activity", by.y = "V1", all.x = TRUE)
dfMerged <- mutate(dfMerged, Activity = V2) %>%
        arrange(Subject, Activity)

## 4 Appropriately label the data set with descriptive variable names

## The data set already has descriptive variable names by virtue of step 1.

## 5 From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.

## use dplyr functions to summarise each column that we want to average (mean/std)
dfSummarized <- dfMerged %>% 
        group_by(Subject,Activity) %>% 
        summarise_each(funs(mean), matches("(.mean.)|(.std.)"))
## write this tiny data to a file
write.table(dfSummarized, "./data/UCI HAR Dataset/tidy_data_set.txt", row.names = FALSE)

