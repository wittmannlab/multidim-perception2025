% prep work space:
beep off;format short g;
fs = filesep;
addpath(['..' fs 'utils'])
addpath(['..' fs '3_out']);
clear filepath


% --- Plot Calibration ----------------------------------------------------
% SuppFigure.1-B
% SuppFigure.1-C
filepath{1} = fullfile(['..' fs '3_out' fs 'behav_cal_17-Oct-2024.csv']); % load data
plot_behav_cal(filepath);


% --- Plot Catch ----------------------------------------------------
% SuppFigure.3-B
% SuppFigure.3-C
% SuppFigure.8-A
% SuppFigure.8-B
filepath{1} = fullfile(['..' fs '3_out' fs 'behav_rs_pcCorrect_17-Oct-2024.csv']); % load data
filepath{2} = fullfile(['..' fs '3_out' fs 'behav_rs_glm_17-Oct-2024.csv']); % load data
filepath{3} = fullfile(['..' fs '3_out' fs 'behav_rs_ED_tt01_04-Mar-2025.csv']); % load data
filepath{4} = fullfile(['..' fs '3_out' fs 'behav_rs_ED_tt2_04-Mar-2025.csv']); % load data
plot_behav_rs(filepath);

% --- Plot Ratings ----------------------------------------------------
% Figure.1-D
% SuppFigure.4-B
% SuppFigure.4-C

filepath{1} = fullfile(['..' fs '3_out' fs 'behav_rat_matrix_17-Oct-2024.csv']); % load data
filepath{2} = fullfile(['..' fs '3_out' fs 'behav_rat_mds_17-Oct-2024.csv']); % load data
filepath{3} = fullfile(['..' fs '3_out' fs 'behav_rat_glm_22-Oct-2024.csv']); % load data
plot_behav_rat(filepath);








