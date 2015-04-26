# Coursera-Getting-and-Cleaning-Data
This repo contains the files for the final project for the Coursera Course: *Getting and Cleaning Data*. 

##Project Description##

This project produces averages for combinations within the data. The dataset is a series of observations: given a smartphone, thirty subjects were observed doing
one of six activities: 
- walking
- walking upstairs
- walking downstairs
- sitting
- standing
- laying

While they were doing these activities, a series of 561 measurements were made using the phone's gyroscope and accelerometer, and multiple observations
were made on each subject completing each activity. The subjects were randomly assigned to either a training set or a test set.  The full description 
of the experiment and the resulting data are available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and
the data can be found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

There are three files:
- **README.md** (this explanation text)
- **run_analysis.R** (the code for completing the assigment)
- **Codebook** (a description of the data cleaning processes and choices made, along with the variable names and descriptions included in the output file)

The assignment is as follows:
>You should create one R script called run_analysis.R that does the following. 
>1. Merges the training and the test sets to create one data set.
>2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>3. Uses descriptive activity names to name the activities in the data set
>4. Appropriately labels the data set with descriptive variable names. 
>5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Running the code##

There is only one script which contains links to all the data and should produce the output file as required. The output file also can be accessed
with the following code:

```
address <- "https://s3.amazonaws.com/coursera-uploads/user-5881afb1e588736e9e2b1e34/973500/asst-3/7ad3c140ec0f11e4ba26e317d0fc6c2b.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```
