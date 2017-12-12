%% load 
% sparse_matrix_ml-20m.mat
% load train_list.mat
% load test_list.mat
% load 3 user list
%%
name = 's3';
UI_matrix_train = UI_matrix(users, train_list);
UI_matrix_test = UI_matrix(users, test_list);
save(['../1m tree/UI_matrix_', name, '_train.mat'], 'UI_matrix_train');
save(['../1m tree/UI_matrix_', name, '_test.mat'], 'UI_matrix_test');