function plot_behav_cal(csv_id)


% --- Load CSV ------------------------------------------------------------
T           = readtable(csv_id{1});
nsubs       = height(T);


% --- Set plot params -----------------------------------------------------
figure_size             = [2 2 10 10];  % [x, y, width, height] 
ax_pos                  = [0.4 0.4 0.5 0.3];  % Axes position
line_width_individual   = 0.5;  % Line width for individual curves
line_width_average      = 2;  % Line width for average curve
color_individual        = [0.8 0.8 0.8 0.5];  % Color for individual sigmoids
color_average           = [0.6350 0.0780 0.1840 0.5];  % Color for average sigmoid
scatter_size_individual = 2;  % Scatter size for individual data points
scatter_size_average    = 5;  % Scatter size for average data points
font_size               = 8;  % Font size for axes labels
x_tick_angle            = 0;  % Angle for x-axis tick labels



% --- define linspace 
xspacemot   = -1:.001:1; % Define the coherence space
xspacecol   = 0:.001:1; % Define the color space

% --- intialise array to store sigmoids
col_sig_data = nan(numel(xspacecol),height(T));
mot_sig_data = nan(numel(xspacemot),height(T));


% for each individual 
for is =1:nsubs
    col_betas(is,:)       = [T.betaCol_1(is),T.betaCol_2(is)];
    mot_betas(is,:)       = [T.betaMot_1(is),T.betaMot_2(is)];
    
    col_cohs(is,:)        = [T.col_1(is),T.col_2(is),T.col_3(is),T.col_4(is)];
    mot_cohs(is,:)        = [T.mot_1(is),T.mot_2(is),T.mot_3(is),T.mot_4(is)];
    
    col_sig_data(:,is)    = glmval(col_betas(is,:)',xspacecol,'probit');
    mot_sig_data(:,is)    = glmval(mot_betas(is,:)',xspacemot,'probit');
    
    col_p_c_r(is,:)       = jsondecode(T.col_p_c_r{is})';
    col_coh (is,:)        = jsondecode(T.col_coh{is})';
    
    mot_p_c_r(is,:)       = jsondecode(T.mot_p_c_r{is})';
    mot_coh (is,:)        = jsondecode(T.mot_coh{is})';
    
    S(is,:)               = jsondecode(T.S{is})';
end

% get averages
col_sig_av        = glmval(mean(col_betas,1)',xspacecol,'probit');
mot_sig_av        = glmval(mean(mot_betas,1)',xspacemot,'probit');
col_cohs_av      = mean(col_cohs,1);
mot_cohs_av      = mean(mot_cohs,1);
S_av             = mean(S,1);

% flip em: want plotting axis aligned with matrix
col_sig_data        = col_sig_data';
mot_sig_data        = mot_sig_data';





%% Plots
% --- Colour figure -------------------------------------------------------
figure;
% set(gcf, 'Units', 'centimeters', 'Position', figure_size);  % Set figure size
% ax2 = axes("Position", ax_pos, "Units", "normalized");
% hold(ax2, 'on');  % Ensure plotting happens on ax2
hold on;

% -- Individual
plot(xspacecol, col_sig_data, 'LineWidth', line_width_individual, 'Color', color_individual); 
scatter(col_coh, col_p_c_r, scatter_size_individual, color_individual(1:3), 'filled', 'MarkerEdgeColor', 'none');  % Marker color using RGB part of the color

% --- Average
plot(xspacecol, col_sig_av, 'LineWidth', line_width_average, 'Color', color_average); 
scatter(col_cohs_av, S_av, scatter_size_average, color_average(1:3)); 

ylabel('P(Choose red)')
xlabel('Colour Coherance')
set(gca, 'FontSize', font_size);
xtickangle(x_tick_angle);
title('SuppFigure.1-B')
saveas(gcf, ['..\5_Figs\SuppFigure1B.fig']);


% --- Motion figure -------------------------------------------------------
figure;
% set(gcf, 'Units', 'centimeters', 'Position', figure_size);  % Set figure size
% ax2 = axes("Position", ax_pos, "Units", "normalized");
% hold(ax2, 'on');  % Ensure plotting happens on ax2
hold on;

% -- Individual
plot(xspacemot, mot_sig_data, 'LineWidth', line_width_individual, 'Color', color_individual); 
scatter(mot_coh, mot_p_c_r, scatter_size_individual, color_individual(1:3), 'filled', 'MarkerEdgeColor', 'none');

% --- Average
plot(xspacemot, mot_sig_av, 'LineWidth', line_width_average, 'Color', color_average); 
scatter(mot_cohs_av, S_av, scatter_size_average, color_average(1:3)); 

ylabel('P(Choose right)')
xlabel('Motion Coherance')
set(gca, 'FontSize', font_size);
xtickangle(x_tick_angle);
title('SuppFigure.1-C')

saveas(gcf, ['..\5_Figs\SuppFigure1C.fig']);

