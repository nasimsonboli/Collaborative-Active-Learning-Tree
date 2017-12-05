classdef ContentDecisionTree<handle

    properties
        % U*I Rating sparse Matrix
        UI_matrix;    
        generated_rating_matrix;
        
        % Tree Info
        cur_depth = 1;
        cur_node = 1;
        node_num = 0;
        depth_threshold;
        user_cluster;         % Cell
        candi_user_num = 0;   % Candidata user number
        % user_id;            % Array
        split_cluster;        % Cell {
                              %     [cluster ind 1]
                              %     [cluster ind 2/3/4]                              
                              % }
        tree;                 % Array of movie index  [....]
        tree_bound;           % Node bound for each level of the tree, Cell
        interval_bound;       % Bound for each node's interval
        user_cluster_id;      % Id of user clusters in the cell
    end

    methods
        function loadUIRatingMatrix(obj, UI_matrix_train)
            obj.UI_matrix = single(full(UI_matrix_train));
            item_num = size(obj.UI_matrix, 2);
            obj.tree = uint32(linspace(1, item_num, item_num));
            obj.tree_bound{obj.cur_depth} = {[1, item_num]};
        end
        function setDepthThreshold(obj, threshold)
            obj.depth_threshold = threshold;
            for i = 0:obj.depth_threshold-1
                obj.node_num = obj.node_num + 3^i;
            end
        end
        function loadUserCluster(obj, clusters)
            obj.user_cluster = clusters;
            clear cluters
            obj.user_cluster_id = uint32(linspace(1, size(obj.user_cluster, 2), size(obj.user_cluster, 2)));
            for i = 1:size(obj.user_cluster, 2)
                obj.candi_user_num = obj.candi_user_num + size(obj.user_cluster{i}, 2);
            end
        end
        function init(obj, UI_matrix_train, item_sim_matrix, clusters)
            obj.loadUIRatingMatrix(UI_matrix_train);
            disp('Load UI_matrix done!');       
            obj.loadUserCluster(clusters);
            disp('Load User Cluster Done!');               
            obj.generated_rating_matrix = (obj.UI_matrix(:, :) == 0) .* (obj.UI_matrix(:, :)*item_sim_matrix(:, :));
            obj.generated_rating_matrix = (obj.generated_rating_matrix) ./ ((obj.UI_matrix(:, :) ~= 0) * item_sim_matrix(:, :));
            disp('Generated Matrix Done!');
        end
        function generateDecisionTree(obj, tree_bound_for_node, candidate_user_cluster_id, candidate_user_num)
            num_candidate_cluster = size(candidate_user_cluster_id, 2);
%             fprintf('level %d:\n', obj.cur_depth);
            
            % Termination condition
            obj.cur_depth = obj.cur_depth + 1;
            if (obj.cur_depth > obj.depth_threshold) || (num_candidate_cluster == 0)
                return
            end
            
            % Calculation Preparation
            id_array = zeros(1, candidate_user_num);
            index_cell = cell(1, num_candidate_cluster);
            item_in_node = obj.tree(tree_bound_for_node(1):tree_bound_for_node(2));
            front = 1;
            for i = 1:num_candidate_cluster
                userid = obj.user_cluster{candidate_user_cluster_id(i)};
                rear = size(userid, 2) + front - 1;
                index_cell{i} = linspace(front, rear, size(userid, 2)); 
                id_array(front:rear) = userid;
                front = rear + 1;
            end

            rating_for_item_in_node = obj.UI_matrix(id_array, item_in_node) + obj.generated_rating_matrix(id_array, item_in_node);
               
            %% Calculate Error
            tmp_UI_matrix_in_node = obj.UI_matrix(:, item_in_node);
            min_error = -1;
            for i = 1:num_candidate_cluster
                item_average_rating = mean(rating_for_item_in_node(index_cell{i}, :), 1);
                [afts, ind] = sort(item_average_rating);
                interval1 = item_average_rating(ind(round(size(ind, 2)/3)));
                interval2 = item_average_rating(ind(round(2*size(ind, 2)/3))); 
                dislike_array = tmp_UI_matrix_in_node(:, item_average_rating <= interval1);
                mediocre_array = tmp_UI_matrix_in_node(:, item_average_rating > interval1 & item_average_rating <= interval2);
                like_array = tmp_UI_matrix_in_node(:, item_average_rating > interval2);
                error = sum(sum(dislike_array.^2, 2)-(sum(dislike_array, 2).^2)./(sum(dislike_array~=0, 2)+1e-9)) + ...
                    sum(sum(mediocre_array.^2, 2)-(sum(mediocre_array, 2).^2)./(sum(mediocre_array~=0, 2)+1e-9)) + ...
                    sum(sum(like_array.^2, 2)-(sum(like_array, 2).^2)./(sum(like_array~=0, 2)+1e-9));
