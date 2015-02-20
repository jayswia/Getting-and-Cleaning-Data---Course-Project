setwd("C:/R-Coursera/GACD_courseproject")

#Read in and create a test data table
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

c_test <- cbind(y_test, s_test, x_test)
rm(x_test,y_test,s_test)

#Read in and create a train data table
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
s_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

c_train <- cbind(y_train, s_train, x_train)
rm(x_train,y_train,s_train)

#Merges the training and the test sets to create one data set.
c_complete <- rbind(c_train, c_test)
rm(c_test,c_train)

#create a activity table with descriptions
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(act_labels) <- c("ActivityID","ActivityDesc")

#Appropriately labels the data set with descriptive variable names
col_names <- read.table("./UCI HAR Dataset/features.txt")
col_names1 <- as.vector(col_names[,2])
col_names2 <- c("Activity","Subject", col_names1)
rm(col_names,col_names1)
colnames(c_complete) <- col_names2

#Uses descriptive activity names to name the activities in the data set
ca_complete <- merge(act_labels,c_complete, by.x="ActivityID", by.y="Activity", all=TRUE)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
i <- grep(".*mean\\(\\)|.*std\\(\\)", names(ca_complete))
subset_data <- ca_complete[,c(1:3,i)]

#Create an independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
vars <- colnames(subset_data[,4:69])
melted_data <- melt(subset_data, id=c("ActivityDesc", "Subject"),measure.vars=vars)
tidy_data   <- dcast(melted_data, Subject + ActivityDesc ~ variable, mean)
write.table(tidy_data,"Tidy_data.txt", row.name=FALSE)

