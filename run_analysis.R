## Script associated with Coursera Getting and Cleaning Data.
library(plyr)
library(dplyr)
## Pre-project step (a): downloading and extracting the data.

if(!file.exists("./data")){dir.create("./data")}
if(!file.exists("./data/cleaning_project")){dir.create("./data/cleaning_project")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/cleaning_project/wearables.zip")
unzip("./data/cleaning_project/wearables.zip", overwrite = TRUE, exdir="./data/cleaning_project")

## Pre-project step (b): Bring in the varible names and associate them vith data set columns
## This is so the column numbers automatically assigned by read.table() match to the column numbers listed in features.txt file.
var_names <- read.table("./data/cleaning_project/UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)
var_names <- rename(var_names, field = V1)
var_names <- rename(var_names, name = V2)
var_names <- mutate(var_names, set_col = paste("V", as.character(field), sep=''))


## Pre-project step (c): Bring in the training data

training_data <- read.table("./data/cleaning_project/UCI HAR Dataset/train/X_train.txt", header = FALSE,  stringsAsFactors = FALSE)
training_acts <- read.table("./data/cleaning_project/UCI HAR Dataset/train/Y_train.txt", header = FALSE,  stringsAsFactors = FALSE)
training_acts <- rename(training_acts, activity = V1)
training_set <- cbind(training_acts, training_data)
training_subjects <- read.table("./data/cleaning_project/UCI HAR Dataset/train/subject_train.txt", header = FALSE,  stringsAsFactors = FALSE)
training_subjects <- rename(training_subjects, subject = V1)
training_set <- cbind(training_subjects, training_set)

## Pre-project step (d): Bring in the test data
test_data <- read.table("./data/cleaning_project/UCI HAR Dataset/test/X_test.txt", header = FALSE,  stringsAsFactors = FALSE)
test_acts <- read.table("./data/cleaning_project/UCI HAR Dataset/test/Y_test.txt", header = FALSE,  stringsAsFactors = FALSE)
test_acts <- rename(test_acts, activity = V1)
test_set <- cbind(test_acts, test_data)
test_subjects <- read.table("./data/cleaning_project/UCI HAR Dataset/test/subject_test.txt", header = FALSE,  stringsAsFactors = FALSE)
test_subjects <- rename(test_subjects, subject = V1)
test_set <- cbind(test_subjects, test_set)



## ### PROJECT REQUIREMENT 1: "Merges the training and the teset sets to create one data set."



full_set <- rbind(training_set, test_set)
full_size <- dim(full_set)[1]
full_cols <- dim(full_set)[2]



## ### PROJECT REQUIREMENT 2: "Extracts only the measurements on the mean and standard deviation for each measurement. "



## This first requires selecting out those columns in the features.text file. I'm doing this by greping on "mean" or "std"
## in the second column of the text file.

subset_vars <- var_names[grepl("std",var_names$name)== TRUE |grepl("mean", var_names$name),] 
use_cols <- subset_vars$set_col
subset_set <- data.frame(matrix(ncol = 0, nrow = full_size))
subset_set <- cbind(subset_set, full_set$subject)
subset_set <- cbind(subset_set, full_set$activity)

### Now that there's a subset of the features.txt table with ONLY the std/mean rows, this matches the corresponding column
### numbers with the combined test/training set, and then adds the matching columns to the subset.

i = 1
while (i <= full_cols){
  current <- colnames(full_set)[i]
  if(is.element(current, use_cols)) {
    subset_set <- cbind(subset_set, full_set[,i])
    sub_cols <- dim(subset_set)[2]
    colnames(subset_set)[sub_cols] <- current

  }
  i <- i + 1
}

colnames(subset_set)[1]= "subject"
colnames(subset_set)[2]= "activity"



## ### PROJECT REQUIREMENT 3: "Uses descriptive activity names to name the activities in the data set. "


activity_labels <- read.table("./data/cleaning_project/UCI HAR Dataset/activity_labels.txt", header = FALSE, stringsAsFactors = FALSE)
activity_labels <- rename(activity_labels, activity = V1)
activity_labels <- rename(activity_labels, activity_name = V2)

## By setting the name for the activity number field in the activity labels column the as the same as the field for the the activity number in the subset table,
## merge will automatically merge the proper fields for every row for the corresponding activity number.

subset_set <- merge(activity_labels, subset_set)

## And, to clean up, this removes the now extraneous activity number field, and then renames activity_name to the more compact and perspicuous "activity".
subset_set$activity <- NULL
subset_set <- rename(subset_set, activity = activity_name)



## ### PROJECT REQUIREMENT 4: "Appropriately labels the data set with descriptive variable names. "



## While shorter column names create nice looking tables, to be as descriptive as possible for this exercise, these will be particularly long and 
## ideally very perspicuous variable names.

subset_vars[,4] <- NA
subset_vars <- rename(subset_vars, long_name = V4)

## This starts the long name, indicating we're using the mean or the standard deviation.  This could have been redone in a cleaner fashion by creating a function.

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  if (grepl("std",subset_vars[i,2])){
    subset_vars[i,4] <- "StandardDeviationOf"
  }
  else {
    subset_vars[i,4] <-"MeanOf"
  }
i = i + 1
}



## Is this a body signal or a gravity signal?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){

  if (grepl("Body",subset_vars[i,2])) {
    subset_vars[i,4] <- paste(subset_vars[i,4], "TheBody", sep = "")
  }
  else {
    subset_vars[i,4] <- paste(subset_vars[i,4], "TheGravity", sep = "")
  }
  i = i + 1
}

  ## Is this a gyroscope measure or no?
  i = 1
  counts <- nrow(subset_vars)
  while (i <= counts){
    
    if (grepl("Gyro",subset_vars[i,2])) {
      subset_vars[i,4] <- paste(subset_vars[i,4], "Gyroscope",  sep = "")
    }
    
    i = i + 1  
  
  } 

