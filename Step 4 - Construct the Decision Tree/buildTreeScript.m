%% load
% load UI_matrix_unbiased
% load UI_matrix_train
% load item_sim_matrix
% load train_list
% load clusters

% number = 10;
depth = 7;
weight = 0.01;
error_with_full = 0;

fixed_interval_mode = 0;
bias_mode = 0;

%% MPS for cluster
MPS_mode = 1;
if MPS_mode
	clusters_sub = findTopKUserCluster( clusters, cluster_size, single(full(UI_matrix_train)), 150);
else
    clusters_sub = clusters;
end
disp(num2str(size(clusters_sub, 2)));

%% Build tree
tic;
UI_matrix_unbiased = [];
dtmodel = ContentDecisionTree();
dtmodel.setDepthThreshold(depth);
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
save(['../', name, ' tree/', File, '/', num2str(number), '/dtmodel_', num2str(number), '_size_', num2str(cluster_size), '.mat'], 'dtmodel');