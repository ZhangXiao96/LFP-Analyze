clc; clear; close all;
% plot average spectrogram of X_tf (not according to labels).
input_file_dirs = 'data/merge/';
tag = 'result';
t_length = 1024;
f_length = 250;
max_limit = 0.8; % upper limit of values (after subtracting the baseline).
min_limit = -0.4; % lower limit of values (after subtracting the baseline).

% load data
X_file = struct2cell(load([input_file_dirs 'X_tf_' tag '.mat']));
X = X_file{1};

PlotAverageSpectrogram(X,t_length, f_length, max_limit, min_limit);