# Getting and Cleaning Data - Course Project
This repo is for the "Getting and Cleaning Data" course project.

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

1. Merge the training and the test sets to create one data set.

Before we can 
