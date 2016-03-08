# Load 

# path <- '/Users/harrison/Desktop/test.txt'
path <- '../Data/Ariana Grande - One Last Time/Test/Ld Voc Stem_converted_normalized.csv'
# something is wrong with this file

# data <- read.csv(path2, header = FALSE)
# test_data <- read.csv(path, header = FALSE)

# test with small number of lines
numLines <- 3

rawdata <- readLines(path, n=numLines) # remove n=numLines to load all
numLines <- length(rawdata)
allvars <- c()

for (i in 1:numLines) {
  currentline <- rawdata[i]
  currentline_split <- strsplit(currentline,",")[[1]]
  varname <- currentline_split[1]
  # TODO: trim leading whitespace and/or check if legal name
  values <- as.numeric(currentline_split[2:length(currentline_split)])
  # TODO: verify that this works
  assign(varname,values)
  allvars <- c(allvars,varname)
}  

