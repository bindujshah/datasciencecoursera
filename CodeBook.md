---
title: "CodeBook for Getting and Cleaning Data Project"
author: "Bindu Shah"
date: "January 11, 2017"
output: html_document
---



## R Markdown

This is an R Markdown document to support the project for teh course:
Getting and Cleaning Dta

##INSTRUCTIONS FOR THIS PROJECT:
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement.
3.Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



## DATA

Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 


There are two sets of metric data - TEST and TRAIN

The files used for the assignment are:

activity_labels.txt containing a lookup of activity label for a given activity id

features.txt containing column names for the metric files

x_train containing metrics (without headers or subjects or actvity information)
y_train containing the activity associated with the metric record
subject_train containing the subject associated with the metric record

x_test containing metrics (without headers or subjects or actvity information)
y_test containing the activity associated with the metric record
subject_test containing the subject associated with the metric record

##SYNOPISIS Of run_analysis.R script 
- downloads the zipped data set and unzips the files.
- reads the files

-for both the Test and Train data sets, 
    1. Column headers are added to the metrics files.
    2. Subject ID and Activity ID is associated with each metric record 
    3. Activity labels are added 

-the Test and Train data sets are combined. 
NOTE that an addiitonal column called "source" is added to identify whether the metric record came from the TEST or TRAIN data set

- a subsetis created with Only MEAN and STD metrics along with Subject ID and Activity ID are preserved.

- Activity labels are added to this data set

- A new data set is created with the average MEAN and STD metrics
- This data set is then written to a file called "TidyDataSet.txt" so it can be used independently.

## Download data files

```r
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile="smartphoneproj.zip")
unzip(zipfile="smartphoneproj.zip")
```

## Read data files

```r
features<- read.table("features.txt")
dim(features)
```

```
## [1] 561   2
```

```r
activity_labels<-read.table("activity_labels.txt")

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
```

## Task 4. Appropriately label the data sets with descriptive variable names
## for Activity

```r
colnames(activity_labels) <- c("activity_id", "activity")

## For Test data
colnames(x_test)<-features[,2]
colnames(y_test)<-"activity_id"
colnames(subject_test)<-"subject_id"

## for Train data
colnames(x_train)<-features[,2]
colnames(y_train)<-"activity_id"
colnames(subject_train)<-"subject_id"
```


## Task 1. Merge the test and training data sets


```r
## merge Subject, Activity with Measures for Test Data
test<-cbind(subject_test, y_test, x_test)
## Column 'Source" preserves information about where data set was obtained
test$source<-"test"

## merge columns Subject, Activity with Measures for Train Data
train<-cbind(subject_train, y_train, x_train)
## Column 'Source" preserves information about where data set was obtained
train$source<-"train"

## Merge rows from test and train data sets
test_train <- rbind(test, train)

##Check if merge worked
dim(test)
```

```
## [1] 2947  564
```

```r
dim(train)
```

```
## [1] 7352  564
```

```r
dim(test_train)
```

```
## [1] 10299   564
```

## Task 2. Extract only "mean" and Std" measurements

```r
mean_std_cols<-(grepl("subject_id", colnames(test_train)) | 
                grepl("activity_id", colnames(test_train)) | 
                grepl("mean", colnames(test_train)) | 
                grepl("std", colnames(test_train))   )


summary(mean_std_cols)
```

```
##    Mode   FALSE    TRUE    NA's 
## logical     483      81       0
```

```r
test_train_mean_std<-test_train[,mean_std_cols == TRUE]
```

## Task 3. Use descriptive activity names

```r
test_train_mean_std_with_activity<-
                   merge(test_train_mean_std, 
                         activity_labels, 
                         by= 'activity_id', 
                         all.X=TRUE)
```

## Task 5. Create an independent tidy dataset  the average of each variable for each activity and each subject.

```r
tidydataset<- aggregate(. ~ subject_id + activity, data =test_train_mean_std_with_activity, mean)
dim(tidydataset)
```

```
## [1] 180  82
```

```r
str(tidydataset)
```

