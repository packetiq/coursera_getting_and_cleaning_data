# coursera_getting_and_cleaning_data
Course Project files for Coursera Getting and Cleaning Data online course.

## Introduction

This repository contains my files for the Course Project for the Coursera "Getting and Cleaning Data" course.

One of the most exciting areas in all of data science right now is wearable computing. 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
The data used for this project represents data collected from accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Data Sources

The data source for this project is:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Course Project Instructions

The Course Project called for creating one R script called 

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Prerequisites for the run_analysis.R script

The prerequisites for running this copy of run_analysis.R include:

	1. The UCI HAR Dataset must be extracted to a directory
	2. The working directory variable (work_dir) in run_analysis.R must be edited to point to the UCI HAR Dataset folder, which in turn should contain the extracted activity and features files, as well as the /train and /test folders and their respective data.
	
	For example, on my machine 'work_dir' is set as:
	work_dir <- "C:/Dropbox/Data Scientist Course/3 - Getting and Cleaning Data/Course Project/UCI HAR Dataset/"
	
## Output from the R script
	
The output of run_analysis.R is a tidy data file containing the means of all of the columns by test subject, and by activity.

The output was written to a space delimited file called tidy_data.txt included in this repository along with the run_analysis.R script file, this README.md file, and a CodeBook.md file containing information about the contents of the tidy data file.

Here is an example of the first several rows and columns of the tidy_data.txt file:

Subject           Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
1       1             LAYING         0.2215982      -0.040513953        -0.1132036      -0.92805647     -0.836827406
2       1            SITTING         0.2612376      -0.001308288        -0.1045442      -0.97722901     -0.922618642
3       1           STANDING         0.2789176      -0.016137590        -0.1106018      -0.99575990     -0.973190056
...

END