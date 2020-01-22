# Information Prevalence Inference using the i-th order statistic: i-test
i-test is the MATLAB implementatation of the second-level (group-level) statistical test for the decoding accuracy proposed by Hirose (Under review). i-test is an extension of "Permutation-based prevalence inference using the minimum statistic", proposed by Allefeld et al., (Carsten Allefeld, Kai Görgen and John-Dylan Haynes, 'Valid population inference for information-based imaging: From the second-level t-test to prevalence inference', NeuroImage 2016, https://doi.org/10.1016/j.neuroimage.2016.07.040. https://github.com/allefeld/prevalence-permutation/).<br>
This repository include three subdirectories.<br>
<b>itest</b>: includes four MATLAB function files for the i-test. For detail, see readme.pdf<br>
<b> Replication_of_study</b>: The MATLAB codes for the replication of the study Hirose 2020 (https://doi.org/10.1101/578930). Add the itest directory to your MATLAB path beforehand.<br>
Open mother_script.m and copy each lines of codes to command window, in order to replicate the results in Hirose 2020.<br>
<b>Demo</b>: A simple GUI app enables us to calculate the i-test and Student t-test results for binary decoding study.<br>
Type "Demo_Comparison" and a Guide UI application will open. See "how_to_use.pdf" for usage instruction