```
## 'data.frame':	180 obs. of  82 variables:
##  $ subject_id                     : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ activity                       : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ activity_id                    : num  6 6 6 6 6 6 6 6 6 6 ...
##  $ tBodyAcc-mean()-X              : num  0.222 0.281 0.276 0.264 0.278 ...
##  $ tBodyAcc-mean()-Y              : num  -0.0405 -0.0182 -0.019 -0.015 -0.0183 ...
##  $ tBodyAcc-mean()-Z              : num  -0.113 -0.107 -0.101 -0.111 -0.108 ...
##  $ tBodyAcc-std()-X               : num  -0.928 -0.974 -0.983 -0.954 -0.966 ...
##  $ tBodyAcc-std()-Y               : num  -0.837 -0.98 -0.962 -0.942 -0.969 ...
##  $ tBodyAcc-std()-Z               : num  -0.826 -0.984 -0.964 -0.963 -0.969 ...
##  $ tGravityAcc-mean()-X           : num  -0.249 -0.51 -0.242 -0.421 -0.483 ...
##  $ tGravityAcc-mean()-Y           : num  0.706 0.753 0.837 0.915 0.955 ...
##  $ tGravityAcc-mean()-Z           : num  0.446 0.647 0.489 0.342 0.264 ...
##  $ tGravityAcc-std()-X            : num  -0.897 -0.959 -0.983 -0.921 -0.946 ...
##  $ tGravityAcc-std()-Y            : num  -0.908 -0.988 -0.981 -0.97 -0.986 ...
##  $ tGravityAcc-std()-Z            : num  -0.852 -0.984 -0.965 -0.976 -0.977 ...
##  $ tBodyAccJerk-mean()-X          : num  0.0811 0.0826 0.077 0.0934 0.0848 ...
##  $ tBodyAccJerk-mean()-Y          : num  0.00384 0.01225 0.0138 0.00693 0.00747 ...
##  $ tBodyAccJerk-mean()-Z          : num  0.01083 -0.0018 -0.00436 -0.00641 -0.00304 ...
##  $ tBodyAccJerk-std()-X           : num  -0.958 -0.986 -0.981 -0.978 -0.983 ...
##  $ tBodyAccJerk-std()-Y           : num  -0.924 -0.983 -0.969 -0.942 -0.965 ...
##  $ tBodyAccJerk-std()-Z           : num  -0.955 -0.988 -0.982 -0.979 -0.985 ...
##  $ tBodyGyro-mean()-X             : num  -0.01655 -0.01848 -0.02082 -0.00923 -0.02189 ...
##  $ tBodyGyro-mean()-Y             : num  -0.0645 -0.1118 -0.0719 -0.093 -0.0799 ...
##  $ tBodyGyro-mean()-Z             : num  0.149 0.145 0.138 0.17 0.16 ...
##  $ tBodyGyro-std()-X              : num  -0.874 -0.988 -0.975 -0.973 -0.979 ...
##  $ tBodyGyro-std()-Y              : num  -0.951 -0.982 -0.977 -0.961 -0.977 ...
##  $ tBodyGyro-std()-Z              : num  -0.908 -0.96 -0.964 -0.962 -0.961 ...
##  $ tBodyGyroJerk-mean()-X         : num  -0.107 -0.102 -0.1 -0.105 -0.102 ...
##  $ tBodyGyroJerk-mean()-Y         : num  -0.0415 -0.0359 -0.039 -0.0381 -0.0404 ...
##  $ tBodyGyroJerk-mean()-Z         : num  -0.0741 -0.0702 -0.0687 -0.0712 -0.0708 ...
##  $ tBodyGyroJerk-std()-X          : num  -0.919 -0.993 -0.98 -0.975 -0.983 ...
##  $ tBodyGyroJerk-std()-Y          : num  -0.968 -0.99 -0.987 -0.987 -0.984 ...
##  $ tBodyGyroJerk-std()-Z          : num  -0.958 -0.988 -0.983 -0.984 -0.99 ...
##  $ tBodyAccMag-mean()             : num  -0.842 -0.977 -0.973 -0.955 -0.967 ...
##  $ tBodyAccMag-std()              : num  -0.795 -0.973 -0.964 -0.931 -0.959 ...
##  $ tGravityAccMag-mean()          : num  -0.842 -0.977 -0.973 -0.955 -0.967 ...
##  $ tGravityAccMag-std()           : num  -0.795 -0.973 -0.964 -0.931 -0.959 ...
##  $ tBodyAccJerkMag-mean()         : num  -0.954 -0.988 -0.979 -0.97 -0.98 ...
##  $ tBodyAccJerkMag-std()          : num  -0.928 -0.986 -0.976 -0.961 -0.977 ...
##  $ tBodyGyroMag-mean()            : num  -0.875 -0.95 -0.952 -0.93 -0.947 ...
##  $ tBodyGyroMag-std()             : num  -0.819 -0.961 -0.954 -0.947 -0.958 ...
##  $ tBodyGyroJerkMag-mean()        : num  -0.963 -0.992 -0.987 -0.985 -0.986 ...
##  $ tBodyGyroJerkMag-std()         : num  -0.936 -0.99 -0.983 -0.983 -0.984 ...
##  $ fBodyAcc-mean()-X              : num  -0.939 -0.977 -0.981 -0.959 -0.969 ...
##  $ fBodyAcc-mean()-Y              : num  -0.867 -0.98 -0.961 -0.939 -0.965 ...
##  $ fBodyAcc-mean()-Z              : num  -0.883 -0.984 -0.968 -0.968 -0.977 ...
##  $ fBodyAcc-std()-X               : num  -0.924 -0.973 -0.984 -0.952 -0.965 ...
##  $ fBodyAcc-std()-Y               : num  -0.834 -0.981 -0.964 -0.946 -0.973 ...
##  $ fBodyAcc-std()-Z               : num  -0.813 -0.985 -0.963 -0.962 -0.966 ...
##  $ fBodyAcc-meanFreq()-X          : num  -0.159 -0.146 -0.074 -0.274 -0.136 ...
##  $ fBodyAcc-meanFreq()-Y          : num  0.0975 0.2573 0.2385 0.3662 0.4665 ...
##  $ fBodyAcc-meanFreq()-Z          : num  0.0894 0.4025 0.217 0.2013 0.1323 ...
##  $ fBodyAccJerk-mean()-X          : num  -0.957 -0.986 -0.981 -0.979 -0.983 ...
##  $ fBodyAccJerk-mean()-Y          : num  -0.922 -0.983 -0.969 -0.944 -0.965 ...
##  $ fBodyAccJerk-mean()-Z          : num  -0.948 -0.986 -0.979 -0.975 -0.983 ...
##  $ fBodyAccJerk-std()-X           : num  -0.964 -0.987 -0.983 -0.98 -0.986 ...
##  $ fBodyAccJerk-std()-Y           : num  -0.932 -0.985 -0.971 -0.944 -0.966 ...
##  $ fBodyAccJerk-std()-Z           : num  -0.961 -0.989 -0.984 -0.98 -0.986 ...
##  $ fBodyAccJerk-meanFreq()-X      : num  0.132 0.16 0.176 0.182 0.24 ...
##  $ fBodyAccJerk-meanFreq()-Y      : num  0.0245 0.1212 -0.0132 0.0987 0.1957 ...
##  $ fBodyAccJerk-meanFreq()-Z      : num  0.0244 0.1906 0.0448 0.077 0.0917 ...
##  $ fBodyGyro-mean()-X             : num  -0.85 -0.986 -0.97 -0.967 -0.976 ...
##  $ fBodyGyro-mean()-Y             : num  -0.952 -0.983 -0.978 -0.972 -0.978 ...
##  $ fBodyGyro-mean()-Z             : num  -0.909 -0.963 -0.962 -0.961 -0.963 ...
##  $ fBodyGyro-std()-X              : num  -0.882 -0.989 -0.976 -0.975 -0.981 ...
##  $ fBodyGyro-std()-Y              : num  -0.951 -0.982 -0.977 -0.956 -0.977 ...
##  $ fBodyGyro-std()-Z              : num  -0.917 -0.963 -0.967 -0.966 -0.963 ...
##  $ fBodyGyro-meanFreq()-X         : num  -0.00355 0.10261 -0.08222 -0.06609 -0.02272 ...
##  $ fBodyGyro-meanFreq()-Y         : num  -0.0915 0.0423 -0.0267 -0.5269 0.0681 ...
##  $ fBodyGyro-meanFreq()-Z         : num  0.0105 0.0553 0.1477 0.1529 0.0414 ...
##  $ fBodyAccMag-mean()             : num  -0.862 -0.975 -0.966 -0.939 -0.962 ...
##  $ fBodyAccMag-std()              : num  -0.798 -0.975 -0.968 -0.937 -0.963 ...
##  $ fBodyAccMag-meanFreq()         : num  0.0864 0.2663 0.237 0.2417 0.292 ...
##  $ fBodyBodyAccJerkMag-mean()     : num  -0.933 -0.985 -0.976 -0.962 -0.977 ...
##  $ fBodyBodyAccJerkMag-std()      : num  -0.922 -0.985 -0.975 -0.958 -0.976 ...
##  $ fBodyBodyAccJerkMag-meanFreq() : num  0.266 0.342 0.239 0.274 0.197 ...
##  $ fBodyBodyGyroMag-mean()        : num  -0.862 -0.972 -0.965 -0.962 -0.968 ...
##  $ fBodyBodyGyroMag-std()         : num  -0.824 -0.961 -0.955 -0.947 -0.959 ...
##  $ fBodyBodyGyroMag-meanFreq()    : num  -0.1398 0.0186 -0.0229 -0.2599 0.1024 ...
##  $ fBodyBodyGyroJerkMag-mean()    : num  -0.942 -0.99 -0.984 -0.984 -0.985 ...
##  $ fBodyBodyGyroJerkMag-std()     : num  -0.933 -0.989 -0.983 -0.983 -0.983 ...
##  $ fBodyBodyGyroJerkMag-meanFreq(): num  0.1765 0.2648 0.1107 0.2029 0.0247 ...
```

```r
write.table(tidydataset, "TidyDataSet.txt", sep="\t", row.names=FALSE)
```

