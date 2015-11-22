rm(list=ls())


library(plyr)

# 1
#How to merge training and test dataset
###############################################################################

x_tr <- read.table("train/X_train.txt")
y_tr <- read.table("train/y_train.txt")
subject_tr <- read.table("train/subject_train.txt")

x_ts <- read.table("test/X_test.txt")
y_ts <- read.table("test/y_test.txt")
subject_ts <- read.table("test/subject_test.txt")


# create a new data set 'X"
x_dat <- rbind(x_tr, x_ts)

# create a new data set 'y'
y_dat <- rbind(y_tr, y_ts)

# create a new dataset 'subject_dat' 
subject_dat <- rbind(subject_tr, subject_ts)

# 2
#mean and standard deviation for each measurement
###############################################################################

features <- read.table("features.txt")

# how to retrieve  columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# how to subset  columns
x_dat <- x_dat[, mean_and_std_features]

# give column names
names(x_dat) <- features[mean_and_std_features, 2]

#  3
# How to name the activities in the data set
###############################################################################

activities <- read.table("activity_labels.txt")

# How to correct activity names
y_dat[, 1] <- activities[y_dat[, 1], 2]

# New column name
names(y_dat) <- "activity"

# 4
# Descriptive variable names
###############################################################################

# New column name
names(subject_dat) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_dat, y_dat, subject_dat)

# 5
# New data set with avearage of each variable

###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)

