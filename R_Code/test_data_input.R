# Load 
path <- '/Users/harrison/Desktop/test.txt'
path2 <- '/Users/harrison/Desktop/Thesis_Test/Ariana Grande - One Last Time/Test/Ld Voc Stem_converted_normalized.csv'

data <- read.csv(path2, header = FALSE)

test_data <- read.csv(path, header = FALSE)

data_3 <- readLines(path2, n=3)
allvars <- c()
for (i in 1:3) {
  line2 <- data_3[i]
  line2split <- strsplit(line2,",")[[1]]
  varname <- line2split[1]
  # trim leading whitespace and/or check if legal name
  values <- as.numeric(line2split[2:length(line2split)])
  assign(varname,values)
  allvars <- c(allvars,varname)
}  
# convert the results of readLines into two variable vectors named "row1" and "row2" or whatever the first element of the row actually is.