%                 fprintf('%d, %d, %d\n', size(dislike_array, 2), size(mediocre_array, 2), size(like_array, 2));
                if min_error == -1 || error < min_error
                    min_error = error;
                    min_interval1 = interval1;
                    min_interval2 = interval2;
                    min_usr_cluster_id = i;
                    min_item_average_rating = item_average_rating;
                end
            end
            clear tmp_UI_matrix_in_node;
            %fprintf('    Calculate error finished!\n');
            clear rating_for_item_in_node;
            clear item_average_rating;
            %% Assign Children Node
            dislike_array = item_in_node(min_item_average_rating <= min_interval1);
            mediocre_array = item_in_node(min_item_average_rating > min_interval1 & min_item_average_rating <= min_interval2);
            like_array = item_in_node(min_item_average_rating > min_interval2);
            obj.tree(tree_bound_for_node(1):tree_bound_for_node(2)) = [dislike_array, mediocre_array, like_array];
            bound1 = tree_bound_for_node(1)+size(dislike_array, 2)-1;
            bound2 = bound1 + size(mediocre_array, 2);
            bound3 = bound2 + size(like_array, 2);
            if size(obj.tree_bound, 2) < obj.cur_depth
                obj.tree_bound{obj.cur_depth} = {[tree_bound_for_node(1), bound1]};
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound1+1, bound2]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound2+1, bound3]];
                obj.split_cluster{obj.cur_depth-1} = candidate_user_cluster_id(min_usr_cluster_id);
                obj.interval_bound{obj.cur_depth-1} = {[min_interval1, min_interval2]};
            else
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [tree_bound_for_node(1), bound1]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound1+1, bound2]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound2+1, bound3]];
                obj.split_cluster{obj.cur_depth-1} = [obj.split_cluster{obj.cur_depth-1}, candidate_user_cluster_id(min_usr_cluster_id)];
                obj.interval_bound{obj.cur_depth-1} = [obj.interval_bound{obj.cur_depth-1}, [min_interval1, min_interval2]];
            end
            %% Child Nodes Recursion
            candidate_user_num = candidate_user_num - size(index_cell{min_usr_cluster_id}, 2);
            candidate_user_cluster_id(min_usr_cluster_id) = [];
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}{end-2}, candidate_user_cluster_id, candidate_user_num);    % dislike node
            obj.cur_depth = obj.cur_depth - 1;
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}{end-1}, candidate_user_cluster_id, candidate_user_num);    % mediocre node
            obj.cur_depth = obj.cur_depth - 1;
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}{end}, candidate_user_cluster_id, candidate_user_num);      % like node
            obj.cur_depth = obj.cur_depth - 1;
            
            obj.cur_node = obj.cur_node + 3;
            fprintf('Current depth: %d        %.2f%%\n', obj.cur_depth, 100*obj.cur_node/obj.node_num);
        end
        function buildTree(obj)
            obj.generateDecisionTree(obj.tree_bound{1}{1}, obj.user_cluster_id, obj.candi_user_num);
        end
    end
    
end

