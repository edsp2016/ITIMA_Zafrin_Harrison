rm(list=ls())
#setwd('../Data')
library(psych)
library("ggplot2")
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

# Manually load the songs #
# Pop
AG_OLT <- load_song_data('Ariana Grande - One Last Time (Pop)')
K_C <- load_song_data('Kesha - Cmon (Pop)')
AL_ANLN <- load_song_data('Adam Lambert - Another Lonely Night (Pop)')
CH_LG <- load_song_data('Calvin Harris - Lets Go (Pop)')
JL_BIM <- load_song_data('Jamie Lidell - Believe in Me (Pop)')
KP_S <- load_song_data('Karin Park - Shine (Pop)')
NV_THYK <- load_song_data('Nico and Vinz - Thats How You Know (Pop)')
TC_DWYL <- load_song_data('Taio Cruz - Do What You Like Stems (Pop)')
TW_GMAT <- load_song_data('The Wombats - Give Me A Try (Pop)')
YY_D <- load_song_data('Years and Years - Desire (Pop)')


# EDM
AC_F <- load_song_data('Adventure Club - Fade (Dubstep)')
B_D <- load_song_data('Branchez - Dreamer (Trap)')
F_B <- load_song_data('Ferry Corsten - Back to Paradise (House)')
HWP_BUW <- load_song_data('Hollywood Principle - Breathing Under Water (Dubstep)')
HWP_SWN <- load_song_data('Hollywood Principle - Seeing Whats Next (Dubstep)')
HS_BY <- load_song_data('Hook n Sling - Break Yourself (House)')
JD_NYC <- load_song_data('John Dahlback - NYC (House)')
KS_GMYH <- load_song_data('Kissy Sell Out - GIve Me Your Hand (EDM)')
LL_WF <- load_song_data('LaidbackLuke - WereForever (House)')
MD_TF <- load_song_data('MachineDrum - Take Flight (Trap)')
MS_D <- load_song_data('Markus Shulz - Destiny (House)')
MDE_S <- load_song_data('My Digital Enemy - Shamen (House)')
T_U <- load_song_data('Truth - Undeniable (Dubstep)')
VM_A <- load_song_data('Vas Majority - Affluenza (Trap)')

# Manually get all the lead loudness values we want
lead_values <- c(remove_NA(AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ]))
#lead_values <- c(lead_values, remove_NA(K_C$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(K_C$`lv_test.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(AL_ANLN$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(AC_F$`VOCALS (893)_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(B_D$`Vox_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(CH_LG$`(Acapella)_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(F_B$`Vocals_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(HWP_BUW$`VoxLead_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(HWP_SWN$`Acapella_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(HS_BY$`Hook n Sling - Break Yourself_lead.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(JL_BIM$`LeadAca_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(JD_NYC$`Acapella_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(KP_S$`LeadVXWet_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(KS_GMYH$`Acapella_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(LL_WF$`VoxLead_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(MD_TF$`Guitar_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(MS_D$`Vocals_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(MDE_S$`Bass_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(NV_THYK$`Ld Voc Dirty Stem_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(TC_DWYL$`tc_dwyl_LV.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(TW_GMAT$`LEAD VOCAL PRINT_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(T_U$`Vocal_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(VM_A$`Drop_Lead_converted_normalized.csv`['loudness_integrated', ]))
lead_values <- c(lead_values, remove_NA(YY_D$`yearsandyears_LV.csv`['loudness_integrated', ]))

