% analyses behaviour of RS experiment
% MKW 2024

%---------------------------------------------------------------------------    
% prep work space:
beep off;format short g;
fs = filesep;
addpath(['..' fs 'utils'])
load(['..' fs '1_data' fs 'BehavData_08-Nov-2024.mat']); % load data
outpath = ['..' fs '3_out' fs];

%---------------------------------------------------------------------------    
%% 1. Analysis of FMRI GLM:1
GLM01 = load(['..' fs '1_data' fs 'ROIData_GLM01_08-Nov-2024.mat']); % load data
ROI2plot    = 'vmPFC';
CONs        = [2,6,11,12];

% --- Get the data
data        = GLM01.D.roi.(ROI2plot).B(:,CONs);
con_names   = GLM01.D.Bnames(CONs);

% --- Save the data to a csv
cur_roi_table               = array2table(data, 'VariableNames', con_names);
cur_roi_table.accuracy      = (mean(s.accuracy,2));
writetable(cur_roi_table, [outpath, 'GLM01_vmPFC_Park4_m648m4_' date '.csv']);

%----------------------------------------------------------    
%% 2. Analysis of FMRI GLM:2
GLM02 = load(['..' fs '1_data' fs 'ROIData_GLM02_08-Nov-2024.mat']); % load data
ROIs2plot   = {'vmPFC','lITG','rITG'};
CONs        = [2,3,7,8];

for ir = 1:numel(ROIs2plot)
    roi = ROIs2plot{ir};
    
    % --- Get the data
    data        = GLM02.D.roi.(roi).B(:,CONs);
    con_names   = GLM02.D.Bnames(CONs);

    % --- Save the data to a csv
    cur_roi_table   = array2table(data, 'VariableNames', con_names);
    writetable(cur_roi_table, [outpath, 'GLM02_',roi,'_' date '.csv']);
end
