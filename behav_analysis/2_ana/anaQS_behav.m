% analyses behaviour of RS experiment
% MKW 2024

%---------------------------------------------------------------------------    
% prep work space:
beep off;format short g;
fs = filesep;
addpath(['..' fs 'utils'])
load(['..' fs '1_data' fs 'Data_26-Sep-2024.mat']); % load data
outpath = ['..' fs '3_out' fs];

%---------------------------------------------------------------------------    
% 1. Analysis of calibration experiment:
behav_cal(s.calibration,outpath)

%---------------------------------------------------------------------------    
% 2. Analysis of catch trials during main experiment:
behav_rs(s.sub, outpath);

%---------------------------------------------------------------------------    
% 3. Analysis of similarity ratings:
% look only at participants with data available:
rdata = {};
for is = 1:numel(s.Rat)
    if ~isempty(s.Rat{is}),rdata{end+1}=s.Rat{is}; end
end
% now run analyses
behav_rat(rdata,outpath)


