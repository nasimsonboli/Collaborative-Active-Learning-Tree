%% load
% load full sparse matrix
% load UI_matrix_train
% load item_sim_matrix
% load train_list
% load clusters
tic;
weight = 0.01;
error_with_full = 1;
dtmodel = ContentDecisionTree();
dtmodel.setDepthThreshold(9);
dtmodel.init(...
    error_with_full, UI_matrix(:, train_list),...
    UI_matrix_train, ...
    item_sim_matrix(train_list,train_list), ...
    clusters, weight);
dtmodel.buildTree();
dtmodel.UI_matrix_full = [];
dtmodel.UI_matrix_subtree = [];
dtmodel.generated_rating_matrix = [];
dtmodel.UI_matrix_full_unbiased = [];
toc;
save('dtmodel_20m_1.mat', 'dtmodel');