%% load 
% UI_matrix_train 

%% Pre-calculate distance matrix
name = '20m';
File = 'Trees';
number = 8;
distance = dist_overlap(UI_matrix_train);

%% eliminate users with zero ratings within training set
userNum = size(UI_matrix_train, 1);
zero_users = find(sum(UI_matrix_train, 2)==0);

%% generate cluster
cluster_size = 20;
clusters = k_medoid(distance, round(userNum/cluster_size));
for i = 1:length(clusters)
    for j = 1:length(clusters{i})
        if ismember(clusters{i}(j), zero_users)
        	clusters{i}(clusters{i}==clusters{i}(j))=0;
        end
    end
end
for i = 1:length(clusters)
    clusters{i}...
    (clusters{i}==0)=[];
end

%% Save to file
save(['../', name, ' tree/', File, '/', num2str(number), '/clusters_', num2str(number), '_size_', num2str(cluster_size), '.mat'], 'clusters');