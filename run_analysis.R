## Download data files

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile="smartphoneproj.zip")
unzip(zipfile="smartphoneproj.zip")

## Read data files

features<- read.table("features.txt")
dim(features)

activity_labels<-read.table("activity_labels.txt")

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

## 4. Appropriately label the data sets with descriptive variable names
## for Activity
colnames(activity_labels) <- c("activity_id", "activity")

## For Test data
colnames(x_test)<-features[,2]
colnames(y_test)<-"activity_id"
colnames(subject_test)<-"subject_id"

## for Train data
colnames(x_train)<-features[,2]
colnames(y_train)<-"activity_id"
colnames(subject_train)<-"subject_id"

## 1 Merge the test and training data sets
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
dim(train)
dim(test_train)

## 2. Extract only "mean" and Std" measurements
mean_std_cols<-(grepl("subject_id", colnames(test_train)) | 
                grepl("activity_id", colnames(test_train)) | 
                grepl("mean", colnames(test_train)) | 
                grepl("std", colnames(test_train))   )


summary(mean_std_cols)

test_train_mean_std<-test_train[,mean_std_cols == TRUE]

## 3. Use descriptive activity names
test_train_mean_std_with_activity<-
                   merge(test_train_mean_std, 
                         activity_labels, 
                         by= 'activity_id', 
                         all.X=TRUE)

## 5. Create an independent tidy dataset  the average of each variable for each activity and each subject.
tidydataset<- aggregate(. ~ subject_id + activity, data =test_train_mean_std_with_activity, mean)
write.table(tidydataset, "TidyDataSet.txt", sep="\t", row.names=FALSE)



