# Getting-and-cleaning-data
Final week of Getting-and-cleaning-data Coursera course

MergeDataRow just adds 2 sets of data together by rows. i.e. appends rows.
Only useful if we knwo the data is identical in structure


AmalgamateDataSets Takes Train and Test directories and merges them together for subject, activity and measurements

NameColumns Names measurements

NameActivity Replaces activity numbers with names




mainfunc

1) Joins data sets
2) Renames Columns for subject, activity and measurements
3) Strip out just mean() and std() columns
4) Creates a matrix of Subject*Activity = 30 *6 = 180 row data frames with all mean and std columns
5) For each column that are common for subject and actvity we get the average (mean)
6) Create output file

