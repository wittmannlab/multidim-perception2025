% prep work space:
beep off;format short g;
fs = filesep;
addpath(genpath(['..' fs 'utils']))
addpath(genpath(['..' fs '3_out']))
clear filepath

date_in = date;

%% --- Plot FMRI GLM1 ----------------------------------------------------
filepath{1} = fullfile(['..' fs '3_out' fs 'GLM01_vmPFC_Park4_m648m4_',date_in,'.csv']); % load data

% --- Figure.2-C
varIDs = {'ED_1d','ED_2d'};
xnames = {'RS(1D)','RS(2D)'};
ynames = {'RS Effect size'};
tit    = ['Figure.2-C'];
ylm     = [-2,4];
plotROI_bar_cd(filepath,varIDs,xnames,ynames,ylm,tit)

% --- Figure.2-D
varIDs = {'ED_1d','accuracy'};
xnames = {'RS(1D)'};
ynames = {'Choice accuracy'};
tit    = ['Figure.2-D'];
plotROI_vsAcc(filepath,varIDs,xnames,ynames, tit)

% --- Figure.2-E
varIDs = {'ED_2d','accuracy'};
xnames = {'RS(2D)'};
ynames = {'Choice accuracy'};
tit    = ['Figure.2-E'];
plotROI_vsAcc(filepath,varIDs,xnames,ynames, tit)


%% --- Plot FMRI GLM2: ----------------------------------------------------
% --- Figure.2-G
filepath{1} = fullfile(['3_out' fs 'GLM02_vmPFC_',date_in,'.csv']); % load data
varIDs      = {'motchange2d','colchange2d'};
xnames      = {'Motion','Color'};
ynames      = {'RS Effect size'};
tit         = ['Figure.2-G'];
plotROI_bar_cd(filepath,varIDs,xnames,ynames, ylm,tit)

% --- SuppFigure.7-B
filepath{1} = fullfile(['3_out' fs 'GLM02_lITG_',date_in,'.csv']); % load data
varIDs      = {'motchange2d','colchange2d'};  ylm = ([-2,3]);
xnames      = {'Motion','Color'};
ynames      = {'2d RS Effect size'};
tit         = ['SuppFigure.7-B'];
plotROI_bar_cd(filepath,varIDs,xnames,ynames,ylm, tit)

% --- SuppFigure.7-A
filepath{1} = fullfile(['3_out' fs 'GLM02_rITG_',date_in,'.csv']); % load data
varIDs      = {'motchange2d','colchange2d'};
xnames      = {'Motion','Color'};
ynames      = {'2D RS Effect size'};
tit         = ['SuppFigure.7-A'];
plotROI_bar_cd(filepath,varIDs,xnames,ynames, ylm,tit)


% --- Figure.3-C
filepath{1} = fullfile(['3_out' fs 'GLM02_lITG_',date_in,'.csv']); % load data
filepath{2} = fullfile(['3_out' fs 'GLM02_rITG_',date_in,'.csv']); % load data
ynames      = {'1d RS Effect size'}; ylm = ([-2,3]);
varIDs      = {'colchange1d'};
xnames      = {'L'};
tit         = ['Figure.3-C-L'];
plotROI_bar_cd(filepath(1),varIDs,xnames,ynames,ylm,tit); 
xnames      = {'R'};
tit         = ['Figure.3-C-R'];
plotROI_bar_cd(filepath(2),varIDs,xnames,ynames,ylm,tit);

% --- Figure.3-D
filepath{1} = fullfile(['3_out' fs 'GLM02_lITG_',date_in,'.csv']); % load data
filepath{2} = fullfile(['3_out' fs 'GLM02_rITG_',date_in,'.csv']); % load data
ynames      = {'1d RS Effect size'};
varIDs      = {'motchange1d'};
xnames      = {'L'};
tit         = ['Figure.3-D-L'];
plotROI_bar_cd(filepath(1),varIDs,xnames,ynames,ylm,tit); 
xnames      = {'R'};
tit         = ['Figure.3-D-R'];
plotROI_bar_cd(filepath(2),varIDs,xnames,ynames,ylm,tit); 



