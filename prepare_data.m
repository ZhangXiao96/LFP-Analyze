clc; clear; close all;

input_file_dirs = 'data/merge/';
tag = 'targ'; % 'targ': X_targ.mat, 'result': X_result.mat

if ~((strcmp(tag, 'targ')==1) || (strcmp(tag, 'result')==1))
    error('the TAG "%s" is not valid!("targ" or "result")\n', tag);
end

% =========================load data==========================
file_name = [input_file_dirs 'X_' tag '.mat'];
if ~exist(file_name,'file')
    error('the input_file_dirs "%s"DOESNOT exist!\n', file_name);
end
fprintf('loading data from "%s"...\n', file_name);
X_file = struct2cell(load(file_name));
X = X_file{1};
fprintf('complete loading!\n')
% ============================================================

% =====================matching pursuit=======================
t_length = 1024;% length of time (number of points).
f_length = 250;% length of frequency, e.g. f_length=250 means choosing 0Hz~250Hz
Fs = 1000;% sampling rate (Hz).
max_iterations = 100; % number of iterations.
new_shape = [100 100]; % new shape of X_tf. ==> X_tf will be resized as [trial 100 100 channel].
filter_flag = false; % true: use filters.
filter_size = []; %(only useful when filter_flag==true), e.g. filter_size=[f_width t_width].

% Gabor Decomposition
fprintf('performing Gabor decomposition...\n');
% estimation time for GaborDecomposition (MAX_ITERATIONS)
time_decomp = GaborDecomposition( X, input_file_dirs, tag, t_length,...
    Fs, max_iterations );
fprintf('complete Gabor decomposition!\n');

% get the X_tf
X_tf= ReconstructFromAtoms(input_file_dirs, tag, Fs, t_length, f_length,...
    new_shape, filter_flag, filter_size);
% save X_tf to INPUT_FILE_DIRS
fprintf('saving X_tf to %s...\n',input_file_dirs);
if strcmp(tag, 'targ')==1
    X_tf_targ = X_tf;
    save( [input_file_dirs 'X_tf_targ.mat'],'X_tf_targ','-v7.3');
elseif strcmp(tag, 'result')==1
    X_tf_result = X_tf;
    save( [input_file_dirs 'X_tf_result.mat'],'X_tf_result','-v7.3');
else
    error('the TAG "%s" is not valid!("targ" or "result")\n', tag)
end
fprintf('complete saving!\n');
% ============================================================
fprintf('Time Recoder: Gabor Decomposition --> %f s\n', time_decomp);