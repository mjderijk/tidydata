# Getting and Cleaning Data - Course Project
This repo is for the "Getting and Cleaning Data" course project.
It includes an R Script ("run_analysis.R"") which produces a tidy data set ("tidy_data_set.txt").
Also included is a codebook (codebook.md) which describes the data.

The data is a (wide) tidy data file[1], conforming to Hadley Wickham's definition[2], that:

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

[1] Source: https://class.coursera.org/getdata-031/forum/thread?thread_id=28#post-117

[2] Source: http://www.jstatsoft.org/v59/i10/paper

To read and view the resultant tidy data set, you can use the following code[3]:
```
address <- "https://s3.amazonaws.com/coursera-uploads/user-551b7e54e333ca686e16f9e8/975115/asst-3/c586861049c911e58680c174f0365f13.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```
[3] Source: https://class.coursera.org/getdata-031/forum/thread?thread_id=113#post-443

First things first...
------
To begin with, I first ran the following to download the data and unzip the file:
```
setwd("Coursera")
setwd("GettingDataTidy")
setwd("project")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("data")) {dir.create("data")}
download.file(fileUrl,destfile = "./data/getdata-projectfiles-UCI HAR Dataset.zip", mode = "wb")
setwd("data")
unzip("getdata-projectfiles-UCI HAR Dataset.zip")
setwd("..")
```
Now we're ready to commence the different parts of the project.

1 Merge the training and the test sets to create one data set
------
My interpretation of README.txt as provided indicates that the records are ordered for the provided Subjects data and associated Activity data. The first thing to do then is to add this data for the Training and Test data before we merge the sets.

The data sets however do not have column names. These are located in 'features.txt'. So, we first load these into a data frame `dfFeatures` which we subsequently subset to get the right vector:
```
dfFeatures <- read.table("./data/UCI HAR Dataset/features.txt")
```
This yields:
```
> head(dfFeatures,3)
  V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
3  3 tBodyAcc-mean()-Z
```
Next, load the training and test sets into two data frames, using `dfFeatures$V2` for the column names:
```
dfTrainingSet <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = dfFeatures$V2)
dfTestSet <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = dfFeatures$V2)
```
Now we can add the Subject and Activity data. This is stored in train/subject.txt and train/y_train.txt, and correspondingly for test. We'll load these into respective dataframes, setting their column names accordingly:
```
dfTrainingSubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
dfTrainingActivities <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "Activity")

dfTestSubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
dfTestActivities <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
```
Finally, we can `cbind` and `rbind` to combine all the data:
```
dfCombinedTrainingSet <- cbind(dfTrainingSubjects, dfTrainingActivities, dfTrainingSet)
dfCombinedTestSet <- cbind(dfTestSubjects, dfTestActivities, dfTestSet)
dfCombinedSet <- rbind(dfCombinedTrainingSet, dfCombinedTestSet)
```

2 Extract only the measurements on the mean and standard deviation for each measurement
------
We will use the `dplyr` package for this:
```
library(dplyr)
dfReduced <- dfCombinedSet %>% select(Subject, Activity, matches("(.mean.)|(.std.)"))
```
This yields a wide data set, and by using `matches("(.mean.)|(.std.)")` we're using a regular expression to match any measurement column which contains either 'mean' or 'std', thus maintaining the relative order in which these columns appeared in the original data sets.

3 Use descriptive activity names to name the activities in the data set
------
Again we'll use the `dplyr` package to first read the activity labels in 'activity_labels.txt' and clean up the labels by replacing underscores with spaces:
```
dfActivityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt") %>%
        mutate_each(funs(gsub("_", " ", .)), V2)
```
Now we can merge the labels with our data frame, and finally re-order the data.
```
dfMerged <- merge(dfReduced, dfActivityLabels, by.x = "Activity", by.y = "V1", all.x = TRUE)
dfMerged <- mutate(dfMerged, Activity = V2) %>%
        arrange(Subject, Activity)
```
4 Appropriately label the data set with descriptive variable names
------
We've already done this in Step 1.

5 create a second, independent tidy data set with the average of each variable for each activity and each subject
------
We'll use dplyr functions to group our data, first by Subject, then by Activity. Now we can summarise each column that we want to average, using 'matches' for selecting our mean/std columns:
```
dfSummarized <- dfMerged %>% 
        group_by(Subject,Activity) %>% 
        summarise_each(funs(mean), matches("(.mean.)|(.std.)"))
```
Finally we just need to write out our data to a file:
```
write.table(dfSummarized, "./data/UCI HAR Dataset/tidy_data_set.txt", row.names = FALSE)
```

