%% Load
% load four feature similarity matrix
% load UI_matrix_train
tic;
name = '20m';
%%
title = [];
title_den = [];
tag = [];
tag_den = [];
year = [];
year_den = [];
genre = [];
genre_den = [];
real_rating = [];
[userNum, itemNum] = size(UI_matrix_train);
item_id_random = randperm(itemNum);

startPos = 1;
endPos = int32(itemNum*0.1);

startPos_u = 1;
endPos_u = int32(userNum/3);

for j = 1:3
    UI_matrix = single(full(UI_matrix_train(startPos_u : endPos_u, :)));
    for i = 1:10
        disp(['startPos: ', num2str(startPos)])
        disp(['endPos: ', num2str(endPos)])
        test = item_id_random(startPos : endPos); 
        train = item_id_random;
        train(ismember(train, test))=[];    
        % Eliminate users who don't have rating within train items.
        UI_matrix_chosen = UI_matrix(sum(UI_matrix(:, train),2)~=0, :);

        %% title
        title = [title; calInput_nominator( UI_matrix_chosen, title_matrix, train, test )];
        title_den = [title_den; calInput_denominator( UI_matrix_chosen, title_matrix, train, test )];
        % clear title_matrix
        disp('title done!')

        %% tag
        tag = [tag; calInput_nominator( UI_matrix_chosen, tag_matrix, train, test )];
        tag_den = [tag_den; calInput_denominator( UI_matrix_chosen, tag_matrix, train, test )];
        % clear tag_matrix
        disp('tag done!')

        %% year
        year = [year; calInput_nominator( UI_matrix_chosen, year_matrix, train, test )];
        year_den = [year_den; calInput_denominator( UI_matrix_chosen, year_matrix, train, test )];
        % clear year_matrix
        disp('year done!')

        %% genre
        genre = [genre; calInput_nominator( UI_matrix_chosen, genre_matrix, train, test )];
        genre_den = [genre_den; calInput_denominator( UI_matrix_chosen, genre_matrix, train, test )];
        % clear genre_matrix
        disp('genre done!')

        %% real rating
        UI_matrix_validation = UI_matrix_chosen(:, test);
        real_rating = [real_rating; UI_matrix_validation(UI_matrix_validation~=0)];
        disp('real rating done!')

        startPos = endPos + 1;
        if i == 9        
            endPos = itemNum;
        else
            endPos = endPos + int32(itemNum*0.1);
        end
        clear UI_matrix_chosen
    end    
    clear UI_matrix
    startPos_u = endPos_u + 1;
    if i == 2        
        endPos_u = userNum;
    else
        endPos_u = endPos_u + int32(userNum/3);
    end
end

save(['data/', name, '/title.mat'], 'title', '-v7.3');
save(['data/', name, '/title_den.mat'], 'title_den', '-v7.3');
save(['data/', name, '/tag.mat'], 'tag', '-v7.3');
save(['data/', name, '/tag_den.mat'], 'tag_den', '-v7.3');
save(['data/', name, '/year.mat'], 'year', '-v7.3');
save(['data/', name, '/year_den.mat'], 'year_den', '-v7.3');
save(['data/', name, '/genre.mat'], 'genre', '-v7.3');
save(['data/', name, '/genre_den.mat'], 'genre_den', '-v7.3');
save(['data/', name, '/real_rating.mat'], 'real_rating', '-v7.3');
disp('save DONE');
toc;
