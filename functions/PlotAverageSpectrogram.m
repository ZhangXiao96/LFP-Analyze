function PlotAverageSpectrogram( X_tf, t_length, f_length, max_limit, min_limit )
% PlotAverageSpectrogram: plot average spectrogram of X_tf(not with labels).
% inputs:
%   X_tf: spectrograms of X. Shape=[trial frequency time channel].
%   t_length: length of time (1024).
%   f_length: length of frequency (250).
%   max_limit: upper limit, e.g. X_tf(X_tf>max_limit)=max_limit.
%   min_limit: lower limit, e.g. X_tf(X_tf<min_limit)=min_limit.

    %[-500ms 523ms]-->[1 1024]-->[1 size(X_tf,3)]
    %[-400ms -100ms]-->[101 401]-->int{(size(X_tf,3)/1024)*[101 401]}
    % get the start and the end of the baseline.
    base_start = floor(size(X_tf,3)/t_length*101);
    base_end = floor(size(X_tf,3)/t_length*401);
    
    % The baseline is subtracted
    baseline = mean(X_tf(:,:,base_start:base_end,:),3);
    baseline = repmat(baseline,[1,1,size(X_tf,3),1]);
    X_tf = X_tf - baseline;
    
    %set t and f
    f = 0:((f_length+1)/size(X_tf,2)):f_length;
    t = -500:(t_length/size(X_tf,3)):523;
    channel_num = size(X_tf,4);
    figure;
    for channel = 1:channel_num
        X = squeeze(mean(X_tf(:, :, :, channel),1));
        % limit the range.
        X(X>max_limit)= max_limit;
        X(X<min_limit)= min_limit;
        subplot(2,floor(channel_num/2+0.5),channel);
        pcolor(t, f, X); shading interp;
        xlabel('Time (ms)'); ylabel('Frequency (Hz)');
        % colorbar();
        title(['channel ' num2str(channel)]);
    end
    suptitle('average spectrograms')
end

