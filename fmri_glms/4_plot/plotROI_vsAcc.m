function  plotROI_vsAcc(csv_id,varIDs,xnames,ynames,tit)
% simple function to plot ROI information, MKW 2022
%
%
%
%%

% --- Load CSV ------------------------------------------------------------
T_all          = readtable(csv_id{1});

% --- Get columns to plot
for i = 1:numel(varIDs)
    ID = varIDs{i};
    T.(ID) = T_all.(ID);
end

ncol        = numel(varIDs);
nsubs       = height(T.(ID));
subCol      = cbrewer('qual','Set2',nsubs);


% --- Set plot params -----------------------------------------------------
figure_size             = [2 2 20 20; 2 2 10 10;2 2 10 10];  % [x, y, width, height] 
ax_pos                  = [0.4 0.4 0.5 0.5];  % Axes position
jitter                  = 0.1;  % Adjust for how much you want the points to spread
colors                  = lines(nsubs);  % Generate unique colors for each subject
scatter_size_individual = 2;  % Scatter size for individual data points
scatter_size_group      = 2; 
fontstyle               = 'Times New Roman';
fontsize                = 14;
horz_align              = 'center';

    
% --- PLot figure     -----------------------------------------------------
figure;
% set(gcf, 'Units', 'centimeters', 'Position', figure_size(1,:));  % Set figure size
% ax2 = axes("Position", ax_pos, "Units", "normalized");
% hold(ax2, 'on');  % Ensure plotting happens on ax2
hold on;
title(tit);

data1 = T.(varIDs{1});
data2 = T.(varIDs{2});

% scatter plot
scatter(data1,data2)

% Correlation
[r, p] = corr(data1, data2);
text_x = min(data1) + 0.05 * range(data1);  % X position for text
text_y = min(data2) + 0.95 * range(data2);  % Y position for text
text(text_x, text_y, sprintf('r= %.3f p= %.3f', r, p), ...
    'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');

% Line of besst fit
p       = polyfit(data1, data2, 1);  % First degree polynomial (linear fit)
y_fit   = polyval(p, data1);
plot(data1, y_fit, 'r-', 'LineWidth', 1.5);  % Plot the line of best fit

% xlabel(varIDs{1})
% ylabel(varIDs{2})
xlabel(xnames)
ylabel(ynames)
set(gca, 'FontSize', fontsize);


saveas(gcf, ['..\5_Figs\',tit,'.fig']);
% plot2svg([pwd '\5_Figs\',tit,'.svg']);
