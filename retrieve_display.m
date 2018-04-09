% plot X_t, reconstructed_X_t, X_ft
clear;clc;close all;

trialNum=2; % plot Trial number 
folderName = 'data/merge/';
tag = 'targ'; 
f_length = 250;
t_length = 1024;
Fs = 1000;

% !!!!!!!!!!!!!!!!NOTE: f --> (Fs/t_length) Hz/pixel!!!!!!!!!!!!!!!!!!!!
f = 0:Fs/t_length:f_length;
t = (1:t_length)-501;

% load original data.
file_name = [folderName 'X_' tag '.mat'];
if ~exist(file_name,'file')
    error('the input_file_dirs "%s"DOESNOT exist!\n', file_name);
end
fprintf('loading data from "%s"...\n', file_name);
load(file_name);
if strcmp(tag, 'targ')==1
    X = X_targ;
elseif strcmp(tag, 'result')==1
    X = X_result;
else
    error('the TAG "%s" is not valid!("targ" or "result")\n', TAG);
end
fprintf('complete loading!\n')

% load Gabor Information
gaborInfo{1} = getGaborData(folderName,tag,1);
gaborInfo{2} = getGaborData(folderName,tag,2);
gaborInfo{3} = getGaborData(folderName,tag,3);

% Reconstruct signal
wrap=1;
atomList=[]; % all atoms

if isempty(atomList)
    disp(['Reconstructing trial ' num2str(trialNum) ', all atoms']);
else
    disp(['Reconstructing trial ' num2str(trialNum) ', atoms ' num2str(atomList(1)) ':' num2str(atomList(end))]);
end

rSignal1 = reconstructSignalFromAtomsMPP(gaborInfo{1}{trialNum}.gaborData,t_length,wrap,atomList);
rSignal2 = reconstructSignalFromAtomsMPP(gaborInfo{2}{trialNum}.gaborData,t_length,wrap,atomList);
rSignal3 = reconstructSignalFromAtomsMPP(gaborInfo{3}{trialNum}.gaborData,t_length,wrap,atomList);

% reconstruct energy
rEnergy1 = log(reconstructEnergyFromAtomsMPP(gaborInfo{1}{trialNum}.gaborData,t_length,wrap,atomList)+1);
rEnergy2 = log(reconstructEnergyFromAtomsMPP(gaborInfo{2}{trialNum}.gaborData,t_length,wrap,atomList)+1);
rEnergy3 = log(reconstructEnergyFromAtomsMPP(gaborInfo{3}{trialNum}.gaborData,t_length,wrap,atomList)+1);

figure;
% original data.
subplot(331);
plot(t,X(trialNum,:,1)); 
title('channel 1'); 
axis tight

subplot(332);
plot(t,X(trialNum,:,2));
title('channel 2');
axis tight

subplot(333);
plot(t,X(trialNum,:,3));
title('channel 3');
axis tight

% reconstruction
subplot(334);
plot(t,rSignal1,'k');
title('Reconstruction');
axis tight

subplot(335);
plot(t,rSignal2,'k');
title('Reconstruction');
axis tight

subplot(336);
plot(t,rSignal3,'k');
title('Reconstruction');
axis tight

%spectrograms
subplot(337);
pcolor(t,f,rEnergy1(1:length(f),:)); shading interp;
title('spectrograms');
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
axis tight

subplot(338);
pcolor(t,f,rEnergy2(1:length(f),:)); shading interp;
title('spectrograms');
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
axis tight

subplot(339);
pcolor(t,f,rEnergy3(1:length(f),:)); shading interp;
title('spectrograms');
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
axis tight

suptitle(['trial ' num2str(trialNum)])
