function plot_behav_rs(csv_id)


% --- Load CSV ------------------------------------------------------------
T1          = readtable(csv_id{1});
T2          = readtable(csv_id{2});
T3          = readtable(csv_id{3});
T4          = readtable(csv_id{4});
nsubs       = height(T1);

% --- Set plot params -----------------------------------------------------
figure_size             = [2 2 10 10];  % [x, y, width, height] 
ax_pos                  = [0.4 0.4 0.5 0.3];  % Axes position
jitter                  = 0.1;  % Adjust for how much you want the points to spread
colors                  = lines(nsubs);  % Generate unique colors for each subject
scatter_size_individual = 2;  % Scatter size for individual data points
scatter_size_group      = 2; 





% #########################################################################

% Extract the data for each block
B1 = T1.Block1;
B2 = T1.Block2;
B3 = T1.Block3;

% Calculate means and standard errors
means = [mean(B1), mean(B2), mean(B3)];
ses = [std(B1)/sqrt(length(B1)), std(B2)/sqrt(length(B2)), std(B3)/sqrt(length(B3))];

% --- Create the bar plot ---
figure;
hold on;

% Plot the bars
bar(1:3, means, 'FaceColor', 'none', 'EdgeColor', 'k');
errorbar(1:3, means, ses, 'k.', 'LineWidth', 1);

for i = 1:nsubs
    scatter(1 + (rand-0.5) * jitter, B1(i), scatter_size_individual, colors(i,:), 'filled');  % B1 data points
    scatter(2 + (rand-0.5) * jitter, B2(i), scatter_size_individual, colors(i,:), 'filled');  % B2 data points
    scatter(3 + (rand-0.5) * jitter, B3(i), scatter_size_individual, colors(i,:), 'filled');  % B3 data points
end

% --- Customize the plot ---
xlim([0.5, 3.5]);  % Set x-axis limits
ylim([0, 100]);  % Set y-axis limits
xticks(1:3);  % Set x-ticks
xticklabels({'Block 1', 'Block 2', 'Block 3'});  % Set x-tick labels
ylabel('% correct');  % Set y-label
title('SuppFigure.3-B')
hold off;

saveas(gcf, ['..\5_Figs\SuppFigure3B.fig']);


% #########################################################################
Int         = T2.Intercept;
colDist     = T2.ColourDistance;
motDist     = T2.MotionDistance;

% Calculate means and standard errors
means = [mean(Int), mean(colDist), mean(motDist)];
ses = [std(Int)/sqrt(length(Int)), std(colDist)/sqrt(length(colDist)), std(motDist)/sqrt(length(motDist))];


figure;
hold on;

% Plot the data points with a line connecting them
errorbar(1:3, means, ses, 'k.', 'LineWidth', 1.5);  % Error bars
plot(1:3, means, 'ko-', 'MarkerFaceColor', 'k', 'MarkerSize', scatter_size_group);  % Line with circular markers

% --- Customize the plot ---
xlim([0.8, 3.2]);  % Set x-axis limits
ylim([-0.1, 0.25]);  % Set y-axis limits
xticks(1:3);  % Set x-ticks
xticklabels({'Bias','Colour','Motion'});  % Set x-tick labels
ylabel('Effect Size');  % Y-axis label
xlabel('RM Factor 1');  % X-axis label
set(gca, 'FontSize', 12);  % Set font size for axes
title('SuppFigure.3-C')

saveas(gcf, ['..\5_Figs\SuppFigure3C.fig']);




%################# Plot the histogram #####################################
cursub = 1;

ED_tt01 = table2array(T3(T3.subno==cursub,[1]));
ED_tt2  = table2array(T4(T4.subno==cursub,[1]));

% Plot histogram========================================
% Find unique values and their frequencies
[unique_vals, ~, idx] = unique(ED_tt01);  
counts = accumarray(idx, 1);  

% Plot bar chart
figure;
bar(unique_vals, counts, 'FaceColor', 'b', 'EdgeColor', 'k');

% Formatting
xlabel('Unique Values');
ylabel('Frequency');
title('SuppFigure.8-A')
xlim([-1,5])
saveas(gcf, ['..\5_Figs\SuppFigure8A.fig']);

% Plot histogram ========================================
% Find unique values and their frequencies
[unique_vals, ~, idx] = unique(ED_tt2);  
counts = accumarray(idx, 1);  

% Plot bar chart
figure;
bar(unique_vals, counts, 'FaceColor', 'b', 'EdgeColor', 'k');

% Formatting
xlabel('Unique Values');

xlim([-1,5])
ylabel('Frequency');
title('SuppFigure.8-B')
saveas(gcf, ['..\5_Figs\SuppFigure8B.fig']);



