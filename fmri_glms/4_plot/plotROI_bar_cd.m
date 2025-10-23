function  plotROI_bar_cd(csv_id,varIDs,xnames,ynames,ylm,tit)
% simple function to plot ROI information, MKW 2022
%
%
%
%%

% --- Load CSV ------------------------------------------------------------
T_all          = readtable(csv_id{1});

% --- Get columns to plot
for i = 1:numel(varIDs)
    ID = varIDs{i};
    T.(ID) = T_all.(ID);
end

ncol        = numel(varIDs);
nsubs       = height(T.(ID));
subCol      = cbrewer('qual','Set2',nsubs);


% --- Set plot params -----------------------------------------------------
figure_size             = [2 2 20 20; 2 2 10 10;2 2 10 10];  % [x, y, width, height] 
ax_pos                  = [0.4 0.4 0.5 0.5];  % Axes position
jitter                  = 0.1;  % Adjust for how much you want the points to spread
colors                  = lines(nsubs);  % Generate unique colors for each subject
scatter_size_individual = 2;  % Scatter size for individual data points
scatter_size_group      = 2; 
fontstyle               = 'Times New Roman';
fontsize                = 14;
horz_align              = 'center';

    
% --- PLot figure     -----------------------------------------------------
figure;
% set(gcf, 'Units', 'centimeters', 'Position', figure_size(1,:));  % Set figure size
% ax2 = axes("Position", ax_pos, "Units", "normalized");
% hold(ax2, 'on');  % Ensure plotting happens on ax2
hold on;
title(tit);

for id = 1:ncol
    data = T.(varIDs{id});
    bpl{id} = bar(id, mean(data,1)); hold on
    set(bpl{id},'Facecolor','w');
    
    errorbar(id, mean(data),getSE(data),'k.'); hold all;
    
    for is=1:nsubs
       hsub{is} = plot(id+.2,data(is),'o','Linewidth',1,'Color',subCol(is,:),'DisplayName',['s',num2str(is)]); hold all;
    end
end

xlim([.5 ncol+.5]);
plot(xlim,[0 0],'k');
ylabel(ynames)
ylim(ylm)
set(gca, 'xtick',[1:ncol],'xticklabel',xnames);
set(gca, 'FontSize', fontsize);


saveas(gcf, [ '..\5_Figs\',tit,'.fig']);
% plot2svg([pwd '\5_Figs\',tit,'.svg']);
