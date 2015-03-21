# Readme for run_analysis.R script
run_analysis.R creates a tidy dataset based on the instructions for the project, specifically

1. checks for and if not there downloads the source dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. unzips the downloaded source zip file
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
6. writes this independent tidydata set into a file named "tidySetActivityMeanSubForEachActivity.txt" in the current working directory. This file was uploaded as part of the project submission.

Please look at Codebook.md for description of the variables.