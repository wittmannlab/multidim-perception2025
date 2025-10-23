% prep work space:
beep off;format short g;
fs = filesep;
clear filepath

filepath{1} = fullfile(['..' fs '3_out' fs 'RSA_stats_21-Oct-2025.mat']); % load data
load(filepath{1});

%% 
num_modls   = 2; 
n_rois      = 2;
colors      = lines(num_modls);% Colors for different folds

data = [ ...
    stats_struct.V4.colourModel.corrVals(:), ...
    stats_struct.V4.motionModel.corrVals(:), ...
    stats_struct.MT.colourModel.corrVals(:), ...
    stats_struct.MT.motionModel.corrVals(:) ];

Tw = array2table(data, 'VariableNames', ...
   {'V4_colourModel','V4_motionModel','MT_colourModel','MT_motionModel'});

Tw.subject_ids = [1:height(Tw)]';

%% convert to longformat
t1 = stack(Tw,{["MT_colourModel" "MT_motionModel"] ["V4_colourModel" "V4_motionModel"]}, ...
    "NewDataVariableName",["MT" "V4"], "IndexVariableName","Beta");
t1.Beta = categorical(t1.Beta,3:4,["Color", "Motion"]);

t2 = stack(t1,["MT" "V4"], ...
    "NewDataVariableName","Value", "IndexVariableName","ROI");
t2 = sortrows(t2,["ROI" "Beta"]);


%% Plotting

figure
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

% ----- MT -----
ax1 = nexttile;
tt  = t2(t2.ROI=='MT',:);
boxchart(tt.Beta, tt.Value, 'JitterOutliers','on','MarkerStyle','+');
yline(0,'--'); ylim([-0.2,0.4]);
ylabel('Kendalls Tau'); xlabel('Model'); title('MT');

% ----- V4 -----
ax2 = nexttile;
tt  = t2(t2.ROI=='V4',:);
boxchart(tt.Beta, tt.Value, 'JitterOutliers','on','MarkerStyle','+');
yline(0,'--'); ylim([-0.2,0.4]);
xlabel('Model'); title('V4');

% sgtitle('SuppFigure.6-E'); title('SuppFigure.6-E', 'Interpreter', 'none');

