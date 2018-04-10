function [X_targ, X_result, Direction, Option, Reward]= ExtractDataFromLFPFoder( input_file_dirs, output_file_dirs )
% ExtractDataFromLFPFoder: extract data (including the target part and the result part)
%              from the files and save it to output_file_dirs.
% 
% inputs:
%   input_file_dirs: dirs of the original file.
%   output_file_dirs: dirs of the folder to save the outputs.
% 
% outputs:
%   X_targ: LFP Data_target. Shape=[trial time channel].
%   X_result: LFP Data_result. Shape=[trial time channel].
%   Direction: TrialInfo.ChosenDireaction.
%   Option: TrialInfo.ChosenOption.
%   Reward: TrialInfo.Reward.

    % check all the dirs.
    if ~exist(input_file_dirs,'dir')
        error('the input_file_dirs "%s"DOESNOT exist!\n', input_file_dirs);
    end
    if ~exist(output_file_dirs,'dir')
        mkdir(output_file_dirs);
    end
    % load data
    fprintf('loading data from "%s" ...\n', input_file_dirs);
    load([input_file_dirs 'LFP.mat']);
    load([input_file_dirs 'Event.mat']);
    fprintf('complete loading!\n');
    
    % save data in a specific format.
    X_targ = cat(3, LFPTargAll.Channel1, LFPTargAll.Channel2, LFPTargAll.Channel3);
    X_result = cat(3, LFPResultAll.Channel1, LFPResultAll.Channel2, LFPResultAll.Channel3);
    Direction = TrialInfo.ChosenDireaction;
    Option = TrialInfo.ChosenOption;
    Reward = TrialInfo.Reward;
    
    fprintf('saving data to "%s" ...\n', output_file_dirs);
    save([output_file_dirs 'X_targ.mat'], 'X_targ');
    save([output_file_dirs 'Option.mat'], 'Option');
    save([output_file_dirs 'Reward.mat'], 'Reward');
    save([output_file_dirs 'Direction.mat'], 'Direction');
    save([output_file_dirs 'X_result.mat'], 'X_result');
    fprintf('complete saving!\n');
end

