clc; clear; close all;
% plot average spectrogram of X_tf (according to labels).
input_file_dirs = 'data/merge/';
tag = 'targ';
y_name = 'Direction';
t_length = 1024;
f_length = 250;
max_limit = 0.8; % upper limit of values (after subtracting the baseline).
min_limit = -0.4; % lower limit of values (after subtracting the baseline).

% load data
X_file = struct2cell(load([input_file_dirs 'X_tf_' tag '.mat']));
y_file = struct2cell(load([input_file_dirs y_name '.mat']));
X = X_file{1};
y = y_file{1};

for channel = 1:3
    PlotAverageSpectrogramOfLabel(X, y, t_length, f_length, channel, max_limit, min_limit);
end