# Manually get all the instr loudness values we want
instr_values <- c(remove_NA(AG_OLT$`ariana_grande_one_last_time_instrumental.csv`['loudness_integrated', ]))
#instr_values <- c(instr_values, remove_NA(K_C$`kesha_cmon_instrumental.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(K_C$`kesha_cmon_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(AL_ANLN$`adam_lambert_another_loneley_night_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(AC_F$`Adventure_Club_FadeAway_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(B_D$`branchez_dreamer_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(CH_LG$`Calvin Harris Ft. Ne-Yo - Lets Go_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(F_B$`ferrycorsten_backtoparadise_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(HWP_BUW$`HollywoodPrinciple_Underwater_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(HWP_SWN$`hollywoodprinciple_seeingwhatsnext_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(HS_BY$`Hook n Sling - Break Yourself_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(JL_BIM$`jamielidell_believeinme_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(JD_NYC$`johndahlback_nyc_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(KP_S$`karinpark_shine_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(KS_GMYH$`kissysellout_givemeyourhand_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(LL_WF$`laidbackluke_wereforever_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(MD_TF$`machinedrum_takeflight_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(MS_D$`markisshulz_destiny_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(MDE_S$`mydigitalenemy_shamen_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(NV_THYK$`nicovinz_thatshowyouknow_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(TC_DWYL$`tc_dwyl_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(TW_GMAT$`wombats_givemeatry_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(T_U$`truth_undeniable_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(VM_A$`vasmajority_affluenza_instr.csv`['loudness_integrated', ]))
instr_values <- c(instr_values, remove_NA(YY_D$`yearsandyears_desire_instr.csv`['loudness_integrated', ]))

# BETWEEN EVERY SONG #
LU_Difference <- lead_values - instr_values
Song_Number <- 1:length(LU_Difference)
test <- data.frame(LU_Difference, Song_Number)
# Plotting the 'x' amount across the average
ggplot(test, aes(x=Song_Number, y=LU_Difference)) + geom_point() + scale_x_continuous(breaks=test$Song_Number) + geom_hline(aes(yintercept=mean(LU_Difference)), linetype=2) + ggtitle("Lead Element LU Relationship to Backing Instrumental With Adjustment")

# DESCRIPTIVE STATISTICS #
describe(LU_Difference)



####################################################
# Load my Data
AG_OLT <- load_song_data('/Users/harrison/Desktop/Thesis_Test/Ariana Grande - One Last Time/CSV')
K_C <- load_song_data('/Users/harrison/Desktop/Thesis_Test/Kesha - Cmon/CSV')

# Index out the lead vocal of Ariana Grande, remove NA's
AG_LV <- remove_NA(AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_momentary', ])

# Index out the lead vocal of Kesha, remove NA's
K_LV <- remove_NA(K_C$`Ld Voc Stem_converted_normalized.csv`['loudness_momentary', ])
K_LV_2 <- remove_NA(K_C$`lv_test.csv`['loudness_momentary', ])

# Data Frame the data?
ariana_vox <- data.frame(loudness = AG_LV[AG_LV > -30])
kesha_vox <- data.frame(loudness = K_LV[K_LV > -30])
kesha_vox_adjusted <- data.frame(loudness = K_LV_2[K_LV_2 > -30])

# Combine the dataframes into one
ariana_vox$singer <- 'Ariana Grande'
kesha_vox$singer <- 'Kesha'
kesha_vox_adjusted$singer <- 'Kesha Adjusted'
loudness_values <- rbind(ariana_vox, kesha_vox)

# Histogram Plot or Density Curve?
ggplot(loudness_values, aes(loudness, fill = singer)) + geom_histogram(alpha = 0.5, aes(y = ..density..), position = 'identity')
ggplot(loudness_values, aes(loudness, fill = singer)) + geom_density(alpha = 0.2)

# Compare Intgrated Loudness for Lead Vocals
AG_LV_IL <- remove_NA(AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ])
K__LV_IL <- remove_NA(K_C$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ])
K_LV_IL_2 <- remove_NA(K_C$`lv_test.csv`['loudness_integrated', ])

####################################################

#Perform Genre Test with Anova

