%% RMSE and lambda
% plot([0.005, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15], rmse_list,'-o');
% % title(['Depth versus RMSE']);
% ylabel('RMSE');
% xlabel('\lambda');
% set(gcf, 'Color' , 'w'  );

%% RMSE and cluster size
x = [1	 5	10	15	20	25	30	35	40];  
y = [0.976574494 0.92433706 0.914207572  0.908857282 0.905430708  0.906132816	 0.907295689	 0.908898105	 0.912320157];  
plot(x,y, '-o');  
hold on;    
x = [1	 5	10	15	20	25	30	35	40];  
y = [0.903405454 0.874860325	 0.864107398	 0.858573644	 0.858526252	 0.85724845	  0.857492558	 0.858870196	 0.859082366];  
plot(x,y, '-o');  
% title(['Depth versus RMSE']);
ylabel('RMSE');
xlabel('Size of User Cluster');
label = legend('1m', '20m');
set(gcf, 'Color' , 'w');

%% RMSE and different models
% c = categorical({'1m Dataset', '20m Dataset'});
% y = [0.9200 0.9286 0.9829 1.0010 1.1013; 0 0.8780 0.8939 0.9484 1.0850];
% bar(c, y);
% label = legend('ACDT(stratification)',...
%     'ACDT(random)', 'FDT(level5, 0.10)', 'CCF', 'CAL(regularization 5)',...
%      'location', 'best');
% ylim([0.85 1.13]);

% r = ['c', 'y', 'r', 'g'];
% 
% x1 = [19, 27, 35, 43] + 2;
% x2 = [59, 67, 75, 83] + 6;
% y1 = [0.9286 1.0010 1.1013 0.9829];
% y2 = [0.8780 0.9484 1.0850 0.8939];
% 
% for i = 1:size(x1, 2)
%     x = [x1(i), x2(i)];
%     y = [y1(i), y2(i)];
%     h = bar(x, y, 0.12, r(i))
%     hold on
% end
% 
% set(gca, 'XTick', [33, 77])
% set(gca, 'XTicklabel', {'1m dataset', '20m dataset'}, 'FontSize', 10)
% h = gca
% xlim([1 135]);
% ylim([0.85 1.13]);
% legend('CALT', 'CCF', 'CAL', 'FDT');

% RMSE and Active Learning
% rmse_list = [
%     0.87035870983 
%     0.874766174811
%     0.885536687708
%     0.90327066476
%     0.92419338281
%     0.939945107362
%     0.941642125195
%     0.947759209605
%     ];
% y = rmse_list;
% bar(y, 'c');
% ylim([0.85 0.96]);
% set(gca,'xticklabel',{'508~52', '52~23', '23~12', '12~6', '6~3', '3~2', '2~1', '1~0'});,
% ylabel('RMSE');
% xlabel('Ratings Elicited');

%% RMSE between Random and Stratification
% plot([1:7], [r2; s2],'-o');
% % title(['Depth versus RMSE']);
% ylabel('RMSE');
% xlabel('Depth');
% set(gcf, 'Color' , 'w'  );
% ylim([0.92 1.03]);
% label = legend('ACDT(random)','ACDT(stratification)');

%% RMSE vs real ratings
% ratingNum_list = [
% 203062
% 259180
% 333753
% 436797
% 570745
% 766609
% 1050899
% 1514176
% 2441925
% 6338840];
% rmse_list = [
% 0.979898803174
% 0.968511626358
% 0.955002017639
% 0.945591082353
% 0.944659034128
% 0.933135365592
% 0.918745133362
% 0.90007781315
% 0.894454635882
% 0.860666568315];
% plot([1:10], rmse_list,'-o');
% % title(['Depth versus RMSE']);
% ylabel('RMSE');
% xlabel('');
% set(gcf, 'Color' , 'w'  );
