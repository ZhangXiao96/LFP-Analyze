
% ===================extract and merge data===================
% you only need to run this part once.
output_file_dirs = 'data/merge/';

[X_targ1, X_result1, Direction1, Option1, Reward1] = ExtractData('Igo08282012-01/','data/0828/');
[X_targ2, X_result2, Direction2, Option2, Reward2] = ExtractData('Igo08302012-01/','data/0830/');
% merge these data.
X_targ = cat(1, X_targ1, X_targ2);
X_result = cat(1, X_result1, X_result2);
Direction = cat(1, Direction1, Direction2);
Option = cat(1, Option1, Option2);
Reward = cat(1, Reward1, Reward2);

if ~exist(output_file_dirs,'dir')
        mkdir(output_file_dirs);
end
% save the merg_data
fprintf('saving data to "%s" ...\n', output_file_dirs);
save([output_file_dirs 'X_result.mat'], 'X_result');
save([output_file_dirs 'X_targ.mat'], 'X_targ');
save([output_file_dirs 'Option.mat'], 'Option');
save([output_file_dirs 'Reward.mat'], 'Reward');
save([output_file_dirs 'Direction.mat'], 'Direction');
fprintf('complete saving!\n');
% ============================================================