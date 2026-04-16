% prep work space:
beep off;format short g;
fs = filesep;
addpath(['..' fs 'utils'])
addpath(['..' fs '3_out']);
clear filepath


% --- Plot Calibration ----------------------------------------------------

filepath{1} = fullfile(['..' fs '3_out' fs 'behav_cal_17-Oct-2024.csv']); % load data
plot_behav_cal(filepath);


% --- Plot Catch ----------------------------------------------------

filepath{1} = fullfile(['..' fs '3_out' fs 'behav_rs_pcCorrect_17-Oct-2024.csv']); % load data
filepath{2} = fullfile(['..' fs '3_out' fs 'behav_rs_glm_17-Oct-2024.csv']); % load data
filepath{3} = fullfile(['..' fs '3_out' fs 'behav_rs_ED_tt01_04-Mar-2025.csv']); % load data
filepath{4} = fullfile(['..' fs '3_out' fs 'behav_rs_ED_tt2_04-Mar-2025.csv']); % load data
plot_behav_rs(filepath);

% --- Plot difficulty ----------------------------------------------------
clear filepath
filepath{1} = fullfile(['..' fs '3_out' fs 'behav_catchtrialdifficulty_07-Feb-2026.csv']); % load data
filepath{2} = fullfile(['..' fs '..' fs 'fmri_glms' fs '3_out' fs 'GLM01_vmPFC_Park4_m648m4_22-Oct-2025.csv']); % load data
plot_difficulty(filepath);

% --- Plot Ratings ----------------------------------------------------


filepath{1} = fullfile(['..' fs '3_out' fs 'behav_rat_matrix_17-Oct-2024.csv']); % load data
filepath{2} = fullfile(['..' fs '3_out' fs 'behav_rat_mds_17-Oct-2024.csv']); % load data
filepath{3} = fullfile(['..' fs '3_out' fs 'behav_rat_glm_22-Oct-2024.csv']); % load data
plot_behav_rat(filepath);








