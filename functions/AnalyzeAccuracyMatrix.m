function [acc_matrix, time_recoder] = AnalyzeAccuracyMatrix(input_file_dirs,X_file_name,...
                                      y_file_name,val_split,t_window_len,f_window_len,...
                                      weights_flag,downsample_flag)
% AnalyzeAccuracyMatrix: using libsvm to get the accuracy matrix on X_tf.
% inputs:
%   input_file_dirs: direction of the input file, e.g. 'data/merge/'.
%   X_file_name: name of X_tf, e.g. 'X_tf_result.mat'.
%   y_file_name: name of y, e.g. 'Reward.mat'.
%   val_split: proportion of the training set (0,1), e.g. 0.5.
%   t_window_len: t_length of the sliding window (pixel).
%   f_window_len: f_length of the sliding window (pixel).
%   weights_flag: boolean variable, e.g. true: use weights in SVM.
%   downsample_flag: boolean variable, e.g. true: balance data by downsampling.
% outputs:
%   acc_matrix: accuracy matrix. Shape=[f t channel].
%               NOTE: because of the width of the sliding window, the size
%                     of acc_matrix is different from X_tf.
%   time_recoder: time cost by svm (s).

    % load data
    X_file = struct2cell(load([input_file_dirs X_file_name]));
    y_file = struct2cell(load([input_file_dirs y_file_name]));
    X = X_file{1};
    y = y_file{1};
    % get the unique collection of y, e.g. [1 1 2 3 2] --> [1 2 3]
    labels = unique(y);

    if downsample_flag
        label_num = zeros([length(labels), 1]); % number of every label.
        for i = 1:length(labels)
            label_num(i) = sum(y==labels(i));
        end
        min_num = min(label_num); % least number.
        label_train_num = floor(min_num*val_split)+1;
        label_test_num = min_num - label_train_num;
        train_num = length(labels) * label_train_num;
        test_num = length(labels) * label_test_num;

        X_train = nan([train_num, size(X,2), size(X,3), size(X,4)]);
        y_train = nan([train_num, 1]);
        X_test = nan([test_num, size(X,2), size(X,3), size(X,4)]);
        y_test = nan([test_num, 1]);

        % downsample to balance the dataset.
        for i = 1:length(labels)
            label_index = find(y==labels(i));
            %shuffle --> stochastic sample
            random_index = randperm(length(label_index));
            label_index = label_index(random_index);

            train_index = label_index(1:label_train_num);
            test_index = label_index((label_train_num+1):(label_train_num+label_test_num));
            X_train((1+(i-1)*label_train_num):(i*label_train_num),:,:,:) = X(train_index,:,:,:);
            y_train((1+(i-1)*label_train_num):(i*label_train_num)) = y(train_index);
            X_test((1+(i-1)*label_test_num):(i*label_test_num),:,:,:) = X(test_index,:,:,:);
            y_test((1+(i-1)*label_test_num):(i*label_test_num)) = y(test_index);
        end
    else
        % don't use downsampling.
        random_index =randperm(length(y));
        X = X(random_index,:,:,:);
        y = y(random_index);
        % split data.
        train_num = floor(val_split*size(X,1));
        X_train = X(1:train_num,:,:,:);
        y_train = y(1:train_num);
        X_test = X(train_num+1:end,:,:,:);
        y_test = y(train_num+1:end);
    end

    % shuffle the train dataset.
    random_index =randperm(length(y_train));
    X_train = X_train(random_index,:,:,:);
    y_train = y_train(random_index);
    % NOTE: because of the width of the sliding window, the size of acc_matrix is different from X_tf.
    matrix_t_len = size(X, 3)+1-t_window_len;
    matrix_f_len = size(X, 2)+1-f_window_len;
    number_channel = size(X, 4);
    acc_matrix = nan(matrix_f_len, matrix_t_len, number_channel);
    
    % build weights.
    if weights_flag
        label_weights = zeros([length(labels) 1]);
        y_weights = zeros([length(y_train) 1]);
        for i=1:length(labels)
            label_weights(i) = size(y_train,1)/sum(y_train==labels(i)); % weight = 1/proportion
            y_weights = y_weights + label_weights(i)*(y_train==labels(i));
        end
        % e.g. y_weights=label_weights(1)*(y_train==1)+label_weights(2)*(y_train==2)
        %                +label_weights(3)*(y_train==3)+label_weights(4)*(y_train==4);
    else
        y_weights = []; % if y_weights==[], then all the data has the same weight.
    end
    tic;
    % parallel computing to speed analyzing.
    pool = parpool(number_channel);
    parfor channel=1:number_channel
        temp_X_train = squeeze(X_train(:,:,:,channel));
        temp_X_test = squeeze(X_test(:,:,:,channel));
        for t=1:matrix_t_len
            for f=1:matrix_f_len
                fprintf('channel:%d    t:%d    f:%d \n', channel, t, f);
                temp_X_train_patch = reshape(temp_X_train(:,f:f+f_window_len-1,...
                                     t:t+t_window_len-1),[train_num,t_window_len*f_window_len]);
                temp_X_test_patch = reshape(temp_X_test(:,f:f+f_window_len-1,...
                                    t:t+t_window_len-1),[test_num,t_window_len*f_window_len]);

                % !!!!!!!NOTE: this svmtrain() is NOT the default svmtrain() in
                % matlab. You should download the toolkit from 
                % https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances
                model = svmtrain(y_weights, y_train, temp_X_train_patch);
                [~,acc,~] = svmpredict(y_test,temp_X_test_patch,model);
                acc_matrix(f,t,channel) = acc(1);
            end
        end
    end
    time_recoder = toc;
    delete(pool);
end
    