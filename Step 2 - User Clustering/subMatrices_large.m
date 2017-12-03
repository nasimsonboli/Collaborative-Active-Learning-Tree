rating_matrix = load('data/sparse_matrix_ml-20m.mat');
rating_matrix = rating_matrix.UI_matrix;
[userNum, itemNum] = size(rating_matrix);

random_index = single(randperm(itemNum));
train_list = random_index(1 : round(itemNum * 0.7));
test_list  = random_index(round(itemNum * 0.7) + 1 : end);

save('data/train_list.mat', 'train_list');
save('data/test_list.mat', 'test_list');
% load('data/train_list.mat');
% load('data/test_list.mat');

rating_matrix_train = rating_matrix(:, train_list);
rating_matrix_test = rating_matrix(:, test_list);
startPos = 1;
endPos = int32(userNum*0.1);
disp(full(sum(sum(rating_matrix_train~=0)))/27000000);
for i = 1:10
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
    UI_matrix_train = rating_matrix_train(startPos:endPos,:); 
    save(['data/UI_matrix_', num2str(i), '_train.mat'], 'UI_matrix_train');
    UI_matrix_test = rating_matrix_test(startPos:endPos,:); 
    save(['data/UI_matrix_', num2str(i), '_test.mat'], 'UI_matrix_test');
    
    startPos = endPos + 1;
    if i == 9        
        endPos = userNum;
    else
        endPos = endPos + int32(userNum*0.1);
    end
    disp('save DONE');
end