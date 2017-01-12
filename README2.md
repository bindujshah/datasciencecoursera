Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

DATA

The data for this assignment was downloaded from the course web site:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

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


the run_analysis.R script downloads the zipped data set and unzips the files.
Then files listed above are read.

For both the Test and Train data sets, 
Column headers are added to the metrics files.
Subject ID and Activity ID is associated with each metric record 
Activity labels are added 

the Test and Train data sets are combined. NOTE that an addiitonal column called "source" is added to identify whether the metric record came from the TEST or TRAIN data set

A subsetis created with Only MEAN and STD metrics along with Subject ID and Activity ID are preserved.

Activity labels are added to this data set

A new data set is created with the average MEAN and STD metrics
This data set is then written to a file called "TidyDataSet.txt" so it can be used independently.











