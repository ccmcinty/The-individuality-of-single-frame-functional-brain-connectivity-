# The-individuality-of-single-frame-functional-brain-connectivity-
Scripts and data associated with the paper "The individuality of single-frame functional brain connectivity"

Time series data are provided for the Midnight Scan Club study, which is openly available at OpenNeuro (https://openneuro.org/datasets/ds000224/versions/00001/download)
*MSC02 did not complete the Faces or Words task at ses-04 and instead completed them at ses-11. The time series labeled ses-04 in this repository comes from ses-11 from the original data.

### DYNAMIC FINGERPRINTING STEPS - MSC ###
Within the MSC, NCANDA, and BNET folder, there are several scripts and folders designed to be run to recreate analyses from this paper.
MSC is the only dataset of the three that is openly available to anyone, and therefore we provide preprocessed time series data for this study. NCANDA data is available to anyone upon signing a data use agreement. BNET will be made available after signing a data transfer agreement (contact corresponding author for access to BNET). 

Scripts should be run in the following order to recreate analyses:
1. StateMaps.m
2. Make_CompTensors.m
3. CT_Analyze... (number of database scans) ... (permutation test or linear mixed effects model)

--- StateMaps.m ---
The purpose of this script is to make a Node x Volume matrix representing the leading eigenvector of the phase coherence connectivity matrix at each timepoint in each fMRI scan. The only parameter that should be modified in this script is the 'atlas' variable, which determines the parcellation that matrices will be made for.

--- Make_CompTensors.m ---
This script should be run after StateMaps.m is finished running for the desired atlas parcellation. The purpose of this script is to create a tensor of Pearson's |r| values comparing each target volume to all other volumes in the MSC dataset. This script may take a long time to finish running.

--- CT_Analyze... ---
This script should be run after Make_CompTensors.m is finished running for the desired atlas parcellation. There are two versions of this script for each number of database scans (1, 5, or 9). One version fits a linear mixed effects model to determine the statistical significance of single volume predictions. The other version uses 1000 permutations to assess statistical significance of single and all-volume prediction accuracy.

### Parcellation / Database Size ###
The script CT_Analyze_TargetParcel_LME.m can be run after the three above scripts to get a p value for the effect of number of database scans and atlas parcellation

### Node Resolution Analyses ###
Within the folder NodeRes_Analyses, there are versions of the three scripts listed above designed to test whether identification is better using the Schaefer 100 atlas, the Schaefer 1000 atlas, or 100 nodes from the Schaefer 1000 atlas.

### Task Identification Analyses ###
Within the folder Task_Analyses, there are versions of the three scripts listed above designed to test which task is most easily identified.

### Static Network Fingerprinting ###
Within each study folder, there is a folder titled "Static_Fingerprint" that includes versions of the above three scripts designed for static network fingerprinting.
