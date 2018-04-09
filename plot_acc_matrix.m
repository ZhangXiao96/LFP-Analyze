clear;clc;close all;
input_file_dirs = 'data/merge/';
tag = 'targ'; % 'result' or 'targ'
y_name = 'Direction';% 'Reward' or 'Option' or 'Direction'
t_length = 1024;
f_length = 250;
new_shape = [100 100]; % should equal the shape used to resize X_tf.
t_width = 10; % pixel
f_width = 15; % pixel

% load acc_matrix
acc_matrix_name = [tag '_' y_name '_acc_matrix.mat'];
acc_file = struct2cell(load([input_file_dirs acc_matrix_name]));
acc_matrix = acc_file{1};
acc_matrix  = acc_matrix / 100;

% set t and f
t = (floor(t_width/2):new_shape(1)-(t_width-floor(t_width/2)))*(t_length/new_shape(1))-501;
f = (floor(f_width/2):new_shape(2)-(f_width-floor(f_width/2)))*(f_length+1)/new_shape(2);

figure;
subplot(221)
pcolor(t,f,acc_matrix(:,:,1)); shading interp;
colorbar()
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
title('channel 1')
subplot(222)
pcolor(t,f,acc_matrix(:,:,2)); shading interp;
colorbar()
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
title('channel 2')
subplot(223)
pcolor(t,f,acc_matrix(:,:,3)); shading interp;
colorbar()
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
title('channel 3')

suptitle(['accuracy with the sliding window ' num2str((f_length+1)/new_shape(2)*f_width) ...
         'Hz*' num2str((t_length/new_shape(1))*t_width) 'ms'])