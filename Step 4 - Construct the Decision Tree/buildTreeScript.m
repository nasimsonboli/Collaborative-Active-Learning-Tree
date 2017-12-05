%% load
% load UI_matrix_train
% load item_sim_matrix
% load train_list
% load clusters
tic;
dtmodel = ContentDecisionTree();
dtmodel.setDepthThreshold(9);
dtmodel.init(...
    UI_matrix_train, ...
    item_sim_matrix(train_list,train_list), ...
    clusters);
dtmodel.buildTree();
toc;
save('dtmodel_random_cluster,best_score_param.mat', 'dtmodel');