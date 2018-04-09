clear;clc;close all;

input_file_dirs = 'data/merge/';
tag = 'targ'; % 'result' or 'targ'
y_name = 'Direction';% 'Reward' or 'Option' or 'Direction'
val_split = 0.5; % The proportion of the training set 
label_balance = true; % boolean variable, e.g. true: use weights in SVM.

% if size(X_tf)==[trial 100 100 3] and f==0~250 Hz and t==-500~523 ms
% then unit_f = ((250+1)/100) Hz/pixel, unit_t = (1024/100) ms/pixel
t_window_len = 10; % pixel
f_window_len = 15; % pixel

X_file_name = ['X_tf_' tag '.mat'];
y_file_name = [y_name '.mat'];
fprintf('analyzing acc_matrix...\n')
[acc_matrix, time] = AnalyzeAccuracyMatrix(input_file_dirs,X_file_name,...
                     y_file_name,val_split, t_window_len,f_window_len, label_balance);
fprintf('complete analyzing. Time: %f s\n', time);

acc_matrix_name = [tag '_' y_name '_acc_matrix.mat'];
fprintf('saving acc_matrix as %s ...\n',acc_matrix_name);
save([input_file_dirs acc_matrix_name], 'acc_matrix');
fprintf('complete saving!\n');
