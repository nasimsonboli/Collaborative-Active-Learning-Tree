%% load
% load UI_matrix_train
% load item_sim_matrix
% load train_list
% load clusters
tic;
weight = 0.01;
dtmodel = ContentDecisionTree();
dtmodel.setDepthThreshold(7);
dtmodel.init(...
    UI_matrix_train, ...
    item_sim_matrix(train_list,train_list), ...
    clusters, weight);
dtmodel.buildTree();
dtmodel.UI_matrix_subtree = [];
dtmodel.generated_rating_matrix = [];
dtmodel.UI_matrix_full_unbiased = [];
toc;
save('dtmodel_1m_1.mat', 'dtmodel');