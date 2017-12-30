%% load
% load UI_matrix_unbiased
% load UI_matrix_train
% load item_sim_matrix
% load train_list
% load clusters
tic;
name = '20m';
number = 4;
weight = 0.01;
error_with_full = 0;
fixed_interval_mode = 0;
bias_mode = 0;

%% MPS for cluster
% clusters_sub = findTopKUserCluster( clusters, single(full(UI_matrix_train)), 150);
clusters_sub = clusters;
%% Build tree
UI_matrix_unbiased = [];
dtmodel = ContentDecisionTree();
dtmodel.setDepthThreshold(7);
dtmodel.init(...
    bias_mode, error_with_full, ...
    UI_matrix_unbiased, UI_matrix_train, ...
    item_sim_matrix(train_list,train_list), ...
    clusters_sub, weight);
dtmodel.buildTree(fixed_interval_mode);
dtmodel.UI_matrix_subtree = [];
dtmodel.generated_rating_matrix = [];
dtmodel.UI_matrix_unbiased = [];
toc;
save(['../', name, ' tree/Trees/', num2str(number), '/dtmodel_', num2str(number), '.mat'], 'dtmodel');