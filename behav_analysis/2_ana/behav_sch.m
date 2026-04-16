function behav_sch(sub, outpath)
% show schedule
% MKW 2026
fs = filesep;

CT = sub{1}.B{1}.rs; % trial type distribution same for every subject and block
T = CT(CT.tt>-1,:);    % take only valid trials, i.e. no catch trials, trials after catch trials, or first trials of block

% plot absolute transition types, start/end positions
trans = [];
for ic = 1:4
    for im = 1:4
        trans(end+1,:) = [ic-1 im-1]; % difference vectors, codes as [color motion]
    end
end

% collect information
ndv = size(trans,1);
mend   = zeros(4,4,ndv); % end positions
for id = 1:ndv
    Tcur = T(T.dcol_abs==trans(id,1)&T.dmot_abs==trans(id,2),:);
    
    dat1 = groupcounts(Tcur,{'col','mot'});
    for ii = 1:size(dat1,1)
        mend(dat1.col(ii),dat1.mot(ii),id) = dat1.GroupCount(ii);
    end

end
    

%plot end positions:
figure;
for id = 1:ndv
    subplot(4,4,id)
    hm = heatmap(mend(:,:,id));

    hm.Title = { ...
        ['Color step size = ' num2str(trans(id,1))], ...
        ['Motion step size = ' num2str(trans(id,2))] ...
        };
    hm.FontName = 'Arial';

    % Axis labels
    hm.XLabel = 'Motion';
    hm.YLabel = 'Color';

    hm.ColorbarVisible = 'off';
end



saveas(gcf, ['..' fs '5_Figs' fs 'SuppFigure.4.fig']); 




end