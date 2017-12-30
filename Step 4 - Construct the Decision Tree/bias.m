%% Load
% load full sparse matrix
% load train_list

%% divide into few subsets to calculate
userNum = size(UI_matrix, 1);
subsetNum = 10;
startPos = 1;
endPos = int32(userNum / subsetNum);

%% Bias for items
UI_matrix_train = UI_matrix(:, train_list);
UI_matrix_unbiased =  UI_matrix_train .* 0;
global_mean = sum(sum(UI_matrix_train)) / sum(sum(UI_matrix_train~=0));
item_bias = (sum(UI_matrix_train, 1) + 7*global_mean) ./ (7+sum(UI_matrix_train~=0, 1));

for i = 1: subsetNum
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
    
    UI_matrix_unbiased(startPos : endPos, :) = UI_matrix_train(startPos : endPos, :) - repmat(item_bias, endPos - startPos + 1, 1) .* (UI_matrix_train(startPos : endPos, :)~=0);
    
    startPos = endPos + 1;
    if i == subsetNum - 1        
        endPos = userNum;
    else
        endPos = endPos + int32(userNum / subsetNum);
    end
    disp('item bias DONE')
end

save('UI_matrix_unbiased_20m.mat', 'UI_matrix_unbiased')