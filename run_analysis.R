#PART1
#Loading files & Preliminary Analysis
#====================================================================

# Prelimnary survey of 
filepath <- "r/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/"
#TRAIN FOLDER

# Read x_train.txt
# returns 7352 objects 561 variables
file_X_train <- paste(filepath, "train/X_train.txt", sep="")
x_train <- read.table(file_X_train)

# Read subject_train.txt
# returns 7352 objects 1 variables
file_subject_train <- paste(filepath, "train/subject_train.txt", sep="")
subject_train <- read.table(file_subject_train)

# Read y_train.txt
# returns 7352 objects 1 variables
file_y_train <- paste(filepath, "train/y_train.txt", sep="")
y_train <- read.table(file_y_train)

#TEST FOLDER

# Read X_test.txt
# returns 2947 objects with 561 variables
file_X_test <- paste(filepath, "test/X_test.txt", sep="")
x_test <- read.table(file_X_test)

# Read y_test.txt 
# returns 2947 objects with 1 variables
# Range from 1-6
# Corresponding to activity_labels
file_y_test <- paste(filepath, "test/y_test.txt", sep="")
y_test <- read.table(file_y_test)

# Read subject_test.txt
# returns 2947 objects with 1 variables
file_subject_test <- paste(filepath, "test/subject_test.txt", sep="")
subject_test <- read.table(file_subject_test)

# Read activityLlabels
# returns 6 objects with 2 variables
# types of activities
file_activity_labels <- paste(filepath, "activity_labels.txt", sep="")
activity_labels <- read.table(file_activity_labels)

# Read features
# returns 561 objects with 2 variables
# corresponding to the 561 columnes in the tables
file_features <- paste(filepath, "features.txt", sep="")
features <- read.table(file_features)

#PART 2
#3. Adding the descriptive activities as column headers
#====================================================================

## Inserting header into the x_test and x_train data.frames
# 1. Pulling features description from features data.frame
featureslist <- as.factor(features[,2])
# 2. Inserting column name into x_test data.frame
colnames(x_test) <- featureslist
colnames(x_train) <- featureslist

#adding column to x_test to mark it as test results
# 1== test
# 2= =train
x_test_add <- data.frame("TEST", x_test)
x_train_add <- data.frame("TRAIN", x_train)
# Renameing column to Data_type
names(x_test_add)[1] <- "Data_type"
names(x_train_add)[1] <- "Data_type"

#PART 3
#3. Merging Training and Test data
#====================================================================

#combining the test and train results
#contains 10299 objects of 562 variables
combined_set1 <- rbind(x_test_add, x_train_add)

#PART 4
# Subsetting dataset to include just records for means and 
# standard deviation
#====================================================================

## Extracts only the measurements on the mean and 
## standard deviation for each measuremen
## mean(): Mean value
## std(): Standard deviation

## Analysing features
## Index of features with "means" or "std" in them
## Returns 79 values
mean_std_index <- grep("mean|std", features$V2)

## Subsetting a data.set from combined_set1
## with only columens from means and standard deviation

## offsetting the column by one
# to take into account the addition of one column for data type
mean_std_index_offset <- mean_std_index +1

# Creating new data set that contains the means and standard deviation data
# Returns data.frame of 10299 rows with 80 columns
combined_set_MS <- data.frame()
# adding data type column
Data_source <- as.character(combined_set1$Data_type)
combined_set_MS <- cbind(Data_source)
#combined_set_MS <- cbind(combined_set1[,1])
# adding the 79 columns for means and standard deviation date
combined_set_MS <- cbind(combined_set_MS, combined_set1[,mean_std_index_offset])
combined_set_MS$Data_source <- NULL
# Data set is 79 columns with 10299 rows

#PART 5
# Create a second dataset with the average of the variable. 
#====================================================================

#Getting the mean for each column
mean_combined_set_MS <- colMeans(combined_set_MS)
#Creating data.frame with Parameters and average values
mean_data <- data.frame()
#converting mean_combined_set_MS as dataset 
mean_data <- as.data.frame(mean_combined_set_MS)

write.csv(mean_data, file="tidy_data.csv")

#for codebook
features_codebook <- features[mean_std_index,]
#Removing the extra column
features_codebook$V1 <- NULL
write.csv(mean_data, file="activity_list.csv")