#run_analysis.R

# Coursera
# Getting and Cleaning Data
# Course Project
# Completed Apr 26, 2015

# run_analysis.R performs the following:

# 1. Merge the training and test sets to create one data set
# 2. Extract only the measurments on the mean and standard deviation for each measurement
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names
# 5. From the data set in step 4, create a second, independent tidy data set with the average
#    of each variable for each activity and each subject

# 6. Upload the tidy data set created in step 5 as a txt file created with write.table()
#    using row.name=FALSE. Do not cut and paste a dataset directly into the test submission 
#    text box, as this may cause errors saving the submission.


# In tidy data:
# 1. Each variable forms a column.
# 2. Each observation forms a row.
# 3. Each type of observational unit forms a table.



#########
# START #
#########

# Remove existing objects
rm(list=ls())

# Load libraries we may use
library(dplyr)
library(tidyr)
library(data.table)

# NOTE: You must set the working directory to point to the UCI HAR Dataset folder,
#       which should contain the activity and features files, as well as the 
#       /train and /test folders and their respective data

work_dir <- "C:/Dropbox/Data Scientist Course/3 - Getting and Cleaning Data/Course Project/UCI HAR Dataset/"

#########
# START #
###########################################################
# 1 Merge the training and test sets to create one data set
###########################################################

# 1A. Merge the measurements data
X_train <- read.table(paste(work_dir,"train/X_train.txt", sep=""), header=F, sep="", stringsAsFactors=F, na.strings="NA")
X_test <- read.table(paste(work_dir, "test/X_test.txt", sep=""), header=F, sep= "", stringsAsFactors=F, na.strings="NA")

# Check the number of rows & columns
# dim(X_train)    # [1] 7352   561
# dim(X_test)     # [1] 2947   561

# Combine the two data sets
X_set <- rbind(X_train, X_test)

# dim(X_set)      # [1] 10299   561

# Get rid of the original large test data sets & free up memory
X_train <- NULL
X_test <- NULL
gc()

# Give each measurment data column a name (from features.txt)
features <- read.table(paste(work_dir, "features.txt", sep=""), header=F, sep="", stringsAsFactors=F, na.strings="NA")

# Assign the column names to X_set
colnames(X_set) <- features[,2]

# 1B. Merge the Subject data
sub_train <- read.table(paste(work_dir,"train/subject_train.txt", sep=""), header=F, sep="", stringsAsFactors=F, na.strings="NA")
sub_test <- read.table(paste(work_dir, "test/subject_test.txt", sep=""), header=F, sep= "", stringsAsFactors=F, na.strings="NA")

# Merge & change to character so factoring will work properly
subject_set <- rbind(sub_train, sub_test)

# dim(subject_set)  # [1] 10299   1

subject_set <- as.character(subject_set[,1])

# 1C. Merge the Activity data
act_train <- read.table(paste(work_dir,"train/y_train.txt", sep=""), header=F, sep="", stringsAsFactors=F, na.strings="NA")
act_test <- read.table(paste(work_dir, "test/y_test.txt", sep=""), header=F, sep= "", stringsAsFactors=F, na.strings="NA")

activity_set <- rbind(act_train, act_test)

# dim(activity_set)  # [1] 10299   1



#########################################################################################
# 2. Extract only the measurments on the mean and standard deviation for each measurement
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names
#########################################################################################

# Measurements from features_info.txt:

# tBodyAcc-XYZ
# tGravityAcc-XYZ
# tBodyAccJerk-XYZ
# tBodyGyro-XYZ
# tBodyGyroJerk-XYZ
# tBodyAccMag
# tGravityAccMag
# tBodyAccJerkMag
# tBodyGyroMag
# tBodyGyroJerkMag
# fBodyAcc-XYZ
# fBodyAccJerk-XYZ
# fBodyGyro-XYZ
# fBodyAccMag
# fBodyAccJerkMag
# fBodyGyroMag
# fBodyGyroJerkMag

