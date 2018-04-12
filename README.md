# LFP-Analyze #

**Because of the data security, we just upload our code.**

## Introduction ##

This project is mainly about [Local Field Potential](https://en.wikipedia.org/wiki/Local_field_potential "Local Field Potential") **(LFP)**. Thoulgh we can't publish our data, we  can present its format.

The data is **3-channel time series**. The sampling rate is **1kHz** and the length of series is **1024 points (-500ms~523ms)**. However, it is only the signal **0ms~523ms** that matters.

The data is devided into **two** part, **"Target"** and **"Result"**. We have different classification tasks for different parts. 

**Target:** 
 
- Classify **ChosenDirection (1-4)**
- Classify **ChosenOption (1-7)**

**Result:**

- Classify **ChosenOption (1-7)**
- Classify **Reward [1 3 5 9]**

The data was saved as **".mat"** file. The structure of data files is followed:
 
**Igo08282012-01/**

- Event.mat (include **"TrialInfo.ChosenOption"**, **"TrialInfo.ChosenDirection"** and **"TrialInfo.Reward"**)
- LFP.mat (include **"LFPResultAll"** and **"LFPTargAll"**)
- Spike.mat

**Igo08302012-01/**

- Event.mat (include **"TrialInfo.ChosenOption"**, **"TrialInfo.ChosenDirection"** and **"TrialInfo.Reward"**)
- LFP.mat (include **"LFPResultAll"** and **"LFPTargAll"**)
- Spike.mat

## Requirements ##

Please make sure that you have already installed these toolkits.

 - **libsvm-weights**: [https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances](https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances "https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances")
 - **Matching Pursuit**: [https://github.com/supratimray/MP](https://github.com/supratimray/MP "https://github.com/supratimray/MP")

**Please add the folder "functions/" to your path in advance.**

## Prepare Data ##


*You just need to run this part once to build the workspace.*

At first, you can run **"extract_and_merge_data.m"** to merge the data from **"Igo08282012-01/"** and **"Igo08302012-01/"** (of course you can set another name). Then you will get a folder named **"data/"** which contains 3 subfolders --**"0828/"**, **"0830/"** and **"merge/"**. These are **workspaces** of the following operations.

Then you can run **"prepare_data.m"** to do **Gabor Decomposition** (We use [Matching Pursuit](https://en.wikipedia.org/wiki/Matching_pursuit "Matching Pursuit") to do this) on data and get **spectrograms** of data. Please note that when building **X_tf**, a.k.a spectrogram, the size of X_tf will change. Therefore **DON'T** ignore the **scale (?Hz/pixel or ?ms/pixel)**. *You should run it twice to get X_tfs of 'targ' and 'result'*.

If you want to see whether you do previous steps correctly, you can run **"retrieve_display.m"** to plot the original data, the reconstructed data and the spectrogram of a trial (3 channels).  

It may look like this:

![](https://github.com/ZhangXiao96/LFP-Analyze/blob/master/pictures/retrieve.jpg)

## Plot Average Spectrogram ##

After you have built the data workspace, you can plot the average spectrogram of data by running **"plot_average_spectrogram.m"**. If you want to plot average spectrograms of different labels, you can run **"plot_average_spectrogram_of_label.m"**.

If you run **"plot_average_spectrogram.m"**, it may look like this:

- **"Result"**

![](https://github.com/ZhangXiao96/LFP-Analyze/blob/master/pictures/ave_result.jpg)

- **"targ"**

![](https://github.com/ZhangXiao96/LFP-Analyze/blob/master/pictures/ave_targ.jpg)

## Analyze Accuracy Matrix ##

After you have built the data workspace, you can analyze the accuracy matrix of data by running **"analyze_acc_matrix.m"** and you can also plot the accuracy matrix by running **"plot_acc_matrix.m"**.

In **"analyze_acc_matrix.m"**, we use **libsvm-weights** to classify the data (more details can be found in **"analyze_acc_matrix.m"**). In order to speed up the program, we use **parallel computing** on channels. However, it still cost a lot of time. In this step, you have two choices to balance the labels. One is **giving different weights to different labels** and the other one is **downsampling**. You can just change two boolean variables in **"analyze_acc_matrix.m"** to decide which method to use (more details can be found in **"analyze_acc_matrix.m"**). We recommend **the latter**.

The accuracy matrix may look like this:

- **val_split** = **0.5**; **tag** = **"result"**; **y_name** = **"Reward"**; **downsample**.

![](https://github.com/ZhangXiao96/LFP-Analyze/blob/master/pictures/result_reward.jpg)
