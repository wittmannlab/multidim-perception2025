function plot_behav_rat(csv_id)


% --- Load CSV ------------------------------------------------------------
T1          = readtable(csv_id{1});
T1_mat      = table2array(T1(1:end,2:end));

T2          = readtable(csv_id{2});
T2_mat      = table2array(T2(1:end,1:end));

T3          = readtable(csv_id{3});

nsubs       = height(T1);

% --- Set plot params -----------------------------------------------------
figure_size             = [2 2 20 20; 2 2 20 20;2 2 10 10];  % [x, y, width, height] 
ax_pos                  = [0.4 0.4 0.5 0.5];  % Axes position
jitter                  = 0.1;  % Adjust for how much you want the points to spread
colors                  = lines(nsubs);  % Generate unique colors for each subject
scatter_size_individual = 2;  % Scatter size for individual data points
scatter_size_group      = 2; 
fontstyle               = 'Times New Roman';
fontsize                = 14;
horz_align              = 'center';
arrow.mags        = [10,14];
arrow.greens      = [0.4660 0.6740 0.1880; 0.4660 0.6740 0.3];
arrow.reds        = [0.6350 0.0780 0.1840; 0.6350 0.0780 0.3];
arrow.dirs        = {'$\leftarrow$','$\rightarrow$'};


% Prepare labels
[coind,moind] = dimTrans([],[],1:16);
[~,~,bothlab] = getStimLabels(coind,moind);



        
% ########################################################################
figure;

imagesc(T1_mat);  % Use imagesc to display a scaled version of data as a heatmap
heatmap(bothlab,bothlab,T1_mat,'Colorlimits',[-1.0 1.0]); title('Overall stim distance (same-->diff)'); xlabel('t1'); ylabel('t2');
% heatmap(T1_mat,'Colorlimits',[-1.0 1.0]); title('Overall stim distance (same-->diff)'); xlabel('t1'); ylabel('t2');

colormap('summer');  % Set the colormap (you can change this to 'hot', 'jet', etc.)
colorbar;  % Show the colorbar on the right

ylabel('Stimulus 1');
xlabel('Stimulus 2');

% Move the axis titles
h_xlabel.Position = [8, -2, 0]; % Move X-axis title: [x, y, z]
h_ylabel.Position = [-2, 8, 0]; % Move Y-axis title: [x, y, z]

title('SuppFigure.4-B')
set(gca, 'FontSize', fontsize);
saveas(gcf, ['..\5_Figs\SuppFigure4B.fig']);



%% ########################################################################
figure;
hold on


[coind,moind]   = dimTrans([],[],1:16);
labs = [coind;moind;1:16]';
opacity = 0.0;


OPTS.big_r      = 5;
OPTS.small_r    = 0.25;
OPTS.grid_size  = [4,4];
OPTS.spacing    = 2.5;
OPTS.n          = 300;
OPTS.colgradient = [0,0.25,0.75,1];
OPTS.motgradient = [-1,-0.5,0.5,1];
OPTS.specific_trajectory = 0;
OPTS.draw_border = [4,5,6,14];
OPTS.b_thick    = 2;%/4;
OPTS.b_col      = 'k';

T2_mat_scaled = T2_mat;

% Iterate over the points
for ip = 1:size(T2_mat, 1)
    [a_dir,a_mag,a_col] = get_arrow(bothlab(ip),arrow);
     assign_label([T2_mat(ip,1),T2_mat(ip,2)],a_dir,a_mag,a_col,fontstyle,horz_align)
          
     % Plot black dot at the center of each large circle
     plot(T2_mat_scaled(ip,1), T2_mat_scaled(ip,2), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5);
end

xticks([]);
yticks([]);
xticklabels([]);
yticklabels([]);
axis equal;
axis on

% Get the current limits
xLimits = xlim;
yLimits = ylim;

% Add a border by padding the limits
padding = 0.05*(xLimits(2)-xLimits(1)); % Adjust this value to change the size of the border

xlim([xLimits(1) - padding, xLimits(2) + padding]);
ylim([yLimits(1) - padding, yLimits(2) + padding]);

xlabel('MDS-Motion Dimension')
ylabel('MDS-Colour Dimension')
title('Figure.1-D')

% saveas(gcf, ['..\5_Figs\mds_rat.fig']);
exportgraphics(gcf,'..\5_Figs\FIGURE1D.pdf','ContentType','vector')


%% ##########################################################################
Int         = T3.difference_bias;
colDist     = T3.ColorDist;
motDist     = T3.MotionDist;

% Calculate means and standard errors
means = [mean(Int), mean(colDist), mean(motDist)];
ses = [std(Int)/sqrt(length(Int)), std(colDist)/sqrt(length(colDist)), std(motDist)/sqrt(length(motDist))];


figure;
hold on

% Plot the data points with a line connecting them
errorbar(1:3, means, ses, 'k.', 'LineWidth', 1.5);  % Error bars
plot(1:3, means, 'ko-', 'MarkerFaceColor', 'k', 'MarkerSize', scatter_size_group);  % Line with circular markers

% --- Customize the plot ---
xlim([0.8, 3.2]);  % Set x-axis limits
ylim([-0.1, .525]);  % Set y-axis limits
xticks(1:3);  % Set x-ticks
xticklabels({'Bias','Colour','Motion'});  % Set x-tick labels
ylabel('Effect Size');  % Y-axis label
% xlabel('RM Factor 1');  % X-axis label
set(gca, 'FontSize', 12);  % Set font size for axes
title('SuppFigure.4-C')
saveas(gcf, ['..\5_Figs\SuppFigure4C.fig']);






function assign_label(pos,dir,fontsize,col,fontstyle,horz_align)
    text(pos(1), pos(2), dir, 'FontSize', fontsize, 'Color', col, 'FontName', fontstyle, 'HorizontalAlignment', horz_align, 'Interpreter', 'latex');
end

function [a_dir,a_mag,a_col] = get_arrow(bothlab,arrow)
    for i = 1:numel(bothlab)
        current_string = bothlab{i};

        % Determine the direction based on the arrow symbols
        if contains(current_string, '<')
            a_dir = arrow.dirs{1};
        else
            a_dir = arrow.dirs{2};
        end

        if contains(current_string, '--')
            a_mag = arrow.mags(2);
        else
            a_mag = arrow.mags(1);
        end

        if contains(current_string, 'gg')
            a_col = arrow.greens(2,:);
        elseif contains(current_string, 'g')
            a_col = arrow.greens(1,:);
        elseif contains(current_string, 'rr')
            a_col = arrow.reds(2,:);
        elseif contains(current_string, 'r')
            a_col = arrow.reds(1,:);
        end
    end
end

end


