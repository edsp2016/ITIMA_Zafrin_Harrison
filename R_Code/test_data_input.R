<<<<<<< HEAD
# Define Functions
create_labeled_matrix <- function(feature_names, feature_values) {
  if (FALSE){
    "This function is used to create a labelled matrix
    of equal dimension out of the CSV data.  This matrix
    represents one stem, which will be loaded into a list
    of stems to analyze a whole song at once.
    
    Params
    ------
    labels= A list containing the features labels from the CSV
    values= A list containing the feature values from the CSV
    
    Returns
    -------
    A labeled matrix of equal dimensions padded with NA's
    "
  }
  # Find maximum vector length in the list and fill them all equally with NA's
  max.length <- max(sapply(values, length))
  values <- lapply(values, function(x){c(x, rep(NA, max.length-length(x)))})
  
  
}

csv_to_matrix <- function(filepath) { 
  if (FALSE){
    "This function is used to convert my custom CSV files
    into labeled matrices for further processing in R
    
    Params
    ------
    filepath= A string which points to the csv file
    
    Returns
    -------
    feature_names= A list containing the features labels from the CSV
    feature_values= A list containing the feature vales from the CSV
    "
  }
  data <- readLines(filepath)
  feature_names <- list()
  feature_values <- list()
  for (i in 1:length(data)) {
    line <- strsplit(data[i],",")[[1]]
    feature <- line[1]
    values <- as.numeric(line[2:length(line)])
    feature_names[i] <- feature
    feature_values[[i]] <- values
  }
  #return (list(feature_names, feature_values))
  return (create_labeled_matrix(feature_names, feature_values))
}

# Load Stem into raw_song_data
filepath = '/Users/harrison/Desktop/Thesis_Test/Ariana Grande - One Last Time/CSV/Ld Voc Stem_converted_normalized.csv'
raw_song_data <- load_custom_csv(filepath)

max.length <- max(sapply(raw_song_data[[2]], length))
values <- lapply(raw_song_data[[2]], function(x){c(x, rep(NA, max.length-length(x)))})
=======
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
>>>>>>> 8f7f6ca42b6d3a9a592e27ba0b4cf9af4e448eb0

# TRYING TO CONVERT LIST INTO MATRIX
test <- matrix(values, nrow=length(values), ncol=length(values[[1]]), byrow=TRUE)
