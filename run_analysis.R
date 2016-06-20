MergeDataRow <- function( file1, file2, target )
{
  dat1 <- read.csv(file1, sep= "")
  dat2 <- read.csv(file2, sep= "")
  
  ##match column names so they bind
  ## This assumes we are adding equivalent tables
  names(dat1) <- names(dat2)
  
  ## return data frame
  target <- rbind(dat1, dat2)
}



AmalgamateDataSets <- function(fulldataset)
{
  
  
  df1 <- MergeDataRow(".\\submission\\test\\subject_test.txt",
               ".\\submission\\train\\subject_train.txt",
               df1)
  
  df2 <- MergeDataRow(".\\submission\\test\\y_test.txt",
               ".\\submission\\train\\y_train.txt",
               df2)
  
  df3 <- MergeDataRow(".\\submission\\test\\X_test.txt",
                      ".\\submission\\train\\X_train.txt",
                      df3)  
  


  
  fulldataset <- cbind.data.frame(df1,df2,df3)

}

NameColumns <- function(ds)
{
  
  cols = read.csv(".\\submission\\features.txt", sep="", header= FALSE)
  
  vec <- as.vector(cols[,2])
  
  names(ds) <- c("Subject","Activity", vec)
}

NameActivity <- function(ds)
{
  ## Move values to strings
  activities <- read.csv(".\\submission\\activity_labels.txt", sep="", header= FALSE)
  
  for (i in 1:length(ds$Activity)) {
    
    val = ds$Activity[i]
    ds$Activity[i] <- as.character(activities$V2[as.integer(val)])
  }
  ds
  
  
  
}



mainfunc <- function()
{
  ds <- AmalgamateDataSets(ds)
  
  cols <- NameColumns(ds)

  ## Strip off just mean and std
  mstd <-   grepl("\\bSubject\\b|\\bActivity\\b|\\b-mean()\\b|\\b-std()\\b", cols)
  ds <- ds[mstd]
  names(ds) <- cols[mstd]
  
  

  
  ## collapse down means to one value /subject/activity
  averageMean <- ds
  
  ## Mean and STD
  
  ## I'm sure there is a looping function for this but I don't have time to reaserch it
  maxSubject = max(ds$Subject)
  maxActvity = max(ds$Activity)

  ## Create matrix Num subjects * Num Activities with all readings = 30 * 6 = 180 rows
  colnames <- names(ds)
  meansSubjectActivity <- matrix(NA, nrow = maxSubject*maxActvity, ncol = length(colnames))


  subject = 1
  actvity = 1
  row = 1

  ##Each subject
  for (subject in 1:maxSubject) {
    subjectparse = ds[ds$Subject == subject,]
    ## Each activity
    for (activity in 1:maxActvity) {
      activityparse = subjectparse[subjectparse$Activity == activity,]
      ## Each measurement
      for(xmeasure in 3:length(colnames)){

            measureparse = activityparse[,xmeasure]

            meansSubjectActivity[row, 1] = subject
            meansSubjectActivity[row, 2] = activity
            meansSubjectActivity[row, xmeasure] = mean(measureparse)
      }
      row <- row +1
    }
  }

  ## Alter Activity
  ds <- NameActivity(ds)  
  meansSubjectActivity <- data.frame(meansSubjectActivity)
  names(meansSubjectActivity) <- names(ds)
  
  meansSubjectActivity <- NameActivity(meansSubjectActivity)
  
  write.table(meansSubjectActivity, file = "wearables.txt", row.names = FALSE)
  
}


