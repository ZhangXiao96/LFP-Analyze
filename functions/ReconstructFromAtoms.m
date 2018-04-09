function X_tf = ReconstructFromAtoms( folder_name, tag, Fs, t_length, f_length, new_shape, filter_flag, filter_size)
% ReconstructFromAtoms: get the X_tf.
%   The toolkit is from https://github.com/supratimray/MP
%
% inputs:
%   folder_name: folder to save the information of matching pursuit(mp).
%   tag: name of the subfolder, e.g. ./folder_name/tag/
%   Fs: sampling rate (Hz).
%   t_length: length of time, e.g. t_length=1024.
%   f_length: length of frequency, e.g. f_length=250 means choosing 0Hz~250Hz
%   new_shape: new shape of the outputs, e.g. new_shape=[frequency time]
%              ==> X_tf will be resized as [trial frequency time channel].
%   filter_flag: boolean variable. true: using average filter.
%   filter_size: size of the filter (only useful when filter_flag==true), e.g. filter_size=[f_width t_width].
%                !!!!NOTE--before resizing.
% outputs:
%   X_tf: spectrograms of X.Shape=[trial frequency time channel]

    % get the spectrograms.
    f = 0:Fs/t_length:f_length;
    
    fprintf('reconstructing the spectrograms from atoms...\n');
    gaborInfo{1} = getGaborData(folder_name,tag,1);
    gaborInfo{2} = getGaborData(folder_name,tag,2);
    gaborInfo{3} = getGaborData(folder_name,tag,3);
    if filter_flag
        f_width = filter_size(1);
        t_width = filter_size(2);
        filter = ones(f_width, t_width)/(t_width*f_width);
    end
    
    X_tf = zeros(size(gaborInfo{1},2),new_shape(1),new_shape(2),3);
    wrap=1;
    atomList=[]; % [] means using all the atoms.
    for trialNum=1:size(gaborInfo{1},2)
        fprintf('processing %d/%d...\n', trialNum, size(gaborInfo{1},2));
        
        % x --> log(x+1)
        rEnergy1 = log(reconstructEnergyFromAtomsMPP(gaborInfo{1}{trialNum}.gaborData,t_length,wrap,atomList)+1);
        rEnergy2 = log(reconstructEnergyFromAtomsMPP(gaborInfo{2}{trialNum}.gaborData,t_length,wrap,atomList)+1);
        rEnergy3 = log(reconstructEnergyFromAtomsMPP(gaborInfo{3}{trialNum}.gaborData,t_length,wrap,atomList)+1);

        % get the chosen part.
        rEnergy1 = reshape(rEnergy1(1:length(f),:), length(f), t_length, 1);
        rEnergy2 = reshape(rEnergy2(1:length(f),:), length(f), t_length, 1);
        rEnergy3 = reshape(rEnergy3(1:length(f),:), length(f), t_length, 1);
        
        % filt
        if filter_flag       
            rEnergy1 = imfilter(rEnergy1,filter);
            rEnergy2 = imfilter(rEnergy2,filter);
            rEnergy3 = imfilter(rEnergy3,filter);
        end
        
        % resize
        picture = cat(3,rEnergy1,rEnergy2,rEnergy3);
        picture = imresize(picture, new_shape);
        
        X_tf(trialNum,:,:,:) = picture;
    end
    fprintf('complete reconstructing!\n');
end

