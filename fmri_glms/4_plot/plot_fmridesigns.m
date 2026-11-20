% prep work space:
beep off;format short g;
fs = filesep;
addpath(genpath(['..' fs 'utils']))
outpath = ['..' fs '5_Figs'];
clear filepath


%% --- Plot FMRI GLM1 ----------------------------------------------------
d={};
d{1}= readtable(['..' fs '1_data' fs 'D001_correlations_05-Feb-2026.csv']); % load data
d{2}= readtable(['..' fs '1_data' fs 'D002_correlations_05-Feb-2026.csv']); % load data


% make more comprehensible labels:
lab{1}= {   'Constant 1D','1D RS (1D trials)','Motion intensity (1D trials)','Color intensity (1D trials)', ...
            'Constant 2D','2D RS (2D trials)','Motion intensity (2D trials)','Color intensity (2D trials)', 'Constant catch trial', 'Constant other RDK'};

lab{2}= {   'Constant 1D','Motion RS (1D trials)','Color RS (1D trials)', 'Motion intensity (1D trials)','Color intensity (1D trials)', ...
            'Constant 2D','Motion RS (2D trials)','Color RS (2D trials)', 'Stimulus intensity (2D trials)', 'Constant catch trial', 'Constant other RDK'};

figname = {'fMRI GLM1','fMRI GLM2'};

% figure
figure('Color','w','Units','inches','Position',[1 1 10 5]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

for ic = 1:2
    nexttile

    R = table2array(d{ic});
    R = flipud(R);

    % labels 
    labels = lab{ic};
    ylabels = labels(end:-1:1);    
  %  labels = strcat("  ", labels);  

    h = heatmap(labels, ylabels, R, ...
        'Colormap', redbluecmap, ...
        'ColorLimits', [-1 1], ...
        'CellLabelFormat','%.2f');

    % aesthetics
    h.FontSize = 9;
    h.GridVisible = 'off';
    h.Title = figname{ic};
    h.XLabel = '';
    h.YLabel = '';


end

saveas(gcf, [ '..' fs '5_Figs' fs,'Figure.5','.fig']);
