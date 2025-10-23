function plot_cal_sim



% MATLAB code to draw 4 normal distributions with vertical lines at the mean
% and shaded area representing p(choose left) and p(choose right)

x = linspace(-6.5, 6.5, 1000);  % Define x-axis values

pedaldist = 0.1;

% get internal sensory means as per calibration
s(1) = norminv(1-pedaldist);
s(4) = norminv(pedaldist);

D = (s(4) - s(1))/6;
s(2) = -D;
s(3) = D;

S(1)    = 1-normcdf(s(1));
S(2)    = 1-normcdf(s(2));
S(3)    = 1-normcdf(s(3));
S(4)    = 1-normcdf(s(4));



means = s;  % Define the means of the distributions
sigma = 1;  % Standard deviation (unit SD)

% Define a color map
colors = lines(4);  % Use MATLAB's built-in 'lines' colormap for consistency

figure_size = [2 2 10 10];  % [x, y, width, height] 
ax_pos = [0.4 0.4 0.5 0.3];  % Axes position

figure;
set(gcf, 'Units', 'centimeters', 'Position', figure_size);  % Set figure size

% Initialize variables to store handles for legend
fill_handles = [];

for i = 1:length(means)
    subplot(4, 1, i);
    hold on;
    mu = means(i);
    y = normpdf(x, mu, sigma);  % Calculate normal distribution
    plot(x, y, 'LineWidth', 1, 'Color', 'k');  % Plot the distribution
    
    % Shade the area under the curve for p(choose right) (x >= 0)
    x_shaded_right = x(x >= 0);  % Take values greater than or equal to the mean
    y_shaded_right = normpdf(x_shaded_right, mu, sigma);  % Corresponding y values
    h_right = fill([x_shaded_right, fliplr(x_shaded_right)], [y_shaded_right, zeros(1, length(y_shaded_right))], ...
         [0.9290 0.6940 0.1250], 'FaceAlpha', 0.8);  % Shaded in orange color
     
    % Shade the area under the curve for p(choose left) (x <= 0)
    x_shaded_left = x(x <= 0);  % Take values less than or equal to the mean
    y_shaded_left = normpdf(x_shaded_left, mu, sigma);  % Corresponding y values
    h_left = fill([x_shaded_left, fliplr(x_shaded_left)], [y_shaded_left, zeros(1, length(y_shaded_left))], ...
         [0.4940 0.1840 0.5560], 'FaceAlpha', 0.8);  % Shaded in purple color
    
    % Vertical line at the mean
    line([mu mu], [0 max(y)], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
    
    % Vertical line at 0
    line([0 0], [0 max(y)], 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1.5);
    
    % Label the mean on each subplot
    if i == 1
        text(0 + 0.25, max(y) * 0.9, 'c = 0', 'FontSize', 10, 'Color', 'k');
    end
    
    text(mu + 0.0, max(y) * 1.1, ['s(', num2str(i), ')'], 'FontSize', 8, 'Color', 'k');
    
    % Additional plot settings
    xlim([-6.5, 6.5]);
    yticks([]);
    
    % if i ==1
    %     xticks([means(i)])
    %     xticklabels({'-D/2'})
    % elseif i==2
    %     xticks([means(i)])
    %     xticklabels({'-D/6'})
    % elseif i==3
    %     xticks([means(i)])
    %     xticklabels({'D/6'})
    % elseif i==4
    %     xticks([means(i)])
    %     xticklabels({'D/2'})
    % end
    
    % Store handles for the shaded regions to use in the legend
    fill_handles = [fill_handles, h_left, h_right];
end

% Adding one shared ylabel for all subplots
han = axes(gcf, 'visible', 'off');  % Create invisible axes
han.YLabel.Visible = 'on';
ylabel(han, 'Probability Density', 'FontSize', 12, 'Units', 'normalized', 'Position', [-0.08, 0.5, 0]);  % Adjust position of ylabel

han.XLabel.Visible = 'on';
xlabel(han, 'Internal sensory evidence', 'FontSize', 12, 'Units', 'normalized', 'Position', [0.5, -0.08, 0]);  % Adjust position of ylabel

xlabel('Internal sensory evidence');


saveas(gcf, ['..\5_Figs\cal_methods_A.fig']);


%%
% MATLAB code to plot the Normal CDF

%%
% MATLAB code to plot the Normal CDF

x = linspace(-1, 1, 1000);  % Define the range of x values
mu = 0;  % Mean of the normal distribution
sigma = 0.3;  % Standard deviation of the normal distribution

% Calculate the CDF using the normcdf function
y = normcdf(x, mu, sigma);

% Plot the CDF
figure;
set(gcf, 'Units', 'centimeters', 'Position', [2 2 10 6]);  % Set figure sizeplot(x, y, 'LineWidth', 2);  % Plot the CDF

hold on
plot(x, y, 'LineWidth', 2,'Color','k');

% Add labels and title
xlabel('Coherence');
ylabel('P(Choose right)');

% Define four equally spaced points on the x-axis
x_points = linspace(-1, 1, 4);
y_points = normcdf(x_points, mu, sigma);  % Corresponding CDF values

% Plot the points as dots on the CDF
hold on;

plot(x_points, 0, 'xk', 'MarkerSize', 8, 'MarkerFaceColor', 'k');  % Plot the points

for i = 1:4
    plot(x_points(i), y_points(i), 'o', 'Color',colors(i,:),'MarkerSize', 10);  % Plot the points

    % Add vertical line from x-axis to the point
    line([x_points(i), x_points(i)], [0, y_points(i)], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 0.2);
    
    % Add horizontal line from y-axis to the point
    line([-1, x_points(i)], [y_points(i), y_points(i)], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 0.2);
end

yticks([0:0.1:1])
yticklabels({'0','','0.2','','0.4','','0.6','','0.8','','1'})

% legend(legend_labels);
hold off;



% Add the legend for the shaded areas
legend(fill_handles([1 2]), {'p(choose left)', 'p(choose right)'});

saveas(gcf, ['..\5_Figs\cal_methods_B.fig']);


%% MATLAB code to draw 4 circles spaced along the x-axis with varying diameters

% Define circle properties
diameters = [1,1,1,1];  % Diameters of the circles
x_positions = linspace(-10, 10, 4);  % X positions of the circle centers
y_position = 0;  % Y position of all circles (same for all)

% Create a figure
figure;
set(gcf, 'Units', 'centimeters', 'Position', [2 2 10 3]);  % Set figure sizeplot(x, y, 'LineWidth', 2);  % Plot the CDF

% Loop to draw each circle
hold on;
for i = 1:length(diameters)
    % Create the circle
    theta = linspace(0, 2*pi, 100);  % Parametric angle for circle
    x = diameters(i)/2 * cos(theta) + x_positions(i);  % X coordinates
    y = diameters(i)/2 * sin(theta) + y_position;  % Y coordinates
    
    % Plot the circle
    plot(x, y, 'Color',colors(i,:),'LineWidth', 2);  % Draw the circle
end

% Formatting the figure
axis equal;  % Equal scaling for both axes
set(gca, 'XTick', [], 'YTick', []);  % Remove x and y ticks
xlabel('Coherence');  % Optional: Label for clarity
% ylabel('Y-Axis');
hold off;


% Turn off only the y-axis
set(gca, 'YColor', 'none');

saveas(gcf, ['..\5_Figs\cal_methods_C.fig']);
