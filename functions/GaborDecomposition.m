function time_decomp = GaborDecomposition( X, folder_name, tag, length, Fs, max_iterations )
% GaborDecomposition: use Gabor atoms to decompose X.
%   The toolkit is from https://github.com/supratimray/MP
% inputs:
%   X: multichannel time series. Shape=[trial time channel].
%   folder_name: folder to save the information of matching pursuit(mp).
%   tag: name of the subfolder, e.g. ./folder_name/tag/
%   length: length of time (1024).
%   Fs: sampling rate (Hz), e.g. Fs=1000 if the sampling rate is 1000Hz
%   max_iterations: number of iterations, e.g. max_iterations=100.
% outputs:
%   time_decomp: time that 'runGabor' costs.

    % the X of importData() need to be [time trial channel]
    X = permute(X,[2,1,3]);
    importData(X, folder_name, tag, [1 length], Fs);
    
    tic;
    % perform Gabor decomposition
    runGabor(folder_name, tag, length, max_iterations);
    time_decomp = toc;
end

