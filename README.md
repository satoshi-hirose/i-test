# Permutation-based Information Prevalence Inference using the i-th order statistic: i-pinpin

This is the MATLAB implementatation of the second-level statistical test for the decoding accuracy proposed by Hirose, 2019 (https://doi.org/10.1101/578930). iPinPin is an extension of "Permutation-based prevalence inference using the minimum statistic", proposed by Allefeld et al., (Carsten Allefeld, Kai Görgen and John-Dylan Haynes, 'Valid population inference for information-based imaging: From the second-level t-test to prevalence inference', NeuroImage 2016, https://doi.org/10.1016/j.neuroimage.2016.07.040. https://github.com/allefeld/prevalence-permutation/).
 i-PinPin provide a way to perform the group-level statistical test for informaiton-like measures, e.g. classification accuracy, Mahalanobis distance, similarity index etc. 
******************************************************************************************************************
ipipi.m (Implementation of iPinPin)
    [H, prob, stat] = ipipi(SD,PD,g_0,i,alpha,homogeneity)<br>
    (N: Number of participant, Np: Number of permutatiuon for each participant)
 
 Inputs:<br>
    SD      : Sample Decoding Accuracies from experiment (N x 1 matrix)<br>
    PD      : Permutation Decoding Accuracies (N x Np matrix)<br>
    g_0     : Prevalence threshold, gannma0 (Real number between 0 and 1 default:0.5)<br>
    i          : Index of order statistics (Postive Integer, default: 1)<br>
    alpha  : statistical threshold (Real number between 0 and 1 default:0.05)<br>
    homogeneity : 1 if you assume the homogeneity of distribution among participants (boolean, default: 0)<br><br>
 Output:<br>
    H    : 1 if Prob < alpha, 0 otherwise<br>
    Prob : Probability of null hypothesis is rejected<br>
    stat: (structure)<br>
       .prob_min minimum probability. should be smaller than alpha.<br>
       .param          predetermined parameters (g_0,i,alpha) & number of subjects (N), number of permutations(Np)<br>
       .order_stat     i-th order statistic of S (real number)<br>
       .P_0<br>

 It takes two main inputs (SD and PD), as well as three numeric parameters (g_0, i, alpha) and one boolean parameter (homogeneity).
 SD is the test statistic obatained from first-level analyses (e.g. decoding accuracy), while PD are samples from null distribution normally obtained by permutation test.
 Original version of iPinPin does not reqire the assumption of homogeneity of the null distribution among participants. If the homogeneity can be assumed, set homogeneity=1, which saves computational costs, particularly when the number of participants are larege.
 For detail of the parameters, please see the original paper (Hirose 2019).
******************************************************************************************************************
Apply_Real_Experimental_Results.m 
 The code for reproducibility of ipipi.m. Please save Apply_Real_Experimental_Results.m and Real_Experimental_Results.mat to the same directory and run the script.
******************************************************************************************************************
Real_Experimental_Results.mat
 This is MATLAB data file includes a part of results form Hirose, Nambu, Naito 2018, Cortical activation associated with motor preparation can be used to predict the freely chosen effector of an upcoming movement and reflects response time: An fMRI decoding study https://doi.org/10.1016/j.neuroimage.2018.08.060), which is provded for the check of the iPinPin reproducibility.
 The file include two matrices, SD and PD. SD (12 x 1 matrix) include decoding accuracies obtained from the experiment for 12 participants, while PD (12 x 1,000) is the permutation results. Load the .mat file and try the following codes.
 
******************************************************************************************************************


The other .m files are for theoretical evaluation of the statistivcal power.
Readme for these files will be uploaded soon.
