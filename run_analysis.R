ProjectDirectory = getwd()
DataDirectory = "UCI HAR Dataset/"
if (!file.exists(DataDirectory)) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                "data.zip", "curl", quiet = TRUE, mode = "wb")
  unzip("data.zip")
  file.remove("data.zip")
}
stopifnot(file.exists(DataDirectory))
setwd(DataDirectory)

library(data.table)

# Merges the training and the test sets to create one data set.
subjectTrain  <- read.table("train/subject_train.txt")
subjectTest <- read.table("test/subject_test.txt")
subject  <- rbind(subjectTrain, subjectTest)

featuresTrain  <- read.table("train/X_train.txt")
featuresTest <- read.table("test/X_test.txt")
features  <- rbind(featuresTrain, featuresTest)

activityTrain  <- read.table("train/y_train.txt")
activityTest <- read.table("test/y_test.txt")
activity  <- rbind(activityTrain, activityTest)

featureNames <- read.table("features.txt")
activityLabels  <- read.table("activity_labels.txt", header = FALSE)

colnames(features) <- t(featureNames[2])

colnames(activity) <- "Activity"
colnames(subject) <- "Subject"

allData <- cbind(features, activity, subject)

# Extracts only the measurements on the mean and standard deviation for each measurement.
onlyMeanSTD <- grep(".*Mean.*|.*Std.*", names(allData), ignore.case=TRUE)

requiredColumns <- c(onlyMeanSTD, 562, 563)
data <- allData[,requiredColumns]

data$Activity <- as.character(data$Activity)
for (i in 1:6){
  data$Activity[data$Activity == i] <- as.character(activityLabels[i,2])
}
data$Activity <- as.factor(data$Activity)

# Appropriately labels the data set with descriptive variable names
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("tBody", "TimeBody", names(data))
names(data)<-gsub("-mean()", "Mean", names(data), ignore.case = TRUE)
names(data)<-gsub("-std()", "STD", names(data), ignore.case = TRUE)
names(data)<-gsub("-freq()", "Frequency", names(data), ignore.case = TRUE)
names(data)<-gsub("angle", "Angle", names(data))
names(data)<-gsub("gravity", "Gravity", names(data))

# From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject
setwd("../")
data$Subject <- as.factor(data$Subject)
data <- data.table(data)

tidyData <- aggregate(. ~Subject + Activity, data, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidy_dataset.txt", row.names = FALSE)
