# Identifying Trends in Mixed Audio - EDSP16 Project

### Introduction
Often the third stage of the songwriting/production process, mixing ensures that the final product is perceived in the fashion which it was intended. A more textbook definition for mixing can be given as the combination of multiple audio signals, modifying them from a **dynamics**, **spatial**, and **spectral** level as a means of creating a cohesive whole. As a professional music producer, the author understands the plight and struggle of pouring tens of hours into a mixdown only to wind up being disappointed when hearing the final product compared against another song. Mixing is also notoriously difficult, requiring years of experience, expert taste, and fine tuned hearing. If the producer/artist can’t mix the song to satisfaction, he/she is left with no other choice but to hire professional help. The goal of this research is to eliminate this struggle, and provide both professional and amateur musicians alike with tools to aid them in the mixing process.

Previous research in this field has focused on creating models to autonomously sum multi-tracks in an intelligent fashion using Machine Learning, Cross Adaptive Methods, and "Knowledge Engineered Solutions".  While some of these efforts have achieved impressive results, the author of this project believes that in order for a viable model to be produced, a statistical analysis using ground truth data must be conducted.  Therefore, this project will extract a variety of audio features from professionally mixed data, and search for common trends in the extracted features in an attempt to reveal the existence of an "ideal" mixing scenario.

### The Data
The raw multi-track data used in this project is from a unique dataset managed/created by the author.  Because the raw data is copyrighted and monetized material, it cannot be shared.  However, the quantification of this data can be found in the [/Data](https://github.com/edsp2016/ITIMA_Zafrin_Harrison/tree/master/Data) folder in the form of CSV files.

To quantify the data, the author is developing a python library whose source code can be found [here.](https://github.com/bombsandbottles/THESIS) This library is still very much a work in progress and will be constantly updated to reflect the needs of this project.

#### Understanding The Data (What Does It Mean?)
For those without a background in music production, understanding exactly what the "mixing" stage of the song creation process is can be confusing.  In this section I hope to bring you up to speed in understanding what the data means in relation to the question.

Firstly, what does a mixed song vs. an unmixed song sound like...here is one example from the dataset:

[Mixed Song](https://drive.google.com/uc?id=0B39ZYiJJxa_zRmhCQThYSDFtT0k)

[Randomized Unmixed Song](https://drive.google.com/uc?id=0B39ZYiJJxa_zMzJZYzJuajlXT2c)

When we first discretize the audio, it exists in the "time domain" as a series of values between -1 and 1:

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zOXhDQ0stcEt2U1k "Raw Audio Data")

From here, we can quantify this data from a **dynamics**, **spatial**, and **spectral** standpoint in relation to the mixdown.  For example, one of the most important skills of the mixdown is for the engineer to adjust the "fader position" (the relative changing of a tracks volume so that it appears balanced against the other tracks in the mix).  Therefore in the case of "fader position", we are looking to quantify a dynamics related problem.  One feature we can extract from the data to shed insight into this mix parameter is that of "loudness":

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zeEZiWXFfS1liNHM "Amplitude vs. Loudness")

As you can see, where our raw amplitude waveform features drastically changing peak audio levels across time, our momentary loudness measurement returns a much smoother constant estimate of a possible "fader position" across time in the mixdown.

The same can be said about **spectral** features.  For example, here we analyze the same audio as before in the frequency domain with a short time Fourier transform to calculate its spectral centroid. This measurement is defined as the "center of gravity" of the spectrum, correlated with the brightness of a sound source:

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zY2tuanRzdDN5LXc "STFT and Spectral Centroid")

### Getting the Data into R

`load_song_data(path)` is the main function called on a folder which contains the .csv data.

```R
load_song_data <- function(path) {
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
```

This function calls `csv_to_matrix(filepath)`, which takes the csv file and converts it into a labelled matrix using the function `create_labeled_matrix(feature_names, feature_values)`

```R
csv_to_matrix <- function(filepath) { 
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
```

```R
 create_labeled_matrix <- function(feature_names, feature_values) {
  # Find maximum vector length in the list and fill them all equally with NA's
  max.length <- max(sapply(feature_values, length))
  feature_values <- lapply(feature_values, function(x){c(x, rep(NA, max.length-length(x)))})
  # Create the matrix
  feature_values <- do.call(rbind, feature_values)
  # Label the matrix
  rownames(feature_values) <- feature_names
  return (feature_values)
  }
```

#### Getting Meaning Out of the Data 

With these functions, each songs data is stored in a list containing a matrix for each audio stem.  Therefore as an example, if I wanted to compare the momentary loudness values for the lead vocal stems of Ariana Grandes "One Last Time" and Keshas "Cmon", I can do so in the following manner:

```R
# Load my Data
AG_OLT <- load_song_data('/Users/harrison/Desktop/Thesis_Test/Ariana Grande - One Last Time/CSV')
K_C <- load_song_data('/Users/harrison/Desktop/Thesis_Test/Kesha - Cmon/CSV')

# ggplot2 for the nice graphics
library("ggplot2")

# Index out the lead vocal of Ariana Grande, remove NA's
AG_LV <- AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_momentary', ]
AG_LV <- AG_LV[!is.na(AG_LV)]

# Index out the lead vocal of Kesha, remove NA's
K_LV <- K_C$`Ld Voc Stem_converted_normalized.csv`['loudness_momentary', ]
K_LV <- K_LV[!is.na(K_LV)]

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
```

The above code results in the following density plot:

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zaWZBT2I4N1Y3Qm8 "Lead Vocal Loudness Similarity")


