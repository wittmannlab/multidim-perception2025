% analyses behaviour of RSA
% MKW 2024

%---------------------------------------------------------------------------    
% prep work space:
beep off;format short g;
fs = filesep;
addpath(['..' fs 'utils'])
outpath = ['..' fs '3_out' fs];
outpath2 = ['..' fs '5_stats' fs];


%% Load data struct
load(['..\1_data\Models_Run_2025-06-09_18-11-10.mat'])
load(['..\1_data\sRDMs_Run_2025-06-09_18-11-10.mat'])

models2run          = Models(1:2);
model_names         = {'colour model','motion model'};
roi                 = {'V4','MT'};

% --- Significance testing ------------------------------------------------
userOptions.significanceTestPermutations    = 1000; % How many permutations should be used to test the significance of the fits? 
userOptions.tails                           = 'both';
userOptions.distanceMeasure                 = 'Kendall';


%% Performs statistical inference based on park (2021)
% Compares the model RDMs with the neural RDM in each ROI
% Subject level: Correlate neural RDM with Model RDM
% Subject level: Compute 'N' permutations of neural RDM and get average corr with model rdm
% Subject level: Subtract null correlation from true correlation
% Group level: one-sample Wilcoxon signed-rank test across participants 
stats_struct = struct();
for i = 1:numel(roi)    
    stats_struct.(roi{i}) = compareRefRDM2candRDMs_cd201025(sRDMs(i,:), models2run, userOptions);
end

save(fullfile(outpath, ['RSA_stats_',date,'.mat']), 'stats_struct');
save(fullfile(outpath2, ['RSA_stats_',date,'.mat']), 'stats_struct');

