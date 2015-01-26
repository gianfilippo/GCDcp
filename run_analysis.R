rm(list=ls())
library(data.table)
library(dplyr)

# defines source data dir
datasetDIR <- "D:/Data/UCI HAR Dataset"

# defines source test and train dirs
testsetDIR <- "test"
trainsetDIR <- "train"

# defines target merged dir and creates it if it does not exists yet
mergedsetDIR <- "merged"
if (!file.exists(paste(datasetDIR,mergedsetDIR,sep="/"))) dir.create(paste(datasetDIR,mergedsetDIR,sep="/"))

# Reads subject files from test and target dirs and output a merged subject file
print("Reading subject_test file")
fileID <- "subject_test.txt"
filTE <- scan(paste(datasetDIR,testsetDIR,fileID,sep="/"),numeric())
print("Reading subject_train file")
fileID <- "subject_train.txt"
filTR <- scan(paste(datasetDIR,trainsetDIR,fileID,sep="/"),numeric())
print("Writing merged subject file")
fileID <- "subject_merged.txt"
write.table(rbind(t(filTE),t(filTR)),file=paste(datasetDIR,mergedsetDIR,fileID,sep="/"),quote=F,col.names=F,row.names=F,sep="\t")

# Reads x files from test and target dirs and output a merged X file
fileID <- "X_test.txt"
# reads one line to find the number of columns
fil <- scan(paste(datasetDIR,testsetDIR,fileID,sep="/"),numeric(),nlines=1)
Ncols <- length(fil)
filTE <- scan(paste(datasetDIR,testsetDIR,fileID,sep="/"),rep(numeric(),length(fil)))
filTE <- t(matrix(filTE,Ncols,length(filTE)/Ncols))
fileID <- "X_train.txt"
# reads one line to find the number of columns
fil <- scan(paste(datasetDIR,trainsetDIR,fileID,sep="/"),numeric(),nlines=1)
Ncols <- length(fil)
filTR <- scan(paste(datasetDIR,trainsetDIR,fileID,sep="/"),rep(numeric(),length(fil)))
filTR <- t(matrix(filTR,Ncols,length(filTR)/Ncols))
print("Writing merged X file")
fileID <- "X_merged.txt"
write.table(rbind(filTE,filTR),file=paste(datasetDIR,mergedsetDIR,fileID,sep="/"),quote=F,col.names=F,row.names=F,sep="\t")

# Reads y files from test and target dirs and output a merged y file
print("Reading y_test file")
fileID <- "y_test.txt"
filTE <- scan(paste(datasetDIR,testsetDIR,fileID,sep="/"),numeric())
print("Reading y_train file")
fileID <- "y_train.txt"
filTR <- scan(paste(datasetDIR,trainsetDIR,fileID,sep="/"),numeric())
print("Writing merged y file")
fileID <- "y_merged.txt"
write.table(rbind(t(filTE),t(filTR)),file=paste(datasetDIR,mergedsetDIR,fileID,sep="/"),quote=F,col.names=F,row.names=F,sep="\t")

# clear main variables  
rm(fil,filTR,filTE)

# defines target Inertial Signals dir and creates it if it does not exists yet
if (!file.exists(paste(datasetDIR,mergedsetDIR,"Inertial Signals",sep="/"))) dir.create(paste(datasetDIR,mergedsetDIR,"Inertial Signals",sep="/"))

print("Merging files from test and train <Inertial Signals> directories")

# identify all files under test and train 'Inertial Signals' dirs
testfilesIS <- list.files(paste(datasetDIR,testsetDIR,"Inertial Signals",sep="/"),"txt")
trainfilesIS <- list.files(paste(datasetDIR,trainsetDIR,"Inertial Signals",sep="/"),"txt")