# COLUMNS BY POSITION NUMBER FOR TARGET FEATURES
# From features.txt

# COL#  COLUMN NAME
# 1     tBodyAcc-mean() -X
# 2     tBodyAcc-mean() -Y
# 3     tBodyAcc-mean() -Z
# 4     tBodyAcc-std() -X
# 5     tBodyAcc-std() -Y
# 6     tBodyAcc-std() -Z

# 41    tGravityAcc-mean() -X
# 42    tGravityAcc-mean() -Y
# 43    tGravityAcc-mean() -Z
# 44    tGravityAcc-std() -X
# 45    tGravityAcc-std() -Y
# 46    tGravityAcc-std() -Z

# 81-86     tBodyAccJerk-mean() & -std() -X, -Y, -Z
# 121-126   tBodyGyro-mean() & -std() -X, -Y, -Z
# 161-166   tBodyGyroJerk-XYZ
#30

# 201, 202  tBodyAccMag
# 214, 215  tGravityAccMag
# 227, 228  tBodyAccJerkMag
# 240, 241  tBodyGyroMag
# 253, 254  tBodyGyroJerkMag
#10
# 266-271   fBodyAcc-XYZ
# 345-350   fBodyAccJerk-XYZ
# 424-429   fBodyGyro-XYZ
#18
# 503, 504  fBodyAccMag
# 516, 517  fBodyAccJerkMag
# 529, 530  fBodyGyroMag
# 542, 543  fBodyGyroJerkMag
#8
# Total: 66

# 2A. Get a data frame containing just the columns of interest, based on column #

# Note that the only measurements that should be included in the scope of this
# project are the mean() and std() - any other measurments that include 'Mean' in
# the measurement name is utilizing a Mean function in the measurement (such as
#   angle(tBodyGyroMean,gravityMean
# but are not a 'mean()' measurement in itself.

X_data <- X_set[, c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254, 266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543)]

# So there are a total of 66 in-scope measurements
# dim(X_data) # [1] 10299   66



# 2B. Add an Activity column to the measurement data set

# Load the Activity Labels
act_labels <- read.table(paste(work_dir, "activity_labels.txt", sep=""), header=F, sep= "", stringsAsFactors=F, na.strings="NA")

# Create a new act_set with the activity index numbers replaced by the activity labels
activity_set2 <- act_labels[activity_set[,1],2]

length(activity_set2)  # [1] 10299

# Merge the Activity column to the measurement set
X_data2 <- cbind(activity_set2, X_data)

# Give the Activity column a proper name
colnames(X_data2)[1] <- "Activity"



# 2C. Add a Subject # column to the measurement data set
X_data3 <- cbind(subject_set, X_data2)

# Name the column
colnames(X_data3)[1] <- "Subject"



#########################################################################################
# 5. From the data set in step 4, create a second, independent tidy data set with the
#    average of each variable for each activity and each subject
#########################################################################################

data_set <- X_data3 %>% group_by(Subject, Activity) %>% summarise_each(funs(mean))

# Arrange the data set by Subject, then Activity, in proper numeric order on Subject
data_set <- data_set[with(data_set, order(as.numeric(as.character(Subject)), Activity)), ]

# This is a tidy data set with 180 rows of 68 columns
# dim(data_set)   #[1] 180   68

# Sorted by Subject, then Activity

# head(data_set)
# Source: local data frame [6 x 68]
# Groups: Subject

#   Subject           Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# 1       1             LAYING         0.2215982      -0.040513953        -0.1132036      -0.92805647     -0.836827406
# 2       1            SITTING         0.2612376      -0.001308288        -0.1045442      -0.97722901     -0.922618642
# 3       1           STANDING         0.2789176      -0.016137590        -0.1106018      -0.99575990     -0.973190056
# ...


# Write out the data set
write.table(data_set, paste(work_dir, "tidy_data.txt", sep=""), row.name=F)

############
# FINISHED #
############