# AML_Project3

This repository contains the inputs, scripts and outputs of the final project for the Analysis and Modeling of Locomotion course. 
In the main folder are the input datasets for the analysis, the main scripts and the output structures. 
Figures and functions are separated in two other folders. 

To obtain the results presented in the final report (check "Report" folder), the steps to perform are:
- Run Feature_Extraction_Healthy_Final.m
- Run Feature_Extraction_Patient_Final.m
- Run PCA.m

(Note: Make sure the "functions" folder is included in the path before running the scripts).

By doing so, all used features will be computed and the results per gait cycled of all measures saved in output structures ("Healthy_data.mat" and "Patient_data.mat"). Those are the inputs of the PCA script. The latest shapes and standardizes the data, then performs PCA analysis and plots the results. 

Additional scripts can be found in the main folder too, namely "EMG_feats.m", "plotting_spectrum.m", as well as the version of the feature extraction using all computed features. Those are used for the report but not needed for the main workflow of this project. 
