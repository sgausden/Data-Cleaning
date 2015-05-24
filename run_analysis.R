# Load Packages
        
#install.packages("plyr")    
library("plyr")


    
# Get Working Directory
    
setwd("./R/Coursera Data Science/Getting and Cleaning Data")

# Get Data

path<-file.path(getwd(),"UCI HAR Dataset")

pathtest<-file.path(path, "test")
pathtrain<-file.path(path, "train")
    
xtest<-read.table(file.path(pathtest,"X_test.txt"))
ytest<-read.table(file.path(pathtest,"Y_test.txt"))

xtrain<-read.table(file.path(pathtrain,"X_train.txt"))
ytrain<-read.table(file.path(pathtrain,"Y_train.txt"))

strain<-read.table(file.path(pathtrain,"subject_train.txt"))
stest<-read.table(file.path(pathtest,"subject_test.txt"))

# Activity and Feature Labels

activitylabels<-read.table(file.path(path, "activity_labels.txt"),
    col.names = c("Id", "Activity"))

featurelabels<-read.table(file.path(path, "features.txt"),
    colClasses = c("character"))


# Merges the training and the test sets to create one data set.


trainmerge<-cbind(cbind(xtrain, strain), ytrain)
testmerge<-cbind(cbind(xtest, stest), ytest)
sensordata<-rbind(trainmerge, testmerge)

sensorlabels<-rbind(rbind(featurelabels, c(562, "Subject")), c(563, "Id"))[,2]
names(sensordata)<-sensorlabels



# Extracts only the measurements on the mean and standard deviation for each measurement. 

mean_and_std <- sensordata[,grepl("Subject|Id|mean[()]|std[()]", names(sensordata))]

# Uses descriptive activity names to name the activities in the data set

mean_and_std <- join(mean_and_std, activitylabels, by = "Id", match = "first")
mean_and_std <- mean_and_std[,-1]


# Appropriately labels the data set with descriptive names.
names(mean_and_std) <- gsub("[()]","",names(mean_and_std))
names(mean_and_std) <- make.names(names(mean_and_std))

# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject 
finaldata<-ddply(mean_and_std, c("Subject","Activity"), numcolwise(mean))


finaldataheaders<-names(finaldata)
colnames(finaldata)<-paste(finaldataheaders,"mean",sep=".")


write.table(finaldata, file = "Clean_Data.txt", row.name=FALSE)

# str(finaldata)
