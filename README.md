# Identifying Trends in Mixed Audio - EDSP16 Project
----------------------------

### Introduction
Often the third stage of the songwriting/production process, mixing ensures that the final product is perceived in the fashion which it was intended. A more textbook definition for mixing can be given as the combination of multiple audio signals, modifying them from an **amplitude**, **spatial**, and **spectral** level as a means of creating a cohesive whole. As a professional music producer, the author understands the plight and struggle of pouring tens of hours into a mixdown only to wind up being disappointed when hearing the final product compared against another song. Mixing is also notoriously difficult, requiring years of experience, expert taste, and fine tuned hearing. If the producer/artist can’t mix the song to satisfaction, he/she is left with no other choice but to hire professional help. The goal of this research is to eliminate this struggle, and provide both professional and amateur musicians alike with tools to aid them in the mixing process.

Previous research in this field has focused on creating models to autonomously sum multi-tracks in an intelligent fashion using Machine Learning, Cross Adaptive Methods, and "Knowledge Engineered Solutions".  While some of these efforts have achieved impressive results, the author of this project believes that in order for a viable model to be produced, a statistical analysis using ground truth data must be conducted.  Therefore, this project will extract a variety of audio features from professionally mixed data, and search for common trends in the extracted features in an attempt to reveal the existence of an "ideal" mixing scenario.

### The Data
The raw multi-track data used in this project is from a unique dataset managed/created by the author.  Because the raw data is copyrighted and monetized material, it cannot be shared.  However, the quantification of this data can be found in the [/Data](https://github.com/edsp2016/ITIMA_Zafrin_Harrison/tree/master/Data) folder in the form of CSV files.

To quantify the data, the author is developing a python library whose source code can be found [here.](https://github.com/bombsandbottles/THESIS).  This library is still very much a work in progress and will be constantly updated to reflect the needs of this project.

## Understanding The Data (What Does It Mean?)
For those without a background in music production, understanding exactly what the "mixing" stage of the song creation process is can be confusing.  In this section I hope to bring you up to speed in understanding what the data means in relation to the question, and what it looks like.