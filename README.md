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
- **Codebook** (variable names and descriptions included in the output file)

The assignment is as follows:
>You should create one R script called run_analysis.R that does the following. 
>1. Merges the training and the test sets to create one data set.
>2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>3. Uses descriptive activity names to name the activities in the data set
>4. Appropriately labels the data set with descriptive variable names. 
>5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Running the code##

There is only one script which contains links to all the data and should produce the output file as required. The code utilizes three packages: **plyr**, **dplyr**, and **reshape**. The libraries will be called in the script. Please note that, according to the developer, reshape makes dplyr functions unstable, reshape is only added at the end of the script after all dplyr commands have been completed. 

The output file also can be accessed with the following code:

```
address <- "https://s3.amazonaws.com/coursera-uploads/user-5881afb1e588736e9e2b1e34/973500/asst-3/7ad3c140ec0f11e4ba26e317d0fc6c2b.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```
###File description and choices made###
The script creates the nececssary directories for the file file handling. It pulls and extracts the data from the website.
It imports **features.text**, the file that contains all of the variable names.

It then reads the following training set files:
- **X_train.txt** (the file that contains the data for the training set)
- **Y_train.txt** (the file that contains the activities for the training set)
- **subject_train.txt** (the file that contains all of the subjects for the training set)

The activities and subject files are appended as columns to the beginning of the training data.

It then reads the following test set files:
- **X_test.txt** (the file that contains the data for the test set)
- **Y_test.txt** (the file that contains the activities for the test set)
- **subject_test.txt** (the file that contains all of the subjects for the test set)

The activities and subject files are appended as columns to the beginning of the test data.

#### PROJECT REQUIREMENT 1: "Merges the training and the teset sets to create one data set." ####
Once the test and training data sets are completed and are confirmed to have identical numbers of columns, the test data are appended to the training data to form a complete data set. 

#### PROJECT REQUIREMENT 2: "Extracts only the measurements on the mean and standard deviation for each measurement. " ####
This section of the code extracts out only the fields that include measurements for mean and standard deviation. This required a choice to be made, since some of the fields are manipuations on means, but not actually means. These did not seem to be part of the course assignment, as these are not, in fact, measurements of means. Therefore, the following features were excluded from the dataset: *angle(tBodyAccMean,gravity)*, *angle(tBodyAccJerkMean),gravityMean)*, *angle(tBodyGyroMean,gravityMean)*, *angle(tBodyGyroJerkMean,gravityMean)*, *angle(X,gravityMean)*, *angle(Y,gravityMean)*, and *angle(Z,gravityMean)*.

The script first extracts the features from the table, then matches the appropriate columns in the file.  It then renames the subject and activity columns.

#### PROJECT REQUIREMENT 3: "Uses descriptive activity names to name the activities in the data set. " ####

This section of the script reads the **activity_labels.txt** file and renames the activity field, which contains numbers indicating the activities completed, and assigns the appropriate activity name to that record. It then removes the activity number column, and renames the activity_name column as "activity."

#### PROJECT REQUIREMENT 4: "Appropriately labels the data set with descriptive variable names. " ####

This section creates long, but descriptive names of each feature, that includes the descriptions of the features from [the experiment description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). After completing a few of the transformations, it became apparent that creating a function would have simplified this section. But it works, turning column names from unhelpful ones such as "V101" into perspicuous ones clear to the outside world, like "StandardDeviationOfTheBodyAccelerationJerkMagnitudeTimeDomainSignalInTheXDirection". This renders the codebook redundant, but it is included anyway.

#### PROJECT REQUIREMENT 5: "From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. "  ####

Following Hardley Wickham's *[Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf)*, I chose to melt the 81 column "wide" data set into a "narrow" data set, adding each of the features as a column. I then grouped the data by activity, subject, and feature (named "variable"), to summarize and produce for each. [This is the result](https://s3.amazonaws.com/coursera-uploads/user-5881afb1e588736e9e2b1e34/973500/asst-3/7ad3c140ec0f11e4ba26e317d0fc6c2b.txt).


