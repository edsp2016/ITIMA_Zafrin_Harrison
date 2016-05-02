# Identifying Trends in Mixed Audio - EDSP16 Project

### Introduction
Often the third stage of the songwriting/production process, mixing ensures that the final product is perceived in the fashion which it was intended. A more textbook definition for mixing can be given as the combination of multiple audio signals, modifying them from a **dynamics**, **spatial**, and **spectral** level as a means of creating a cohesive whole. As a professional music producer, the author understands the plight and struggle of pouring tens of hours into a mixdown only to wind up being disappointed when hearing the final product compared against another song. Mixing is also notoriously difficult, requiring years of experience, expert taste, and fine tuned hearing. If the producer/artist can’t mix the song to satisfaction, he/she is left with no other choice but to hire professional help. The goal of this research is to eliminate this struggle, and provide both professional and amateur musicians alike with tools to aid them in the mixing process.

Previous research in this field has focused on creating models to autonomously sum multi-tracks in an intelligent fashion using Machine Learning, Cross Adaptive Methods, and "Knowledge Engineered Solutions".  While some of these efforts have achieved impressive results, the author of this project believes that in order for a viable model to be produced, a statistical analysis using ground truth data must be conducted.  Therefore, this project will extract a variety of audio features from professionally mixed data, and search for common trends in the extracted features in an attempt to reveal the existence of an "ideal" mixing scenario.

### Project Goals

1. Investigate the relationship between the lead elements loudness in comparison to the rest of the summed instrumentation.
2. Investigate whether or not this relationship is variable depending on genre (Pop vs. EDM).

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

The above code results in the following density plot (values under -25 LU can be ignored):

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zaWZBT2I4N1Y3Qm8 "Lead Vocal Loudness Similarity")

Unfortunately this plot doesn't say much about the data and can even be misleading.  For example, here we see that Ariana Grandes lead vocal track has a bimodal distribution, featuring different loudness values for verse and chorus sections.  Meanwhile, Keshas lead vocal track seems to maintain a constant level of loudness regardless of where we are in the song.  However, just because Keshas lead vocal track does not increase in loudness during the chorus does not mean that:

1. The loudness of the entire track did not increase during the chorus.
2. The loudness of Keshas entire vocal bus did not increase during the chorus.

Because of this, depending on what limitations we put on how we analyze the data, we can get deceptive results.  Look what happens to the density curve if Keshas "Lead Vocal" track is adjusted to include the background vocals during the chorus.  The inclusion of these vocals creates a bimodal distribution similar to Arianas, who because of a creative decision to match the intensity of the chorus through volume automation instead of additive vocal takes, contains this bimodal distribution inherently without manual modification.  For this reason Arianas background vocal track does not change the loudness of the bussed vocal channel.

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zdk9uTGhzZXRPZE0 "Kesha Adjusted")

```R
# Compare Intgrated Loudness for Lead Vocals
AG_LV_IL <- remove_NA(AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ])
K__LV_IL <- remove_NA(K_C$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ])
K_LV_IL_2 <- remove_NA(K_C$`lv_test.csv`['loudness_integrated', ])

> AG_LV_IL
[1] -12.13452

> K__LV_IL
[1] -14.55341

> K_LV_IL_2
[1] -12.03277

```

### The Main Element Should be up by an Average of ‘x’ LU (Loudness Units)?
As defined by Pedro Pestana in his PhD dissertation (Pestana, 2014), it is common practice amongst mix engineers to treat the "lead element" of a song uniquely in relation to the other instruments.  In his PhD dissertation, Pestana showed that in relation to every other element in the mix, the lead element should be up by an average of 4 to 6 LU.   Furthermore, in relation to the entire backing track, the lead element should be 0 to -2 LU lower than the sum of all other instruments.  Unfortunately, these results are based on the assumption that every other element in the mix besides the lead element is of "equal loudness", a common misguided line of thought in the field.  As you can see if you look at the more detailed uploaded data this assumption is false. 

Surprisingly, past research which ignores this assumption achieved a similar result (Brecht De Man, Leonard, King, Reiss, 2014), showing that the lead element should be around -3LU in relation to the sum of the rest of the instrumentation.  These results are based on multiple mix engineers attempting to  mix a small group of songs independently of one another.  Contrary to that study, this project hopes to shed insight on this question from commercially available, professionally mixed recordings.

#### 1. Investigate the relationship between the lead elements loudness in comparison to the rest of the summed instrumentation.

