## -- 1 --
# reading data
test.df <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.sub.df <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test.act.df <- read.table("./UCI HAR Dataset/test/y_test.txt")

train.df <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.sub.df <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train.act.df <- read.table("./UCI HAR Dataset/train/y_train.txt")

act.lab.df <- read.table("./UCI HAR Dataset/activity_labels.txt")

# reading names of variables and changing it to factor
feat.lab <- read.table("./UCI HAR Dataset/features.txt")
feat.lab <- feat.lab[,2]


## -- 2 --
# adding new columns to train and test datasets with ids of subjects and activities
test.df$subject <- test.sub.df[,1]
test.df$activity_id <- test.act.df[,1]

train.df$subject <- train.sub.df[,1]
train.df$activity_id <- train.act.df[,1]


## -- 3 --
########## (1) ##########
# creating one dataset from test and train datasets
df1 <- rbind(test.df, train.df)
# dim(df1) # all seems ok, 10299 rows and 563 columns
#########################

## -- 4 --
########### (2) ######### 
# checking which names contain "mean"
grep("mean", feat.lab, value=TRUE, ignore.case=TRUE)
# there are 53 variables, but the last 7 (with characters "Mean" - capital M) seem to apply to angles, so they will not be extracted
# also, I'm not sure if meanFreq should be included, but it will be easier to extract it ;)

# checking which names contain "std"
grep("std", feat.lab, value=TRUE, ignore.case=TRUE)
# there are 33 such variables

# getting numbers of columns
proper.columns <- c(grep("mean", feat.lab), grep("std", feat.lab))
# length(proper.columns) # 79 = 53 - 7 + 33 seems ok

## -- 5 --
# extracting measurements on the mean and std plus subjects and activities ids
df2 <- df1[,c(proper.columns, 562, 563)]
##########################


## -- 6 --
########### (3) ########
# naming columns of act.lab.df
names(act.lab.df) <- c("activity_id", "activity")
# merging df2 and act.lab.df to name activity in each record (common column: activity_id)
df3 <- merge(df2, act.lab.df)
# head(df3) # first variable is activity_id which is not needed anymore
df3 <- df3[,-1]
#########################


## -- 7 --
########## (4) #########
# feat.lab[proper.columns]
# well, this is challenging; IMO names of the variables are descriptive
# enough, but there are some mistakes and unpleasant characters
# so I wiil just try to clean them

# grep("BodyBody", feat.lab[proper.columns], value=TRUE)
# this shows that there are names with double "Body", which is confusing

# substitute "BodyBody" with single "Body"
feat.lab1 <- sub("BodyBody", "Body", feat.lab[proper.columns])
# length(unique(feat.lab1)) # nothing was lost

# removing "()"
feat.lab1 <- sub("\\(\\)", "", feat.lab1)

# I prefer dots in names, co I'm changing "-" to dots
feat.lab1 <- make.names(feat.lab1)

## -- 8 --
# naming columns in df3
names(df3)[1:79] <- feat.lab1
# head(df3)
#########################


########## (5) ##########
library(plyr)
library(reshape2)
# changing dataset to "long" form
## -- 9 --
melt.df3 <- melt(df3, id=80:81, measure.vars=1:79)
# calculating mean of each variable for each subject and each activity
mean.df <- ddply(melt.df3, .(subject, activity, variable), summarize, mean=mean(value))
## -- 10 --
write.table(mean.df, "tidy.txt", row.name=FALSE)
#########################