## Is this a acceleration measure or no?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Acc",subset_vars[i,2])) {
    subset_vars[i,4] <- paste(subset_vars[i,4], "Acceleration", sep = "")
  }
  
  i = i + 1  
  
} 

## Is this a jerk measure or no?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Jerk",subset_vars[i,2])) {
    subset_vars[i,4] <- paste(subset_vars[i,4], "Jerk", sep = "")
  }
  
  i = i + 1  
  
} 

## Is this a magnitude measure or no?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Mag",subset_vars[i,2])) {
    subset_vars[i,4] <- paste(subset_vars[i,4], "Magnitude", sep = "")
  }
  
  i = i + 1  
  
} 


## Is this a time domain signal or a frequency domain signal?

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  first <- substr(subset_vars[i,2],1,1)
  if(first == 't') {
    subset_vars[i,4] <- paste(subset_vars[i,4], "Time", sep = "")
  }
  else {
    subset_vars[i,4] <- paste(subset_vars[i,4], "Frequency", sep = "")
  }
  i = i + 1
}
### Everything's a signal

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
    subset_vars[i,4] <- paste(subset_vars[i,4], "DomainSignal", sep = "")
    i = i + 1 
}
   
## And, finally the direction

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  last <- substr(subset_vars[i,2],nchar(subset_vars[i,2]),nchar(subset_vars[i,2]))
  if(last == 'X') {
    subset_vars[i,4] <- paste(subset_vars[i,4], "InTheXDirection", sep = "")
  }
  else {
    if(last == 'Y') {
      subset_vars[i,4] <- paste(subset_vars[i,4], "InTheYDirection", sep = "")
    }
    else {
      if(last == 'Z') {
        subset_vars[i,4] <- paste(subset_vars[i,4], "InTheZDirection", sep = "")
      }
  }
  
  }
  
  i = i + 1
}

### Now add this as the variable names in the subset_set. 
subset_cols <- ncol(subset_set)
features <- nrow(subset_vars)
i = 2
while (i <= subset_cols){
  current <- colnames(subset_set)[i]
  j = 1
  while(j <= features) {
    if (current == subset_vars[j,3]){
      colnames(subset_set)[i] <- subset_vars[j,4] 
    }
  j = j+1
  }
  
  i <- i + 1
}

## This section is not necessary for the assignment, but it generates the code book data from above. 

