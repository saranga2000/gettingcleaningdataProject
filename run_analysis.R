#  Data for project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1. Merges the training and the test sets to create one data set.
setwd("C:/UserFileSystem/personal/GDrive/learn/certifications/datasciencesCoursera/3-gettingcleaningdata/project")
getwd()
# download project data file if not exists and  unzip it
if (!file.exists("uciHarDataset.zip")) {
      print("Need to download and unzip the 2")
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, destfile = "uciHarDataset.zip")
      
      #unzip
      unzip("uciHarDataset.zip", overwrite=T)
      print("Done, you should files in the working directory")
}

# set working directory to the unzipped folder with files
setwd("./UCI HAR Dataset")
# list the unzipped files
files <- list.files(".", recursive = TRUE)
print(files)


# read list of features and activity types 
features <- read.table('./features.txt',header=FALSE)
activityType <- read.table('./activity_labels.txt',header=FALSE)
colnames(activityType)  = c('activityId','activityType')

# read in training data ( we will not use anything under Interial signals under specific accelerometers, but only all up)
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain <- read.table('./train/x_train.txt',header=FALSE)
yTrain <- read.table('./train/y_train.txt',header=FALSE)

# assign column names to imported data
colnames(subjectTrain)  = "subjectId"
colnames(xTrain)        = features[,2] 
colnames(yTrain)        = "activityId"

# merge subjectTrain, xTrain, yTrain to create single trainingSet
trainingSet = cbind(subjectTrain,xTrain,yTrain)

# do same steps above for test data 
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest <- read.table('./test/x_test.txt',header=FALSE)
yTest <- read.table('./test/y_test.txt',header=FALSE)

# Assign column names to the test data imported above
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[,2] 
colnames(yTest) <- "activityId"


# merge subjectTest, xTest, yTest to create single testSet
testSet <- cbind(xTest,yTest,subjectTest)


# merge training and test sets to create a combinedSet
combinedSet <- rbind(trainingSet,testSet)
#print(head(combinedSet, n=2))

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
combinedSetMeanStdDev <- combinedSet[,grepl("mean|std|subject|activity", names(combinedSet))]
#print(names(combinedSetMeanStdDev))
#print(names(activityType))

# 3. Use descriptive activity names to name the activities in the data set
combinedSetMeanStdDev <- merge(combinedSetMeanStdDev, activityType, by="activityId", all.x=TRUE)
#print(names(combinedSetMeanStdDev))

# 4. Appropriately label the data set with descriptive activity names
names(combinedSetMeanStdDev) <- gsub("\\()","",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("-std$","StdDev",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("-mean","Mean",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("^(t)","time",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("^(f)","freq",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("([Gg]ravity)","Gravity",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("[Gg]yro","Gyro",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("AccMag","AccMagnitude",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("JerkMag","JerkMagnitude",names(combinedSetMeanStdDev))
names(combinedSetMeanStdDev) <- gsub("GyroMag","GyroMagnitude",names(combinedSetMeanStdDev))


# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
tidySetActivityMeanSubForEachActivity = ddply(combinedSetMeanStdDev, c("subjectId","activityId"), numcolwise(mean))
write.table(combinedSetActivityMeanSubForEachActivity, file = "tidySetActivityMeanSubForEachActivity.txt", row.name=FALSE)