# Pop Songs
pop_lead_values <- c(remove_NA(AG_OLT$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(K_C$`lv_test.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(AL_ANLN$`Ld Voc Stem_converted_normalized.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(CH_LG$`(Acapella)_converted_normalized.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(JL_BIM$`LeadAca_converted_normalized.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(KP_S$`LeadVXWet_converted_normalized.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(NV_THYK$`Ld Voc Dirty Stem_converted_normalized.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(TC_DWYL$`tc_dwyl_LV.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(TW_GMAT$`LEAD VOCAL PRINT_converted_normalized.csv`['loudness_integrated', ]))
pop_lead_values <- c(pop_lead_values, remove_NA(YY_D$`yearsandyears_LV.csv`['loudness_integrated', ]))
########
pop_instr_values <- c(remove_NA(AG_OLT$`ariana_grande_one_last_time_instrumental.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(K_C$`kesha_cmon_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(AL_ANLN$`adam_lambert_another_loneley_night_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(CH_LG$`Calvin Harris Ft. Ne-Yo - Lets Go_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(JL_BIM$`jamielidell_believeinme_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(KP_S$`karinpark_shine_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(NV_THYK$`nicovinz_thatshowyouknow_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(TC_DWYL$`tc_dwyl_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(TW_GMAT$`wombats_givemeatry_instr.csv`['loudness_integrated', ]))
pop_instr_values <- c(pop_instr_values, remove_NA(YY_D$`yearsandyears_desire_instr.csv`['loudness_integrated', ]))

# EDM Songs
edm_lead_values <- c(remove_NA(AC_F$`VOCALS (893)_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(B_D$`Vox_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(F_B$`Vocals_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(HWP_BUW$`VoxLead_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(HWP_SWN$`Acapella_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(HS_BY$`Hook n Sling - Break Yourself_lead.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(JD_NYC$`Acapella_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(KS_GMYH$`Acapella_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(LL_WF$`VoxLead_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(MD_TF$`Guitar_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(MS_D$`Vocals_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(MDE_S$`Bass_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(T_U$`Vocal_converted_normalized.csv`['loudness_integrated', ]))
edm_lead_values <- c(edm_lead_values, remove_NA(VM_A$`Drop_Lead_converted_normalized.csv`['loudness_integrated', ]))
########
edm_instr_values <- c(remove_NA(AC_F$`Adventure_Club_FadeAway_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(B_D$`branchez_dreamer_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(F_B$`ferrycorsten_backtoparadise_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(HWP_BUW$`HollywoodPrinciple_Underwater_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(HWP_SWN$`hollywoodprinciple_seeingwhatsnext_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(HS_BY$`Hook n Sling - Break Yourself_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(JD_NYC$`johndahlback_nyc_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(KS_GMYH$`kissysellout_givemeyourhand_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(LL_WF$`laidbackluke_wereforever_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(MD_TF$`machinedrum_takeflight_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(MS_D$`markisshulz_destiny_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(MDE_S$`mydigitalenemy_shamen_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(T_U$`truth_undeniable_instr.csv`['loudness_integrated', ]))
edm_instr_values <- c(edm_instr_values, remove_NA(VM_A$`vasmajority_affluenza_instr.csv`['loudness_integrated', ]))

# POP SONGS #
LU_Difference_pop <- pop_lead_values - pop_instr_values
Song_Numbers_Pop <- 1:length(LU_Difference_pop)
test <- data.frame(LU_Difference_pop, Song_Numbers_Pop)
ggplot(test, aes(x=Song_Numbers_Pop, y=LU_Difference_pop)) + geom_point() + scale_x_continuous(breaks=test$Song_Numbers_Pop) + geom_hline(aes(yintercept=mean(LU_Difference)), linetype=2) + ggtitle("Lead Element LU Relationship to Backing Instrumental With Adjustment")
describe(LU_Difference_pop)

# EDM SONGS #
LU_Difference_edm <- edm_lead_values - edm_instr_values
Song_Numbers_edm <- 1:length(LU_Difference_edm)
test <- data.frame(LU_Difference_edm, Song_Numbers_edm)
ggplot(test, aes(x=Song_Numbers_edm, y=LU_Difference_edm)) + geom_point() + scale_x_continuous(breaks=test$Song_Numbers_edm) + geom_hline(aes(yintercept=mean(LU_Difference)), linetype=2) + ggtitle("Lead Element LU Relationship to Backing Instrumental With Adjustment")
describe(LU_Difference_edm)

# Prep Anova
pop_songs <- replicate(length(LU_Difference_pop), "Pop")
edm_songs <- replicate(length(LU_Difference_edm), "EDM")
LU_differences_genre <- data.frame(c(LU_Difference_pop, LU_Difference_edm), c(pop_songs, edm_songs))
colnames(LU_differences_genre) <- c("LU_Difference", "Genre")
ggplot(LU_differences_genre, aes(x=Genre, y=LU_Difference, fill=Genre)) + geom_boxplot() + guides(fill=FALSE) + ggtitle("Lead Element LU Relationship to Backing Instrumental Between Genre Type")
genre_ANOVA = aov(data = LU_differences_genre, LU_Difference~Genre)
