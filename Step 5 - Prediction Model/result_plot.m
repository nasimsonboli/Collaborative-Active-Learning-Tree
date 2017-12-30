%% RMSE and lambda
% plot([0.005, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15], rmse_list,'-o');
% % title(['Depth versus RMSE']);
% ylabel('RMSE');
% xlabel('\lambda');
% set(gcf, 'Color' , 'w'  );

%% RMSE and different models
% c = categorical({'1m Dataset', '20m Dataset'});
% y = [0.9200 0.9286 0.9829 1.0010 1.1013; 0 0.8780 0.8939 0.9484 1.0850];
% bar(c, y);
% label = legend('ACDT(stratification)',...
%     'ACDT(random)', 'FDT(level5, 0.10)', 'CCF', 'CAL(regularization 5)',...
%      'location', 'best');
% ylim([0.85 1.13]);

%% RMSE and Active Learning
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

r = ['b', 'c', 'y', 'r', 'g'];

x1 = [12, 19, 26, 33, 40];
x2 = [48, 55, 62, 69, 76];
y1 = [0.9200 0.9286 1.0010 1.1013 0.9829];
y2 = [0 0.8780 0.9484 1.0850 0.8939];

for i = 1:size(x1, 2)
    x = [x1(i), x2(i)];
    y = [y1(i), y2(i)];
    h = bar(x, y, 0.12, r(i))
    hold on
end

set(gca, 'XTick', [26, 66])
set(gca, 'XTicklabel', {'1m dataset', '20m dataset'}, 'FontSize', 10)
h = gca
xlim([1 135]);
ylim([0.85 1.13]);
legend('CALT(stratification)', 'CALT(random)', ...
    'CCF', 'CAL', 'FDT');