long_name <- as.character(1:79)
description <- as.character(1:79)
codebook <- data.frame(long_name, description, stringsAsFactors = FALSE)


## This starts the long name, indicating we're using the mean or the standard deviation.  This could have been redone in a cleaner fashion by creating a function.

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  if (grepl("std",subset_vars[i,2])){
    codebook[i,1] <- "StandardDeviationOf"
    codebook[i,2] <- "Standard deviation of"
  }
  else {
    codebook[i,1] <-"MeanOf"
    codebook[i,2] <-"Mean of"
  }
  i = i + 1
}



## Is this a body signal or a gravity signal?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Body",subset_vars[i,2])) {
    codebook[i,1] <- paste(codebook[i,1], "TheBody", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "the body")
  }
  else {
    codebook[i,1] <- paste(codebook[i,1], "TheGravity", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "the gravity")
  }
  i = i + 1
}

## Is this a gyroscope measure or no?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Gyro",subset_vars[i,2])) {
    codebook[i,1] <- paste(codebook[i,1], "Gyroscope",  sep = "")
    codebook[i,2] <- paste(codebook[i,2], "gyroscope")
  }
  
  i = i + 1  
  
} 

## Is this a acceleration measure or no?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Acc",subset_vars[i,2])) {
    codebook[i,1] <- paste(codebook[i,1], "Acceleration", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "acceleration")
  }
  
  i = i + 1  
  
} 

## Is this a jerk measure or no?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Jerk",subset_vars[i,2])) {
    codebook[i,1] <- paste(codebook[i,1], "Jerk", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "jerk")
  }
  
  i = i + 1  
  
} 

## Is this a magnitude measure or no?
i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  
  if (grepl("Mag",subset_vars[i,2])) {
    codebook[i,1] <- paste(codebook[i,1], "Magnitude", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "magnitude")  
  }
  
  i = i + 1  
  
} 


## Is this a time domain signal or a frequency domain signal?

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  first <- substr(subset_vars[i,2],1,1)
  if(first == 't') {
    codebook[i,1] <- paste(codebook[i,1], "Time", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "Time")  
  }
  else {
    codebook[i,1] <- paste(codebook[i,1], "Frequency", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "frequency")
  }
  i = i + 1
}
### Everything's a signal

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  codebook[i,1] <- paste(codebook[i,1], "DomainSignal", sep = "")
  codebook[i,2] <- paste(codebook[i,2], "domain signal")
  i = i + 1 
}

## And, finally the direction

i = 1
counts <- nrow(subset_vars)
while (i <= counts){
  last <- substr(subset_vars[i,2],nchar(subset_vars[i,2]),nchar(subset_vars[i,2]))
  if(last == 'X') {
    codebook[i,1] <- paste(codebook[i,1], "InTheXDirection", sep = "")
    codebook[i,2] <- paste(codebook[i,2], "in the X direction")
  }
  else {
    if(last == 'Y') {
      codebook[i,1] <- paste(codebook[i,1], "InTheYDirection", sep = "")
      codebook[i,2] <- paste(codebook[i,2], "in the Y direction")	  
    }
    else {
      if(last == 'Z') {
        codebook[i,1] <- paste(codebook[i,1], "InTheZDirection", sep = "")
        codebook[i,2] <- paste(codebook[i,2], "in the Z direction")
      }
    }
    
  }
  
  i = i + 1
}

write.table(final_set, file = "./data/cleaning_project/CodebookData.txt", row.name=FALSE)

## ### PROJECT REQUIREMENT 5:
##"From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. "

#first, melt the table into a tidy set, then group and summarise.
library(reshape)

all_features <- c(colnames(subset_set)[3:length(colnames(subset_set))])

subset_melt <- melt(subset_set, id.vars = c("activity", "subject"), measure.vars = all_features)


by_act_sub <- group_by(subset_melt, activity, subject, variable)
final_set <- summarise(by_act_sub, MeanOfObservations = mean(value, na.rm = TRUE))

write.table(final_set, file = "./data/cleaning_project/MeansOfObservationsforSelectedFeaturesOfSignalsFromASmartphoneDuringActivities.txt", row.name=FALSE)