# loops through each matching file pairs under test and train Inertial Signals dir
# reas the maching pairs of files and output the scorresponding merged file under 
# the merged Inertial Signals dir
for (find in 1:length(testfilesIS)) {
  print(paste("Reading file",find,"of",length(testfilesIS),"from testset"))
  fileID <- testfilesIS[find]
# reads one line to find the number of columns
  fil <- scan(paste(datasetDIR,testsetDIR,"Inertial Signals",fileID,sep="/"),numeric(),nlines=1)
  Ncols <- length(fil)
  filTE <- scan(paste(datasetDIR,testsetDIR,"Inertial Signals",fileID,sep="/"),rep(numeric(),length(fil)))
  filTE <- t(matrix(filTE,Ncols,length(filTE)/Ncols))
  print(paste("Test file dim",paste(dim(filTE),collapse="x")))

  print(paste("Reading file",find,"of",length(testfilesIS),"from trainset"))
  fileID <- trainfilesIS[find]
# reads one line to find the number of columns
  fil <- scan(paste(datasetDIR,trainsetDIR,"Inertial Signals",fileID,sep="/"),numeric(),nlines=1)
  Ncols <- length(fil)
  filTR <- scan(paste(datasetDIR,trainsetDIR,"Inertial Signals",fileID,sep="/"),rep(numeric(),length(fil)))
  filTR <- t(matrix(filTR,Ncols,length(filTR)/Ncols))
  print(paste("Train file dim",paste(dim(filTR),collapse="x")))
  
  print(paste("Writing merged file",find,"of",length(testfilesIS)))
  fileID <- paste(strsplit(fileID,"_train",fixed=T)[[1]][1],"all.txt",sep="_")
  print(paste("Merged file dim",paste(dim(rbind(filTE,filTR)),collapse="x")))
  write.table(rbind(filTE,filTR),file=paste(datasetDIR,mergedsetDIR,"Inertial Signals",fileID,sep="/"),quote=F,col.names=F,row.names=F,sep="\t")
}

# clear main variables
rm(filTE,filTR,fil,Ncols,testfiles,testfilesIS,testsetDIR,trainfiles,trainfilesIS,trainsetDIR)

# loads the activity labels file
print("Loading Activity Labels file")
fileID <- "activity_labels.txt"
filAL <- read.table(paste(datasetDIR,fileID,sep="/"),header=F,sep=" ",stringsAsFactors=F)[,2]

# loads the features file
print("Loading Features file")
fileID <- "features.txt"
filFEAT <- read.table(paste(datasetDIR,fileID,sep="/"),header=F,sep=" ",stringsAsFactors=F)[,2]
# identify the column indices of the estimates of the mean and standard deviations 
indmean <- grep("mean",filFEAT)
indstd <- grep("std",filFEAT)

# load the merged subject, X and y files into a data table
fil <- fread(paste(datasetDIR,mergedsetDIR,"subject_merged.txt",sep="/"),stringsAsFactors=F,header=F)
fil <- cbind(fil,fread(paste(datasetDIR,mergedsetDIR,"y_merged.txt",sep="/"),stringsAsFactors=F,header=F))
fil <- cbind(fil,fread(paste(datasetDIR,mergedsetDIR,"X_merged.txt",sep="/"),stringsAsFactors=F,header=F))

# label data set columns with descriptive variables
setnames(fil,c("subjects","activity",eval(filFEAT)))

# extract subset of mean and standard deviation estimates
#fil <- fil[,sort(c(1,2,indmean+2,indstd+2)),with=F]
fil <- subset(fil,select=sort(c(1,2,indmean+2,indstd+2)))

# replaces activity codes with activity names
fil[["activity"]] <- filAL[fil[["activity"]]]

# create a data tabke tbl
fil <- tbl_dt(fil)

# group datga tagle tbl by subject and activity
fil <- group_by(fil,subjects,activity)

# estimate the average for each subject and each activity
fil_final <- summarise_each(fil,funs(mean))

# output fil_final to tab delimited text file '' under working dir
write.table(fil_final,file='final_tidy_dataset.txt',row.names=F,quotes=F,sep="\t")







