# LFP-Analyze #

**Because of the data security, we just upload our code.**

This project is mainly about [Local Field Potential](https://en.wikipedia.org/wiki/Local_field_potential "Local Field Potential") (LFP).

## Requirements ##

Please make sure that you have already install these toolkits.

 - **libsvm-weights**: [https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances](https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances "https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances")
 - **Matching Pursuit**: [https://github.com/supratimray/MP](https://github.com/supratimray/MP "https://github.com/supratimray/MP")

## Prepare Data ##

**Please add the folder "functions/" to your path in advance.**

*You just need to run this part once to build the workspace.*

At first, you can run **"extract_and_merge_data.m"** to merge the data from **"Igo08282012-01/"** and **"Igo08302012-01/"** (of course you can set the name). Then you will get a folder named **"data/"** which contains 3 subfolders --** "0828/"**, **"0830/"** and **"merge/"**. These are **workspaces** for the following operations.

Then you can run **"prepare_data.m"** to do **Gabor Decomposition** (We use [Matching Pursuit](https://en.wikipedia.org/wiki/Matching_pursuit "Matching Pursuit") to do this) on data and get **spectrograms** of data.*You should run it twice to get data of 'targ' and 'result'*.

If you want to see whether you do previous steps right, you can run **"retrieve_display.m"** to plot the original data, the reconstructed data and the spectrogram of a trial (3 channels).  

It may look like this:

![](https://github.com/ZhangXiao96/LFP-Analyze/blob/master/pictures/retrieve.jpg)

## Plot Average Spectrogram ##

After you have built the data workspace, you can plot the average spectrogram of data by running **"plot_average_spectrogram.m"**

It may look like this:

![](https://github.com/ZhangXiao96/LFP-Analyze/blob/master/pictures/result_Reward_average.jpg)

## Analyze Accuracy Matrix ##

After you have built the data workspace, you can analyze the accuracy matrix of data by running **"analyze_acc_matrix.m"** and you can also plot the accuracy matrix by running **"plot_acc_matrix.m"**.

In **"analyze_acc_matrix.m"**, we use **libsvm-weights** to classify the data (some details can be seen in **"analyze_acc_matrix.m"**). In order to speed the program, we use **parallel computing** on channels. However, it still cost a lot of time.

The accuracy matrix may look like this:

![](https://github.com/ZhangXiao96/LFP-Analyze/blob/master/pictures/result_Reward_acc_matrix.jpg)