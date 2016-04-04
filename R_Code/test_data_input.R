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
  max.length <- max(sapply(feature_values, length))
  feature_values <- lapply(feature_values, function(x){c(x, rep(NA, max.length-length(x)))})
  # Create the matrix
  feature_values <- do.call(rbind, feature_values)
  # Label the matrix
  rownames(feature_values) <- feature_names
  return (feature_values)
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
    values <- c(as.numeric(line[2:length(line)]))
    feature_names[i] <- feature
    feature_values[[i]] <- values
  }
  #return (list(feature_names, feature_values))
  return (create_labeled_matrix(feature_names, feature_values))
}

load_song_data <- function(path) {
  if (FALSE){
    "This function takes a directory of CSVs and loads them
    into a list where each list item is a stem
    
    Params
    ------
    filepath= A string which points to the CSV directory containing the stem data
    
    Returns
    -------
    song_data= A list where each item is a matrix containing all the features of said stem
    "
  }
  filenames <- dir(path, pattern =".csv")
  song_data <- list()
  for(i in 1:length(filenames)){
    stem <- csv_to_matrix(file.path(path, filenames[i]))
    song_data[[i]] <- stem
  }
  # Name each stem in the list
  names(song_data) <- filenames
  return (song_data)
}

remove_NA <- function(x) {
  return (x <- x[!is.na(x)])
}

# Load my Data
AG_OLT <- load_song_data('/Users/harrison/Desktop/Thesis_Test/Ariana Grande - One Last Time/CSV')
K_C <- load_song_data('/Users/harrison/Desktop/Thesis_Test/Kesha - Cmon/CSV')

# ggplot2 for the nice graphics
library("ggplot2")

# Index out the lead vocal of Ariana Grande, remove NA's
AG_LV <- remove_NA(AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_momentary', ])

# Index out the lead vocal of Kesha, remove NA's
K_LV <- remove_NA(K_C$`Ld Voc Stem_converted_normalized.csv`['loudness_momentary', ])

# Data Frame the data?
ariana_vox <- data.frame(loudness = AG_LV)
kesha_vox <- data.frame(loudness = K_LV)

# Combine the dataframes into one
ariana_vox$singer <- 'Ariana Grande'
kesha_vox$singer <- 'Kesha'
loudness_values <- rbind(ariana_vox, kesha_vox)

# Histogram Plot or Density Curve?
ggplot(loudness_values, aes(loudness, fill = singer)) + geom_histogram(alpha = 0.5, aes(y = ..density..), position = 'identity')
ggplot(loudness_values, aes(loudness, fill = singer)) + geom_density(alpha = 0.2)

# Compare Intgrated Loudness for Lead Vocals
AG_LV_IL <- remove_NA(AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ])
K__LV_IL <- remove_NA(K_C$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ])
