%% load 
% sparse_matrix_ml-20m.mat
% load train_list.mat
% load test_list.mat
%%
[userNum, itemNum] = size(UI_matrix);

% random_index = single(randperm(itemNum));

name = '1m';
subsetNum = 3;
rating_matrix_train = UI_matrix(:, train_list);
rating_matrix_test = UI_matrix(:, test_list);
ratingNum = sum(rating_matrix_train, 2);
[~, index] = sort(ratingNum);
startPos = 1;
endPos = int32(userNum / subsetNum);
disp(full(sum(sum(rating_matrix_train~=0)))/1000000);
for i = 1 : subsetNum
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
    UI_matrix_train = rating_matrix_train(index(startPos:endPos),:); 
    save(['../', name, ' tree/UI_matrix_', num2str(i), '_train.mat'], 'UI_matrix_train');
    disp(num2str(sum(sum(UI_matrix_train~=0))));
    UI_matrix_test = rating_matrix_test(index(startPos:endPos),:); 
    save(['../', name, ' tree/UI_matrix_', num2str(i), '_test.mat'], 'UI_matrix_test');

    startPos = endPos + 1;
    if i == subsetNum - 1       
        endPos = userNum;
    else
        endPos = endPos + int32(userNum / subsetNum);
    end
    disp('save DONE');
end