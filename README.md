#  Getting and Cleaning Data course project

The script performs the following operations on the 'UCI HAR Dataset' data set available from the 'Getting and Cleaning Data' course project:  
1. Creates a directory 'merged' under the main data/working directory 'UCI HAR Dataset' if not already present  
2. Merges each files from 'training' and 'test' sets to create the corresponding 'merged' file.  
3. Saves the 'merged' file under the 'merged' directory/subdirectory to mirror the directory structure and file naming convention of the original files  
4. Loads the 'merged' files into a single data.table  
5. Extracts from the 'merged' data.table only the measurements on the mean and standard deviation for each measurement.  
6. Replaces the original activity codes in the 'merged' data.table with the corresponding descriptive activity names  
7. Labels the 'merged' data.table with descriptive variable names.   
8. Creates a second, tidy data.table with the average of each variable for each activity and each subject.  
9. Output the result to a text file (tab delimited) 'final_tidy.txt' under the working directory ('UCI HAR Dataset').  

**_USAGE_**:  
source("run_analysis.R")  

**NOTE**: the script assumes the following:  
1. the user downloaded and extracted the 'Getting and Cleaning Data' course project zipped archive  
2. the working directory is the 'UCI HAR Dataset' directory  
3. the user has installed the package 'data.table' and 'dplyr'  

