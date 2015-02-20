---
title: "ReadMe"
output: html_document
---
This is an overview of the course project data, variables and functions for the Getting an Cleaning Data Course Project

setwd("C:/R-Coursera/GACD_courseproject")
<H1>Varables</H1>
<H2>Data Frames</H2>
x_test <- X_test.txt Data File
y_test <- y_test.txt Data File
s_test <- subject_test.txt Data File
c_test <- Combining - y_test, s_test, x_test
x_train <- X_train.txt Data File
y_train <- y_train.txt Data File
s_train <- subject_train.txt Data File
c_train <- Combining - y_train, s_train, x_train 
c_complete <- Merge to get a complete dataset
act_labels <- activity_labels.txt Data File

<H1>Transformations</H1>
<H2>Rename Col Names</H2>
```{r}
colnames(act_labels) <- c("ActivityID","ActivityDesc")
```
<H2>Appropriately labels the data set with descriptive variable names</H2>
```{r}
col_names <- read.table("./UCI HAR Dataset/features.txt")
col_names1 <- as.vector(col_names[,2])
col_names2 <- c("Activity","Subject", col_names1)
rm(col_names,col_names1)
colnames(c_complete) <- col_names2
```
<H2>Uses descriptive activity names to name the activities in the data set</H2>
```{r}
ca_complete <- merge(act_labels,c_complete, by.x="ActivityID", by.y="Activity", all=TRUE)
```
<H2>Extracts only the measurements on the mean and standard deviation for each measurement</H2> 
```{r}
i <- grep(".*mean\\(\\)|.*std\\(\\)", names(ca_complete))
subset_data <- ca_complete[,c(1:3,i)]
```

<H2>Create an independent tidy data set with the average of each variable for each activity and each subject</H2>
```{r}
library(reshape2)
vars <- colnames(subset_data[,4:69])
melted_data <- melt(subset_data, id=c("ActivityDesc", "Subject"),measure.vars=vars)
tidy_data   <- dcast(melted_data, Subject + ActivityDesc ~ variable, mean)
write.table(tidy_data,"Tidy_data.txt", row.name=FALSE)
```
