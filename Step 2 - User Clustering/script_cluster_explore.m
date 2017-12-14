%% load 
% UI_matrix_train 

%% Pre-calculate distance matrix
name = '20m';
distance = dist_overlap(UI_matrix_train);

%% eliminate users with zero ratings within training set
[userNum, itemNum] = size(UI_matrix_train);
zero_users = find(sum(UI_matrix_train, 2)==0);
ratingNum = sum(sum(UI_matrix_train~=0));
%% generate cluster
maxSize = 40;
real_rating_avg = zeros(1, maxSize); 
variance = zeros(1, maxSize);
for i = 1:maxSize
    clusterNum = round(userNum/i);
    disp(['average size: ', num2str(i)])
    cluster_matrix = zeros(clusterNum, itemNum);
    clusters = k_medoid(distance, clusterNum);
    for j = 1 : clusterNum
        single_cluster_matrix = UI_matrix_train(clusters{j}, :);
        avg_cluster_matrix = sum(single_cluster_matrix, 1) ./ (1e-9 + sum((single_cluster_matrix~=0), 1));
        variance_cluster_matrix = ...
            sum((single_cluster_matrix - repmat(avg_cluster_matrix, length(clusters{j}), 1)).^2, 1) ...
                 ./ ...
            (avg_cluster_matrix + 1e-9);
        cluster_matrix(j, :)  = variance_cluster_matrix;
    end
    real_rating_avg(1, i) = sum(sum(cluster_matrix~=0))/(clusterNum * itemNum);
    variance(1, i) = sum(sum(cluster_matrix))/sum(sum(cluster_matrix~=0));
end

plot([1:maxSize], real_rating_avg,'-o');
title(['Possibility of real rating elicitation'])
ylabel('p');
xlabel('average size of cluster');
set(gcf, 'Color' , 'w'  );

plot([1:maxSize], variance,'-o');
title(['variance of different size of cluster'])
ylabel('variance');
xlabel('average size of cluster');
set(gcf, 'Color' , 'w'  );