For the first test, the author has decided to use only the "lead" multi-track compared to the rest of the instrumentation.  This method ignores the deceptive results seen in the density plots above as the "lead" multi-track may not be fully representative of the "lead instrument".  To acquire our lead element to backing instrumentation relationship, the lead instruments integrated loudness values are subtracted from the backing instrumentations integrated loudness levels.

```R
#Calculate and Plot LU Relationship
LU_Difference <- lead_values - instr_values
Song_Number <- 1:length(LU_Difference)
results_1 <- data.frame(LU_Difference, Song_Number)	
ggplot(results_1, aes(x=Song_Number, y=LU_Difference)) + geom_point() + scale_x_continuous(breaks=results_1$Song_Number) + geom_hline(aes(yintercept=mean(LU_Difference)), linetype=2) + ggtitle("Lead Element LU Relationship to Backing Instrumental")

# Descriptive Statistics
> describe(LU_Difference)
  vars  n  mean   sd median trimmed mad   min  max range  skew kurtosis   se
1    1 24 -3.34 2.05  -3.16   -3.24 1.3 -9.15 0.89 10.04 -0.72     1.07 0.42
```

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zOF9PTV9fcWg5MzQ "LU Relationship between Lead and Instrumental")

While these initial results show a similar relationship of -3LU as found in Man, Leonard, King, and Reiss 2014, some of the outlying data points seemed less than ideal. In an attempt to improve the results, I experimented with adjusting the lead vocal track to include multiple parts as shown in the previous section.  **Notice how song 2** (Kesha - Cmon) improves to be closer to the mean after it is adjusted.  While this improves the results, it is also a dangerous game of subjectivity and data manipulation.  Furthermore, it speaks to how important it is to finding the right method to compare all these complex variables.

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zaUNkVGUwQ3lqMVE "Adjusted Kesha in the LU Relationship between Lead and Instrumental")

#### 2. Investigate whether or not this relationship is variable depending on genre (Pop vs. EDM).	

To explore this relationships genre effect, a one way ANOVA was performed by separating the songs into two groups (EDM and Pop).  While past research has explored the spectral differences in genre from fully summed 2-tracks, no research has observed this loudness relationship across different genres.

```R
> describe(LU_Difference_edm)
  vars  n  mean  sd median trimmed  mad   min   max range  skew kurtosis   se
1    1 14 -2.96 1.3  -2.96   -2.88 0.98 -6.14 -0.75  5.39 -0.67     0.41 0.35

> describe(LU_Difference_pop)
  vars  n  mean   sd median trimmed  mad   min  max range skew kurtosis   se
1    1 10 -2.92 1.75  -3.04   -3.05 0.76 -5.68 0.89  6.57 0.68    -0.03 0.55


ggplot(LU_differences_genre, aes(x=Genre, y=LU_Difference, fill=Genre)) + geom_boxplot() + guides(fill=FALSE) + ggtitle("Lead Element LU Relationship to Backing Instrumental Between Genre Type")
genre_ANOVA = aov(data = LU_differences_genre, LU_Difference~Genre)

> summary(genre_ANOVA)
			Df Sum Sq Mean Sq F value Pr(>F)
Genre        1   0.01  0.0099   0.004  0.948
Residuals   22  49.58  2.2538 
```

![alt text](https://drive.google.com/uc?id=0B39ZYiJJxa_zZDFyQXhRdEYwZTQ "ANOVA Boxplot")

As we can see from our ANOVA, there is no statistical difference between the two groups **(p > 0.05)**.  This implies that for the genres of Pop and EDM, the lead elements relationship to the backing instrumental is similar.

### Future Work

As of right now due to time constraints, I have only been able to load 24 songs into R for analyses with over 40 more remaining.  However, as shown previously, the 24 songs that are already incorporated into this investigation may not be fully optimized for comparison.  Beyond adding more data into this investigation I hope to:

1. Figure out the best way to optimize the data for comparison
2. Investigate the loudness relationship between other common instruments found across all songs in the dataset (Lead Vocal vs. Drums, Lead Vocal vs. Bass)
3. Restructure the data input into R so that it's not overly cumbersome and complicated to work with.

### Cited Sources

1. Brecht De Man, Brett Leonard, Richard King, and Joshua D. Reiss. "An analysis and evaluation of audio features for multitrack music mixtures." 15th International Society for Music Information Retrieval Conference (ISMIR 2014). 2014.

2. Pestana, Pedro Duarte Leal Gomes. Automatic mixing systems using adaptive digital audio effects. Diss. Universidade Católica Portuguesa, 2013.
