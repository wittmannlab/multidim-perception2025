function behav_rat_supp(sub,s, csvpath,figpath)
% Analysis of rating data


fs = filesep;
vmpfctable= readtable(['..' fs '..' fs 'fmri_glms' fs '3_out' fs 'GLM01_vmPFC_Park4_m648m4_22-Oct-2025.csv']); % load data






%%%%%%%%%%%%%%%%%%%%%%%

% Prepare labels
[coind,moind] = dimTrans([],[],1:16);

nsub = numel(sub);
nstim=16;
%%%%% get similarity matrix from data
DIS = NaN(16,16,nsub);
DIS_col = NaN(4,4,nsub);
DIS_mot = NaN(4,4,nsub);
DIS_col_16 = NaN(16,16,nsub);
DIS_mot_16 = NaN(16,16,nsub);
for is = 1:numel(sub)
    T = sub{is}.T;
    rr = T.zrating;
    [~,~,c1] = dimTrans(T.col1,T.mot1,[]);
    [~,~,c2] = dimTrans(T.col2,T.mot2,[]);
    
    % get disimilarity matrix
    % overall
    for i1 = 1:16
        for i2=1:16
            DIS(i1,i2,is) = nanmean(rr(c1==i1&c2==i2));
        end
    end
    % per feature while holding the other one stable
    for i1=1:4
        for i2=1:4
            dc = T.col1-T.col2;
            dm = T.mot1-T.mot2;
            DIS_col(i1,i2,is) = nanmean(rr(T.col1==i1&T.col2==i2&dm==0));    % color dissimilarity when motion is stable
            DIS_mot(i1,i2,is) = nanmean(rr(T.mot1==i1&T.mot2==i2&dc==0));    % motion dissimilarity when color is stable
        end
    end
    % project 1D features into full space for future RDM
    for i = 1:nstim
        for j = 1:nstim
            DIS_col_16(i,j,is) = DIS_col( coind(i), coind(j), is );
            DIS_mot_16(i,j,is) = DIS_mot( moind(i), moind(j), is );
        end
    end
end

%%%%%%% predict 2D ratings from combination of 1D ratings

% make mask for 2d stims:
mask_both = zeros(nstim, nstim);
mask_col  = zeros(nstim, nstim);
mask_mot  = zeros(nstim, nstim);
for i = 1:nstim
    for j = 1:nstim
        mask_both(i,j) = (coind(i) ~= coind(j)) & (moind(i) ~= moind(j));
        mask_col(i,j) =  (moind(i) == moind(j));
        mask_mot(i,j) =  (coind(i) == coind(j)); 
    end
end
mask_both = logical(mask_both);
mask_col = logical(mask_col);
mask_mot = logical(mask_mot);

B   = [];
fit = [];
for is = 1:numel(sub)
    % extract subject matrices
    dis = DIS(:,:,is);        % 16x16
    cc  = DIS_col_16(:,:,is); % expanded color RDM (16x16)
    mm  = DIS_mot_16(:,:,is); % expanded motion RDM (16x16)

    % apply 2D-change mask
    dis_2D = dis(mask_both);
    cc_2D  = cc(mask_both);
    mm_2D  = mm(mask_both);

    % run regression
    X = [cc_2D,mm_2D];
    X = zscore(X);
    y = dis_2D;

    model    = fitglm(X,y); 
    b = model.Coefficients.Estimate;
    B(is,:)  = b;
    Wcol = b(2) / sum(b([2 3]));
    Wass(is) = abs(Wcol-0.5);
    fit(is,1) = model.Deviance;

end

mat = [];
varnames = {'subNo','B_intercept','Bcol','Bmot','W_symmetry','NegDeviance'};
count = 1;
for is = 1:numel(s.Rat)
    if ~isempty(s.Rat{is})
        curmat = [is, B(count,:),  -Wass(count), -fit(count)];        
        count = count + 1; 
    else
        curmat = [is, NaN,NaN,NaN,NaN,NaN];
    end
    mat = [mat;curmat];
end

% save data:

% Create a table with row and column labels
T1 = array2table(mat, 'VariableNames', varnames);

% merge with other table:
TT = [T1 vmpfctable];
TT = TT(~any(ismissing(TT), 2), :); % note that rating data is not available for everyone

% write
filename =  [csvpath 'behav_rat_supp_' date '.csv'];
writetable(TT, filename);




%%%% make figure


ws = TT.W_symmetry;
nd = TT.NegDeviance;
ed = TT.ED_2d;

figure('Color','w','Units','centimeters','Position',[2 2 28 12]);
cmap = [1 1 1; 0 0 0];

% --- A–C: masks (box ON, no x/y labels or ticks) ---
subplot(2,3,1);
imagesc(mask_col); colormap(cmap);
set(gca,'XTick',[],'YTick',[],'Box','on');
title('1D color')

subplot(2,3,2);
imagesc(mask_mot); colormap(cmap);
set(gca,'XTick',[],'YTick',[],'Box','on');
title('1D motion')

subplot(2,3,3);
imagesc(mask_both); colormap(cmap);
set(gca,'XTick',[],'YTick',[],'Box','on');
title('2D')

% --- E: W_symmetry vs ED_2d ---
subplot(2,3,5); hold on

scatter(ed, ws, 42, ...
    'MarkerFaceColor',[0.2 0.2 0.2], ...
    'MarkerEdgeColor','none', ...
    'MarkerFaceAlpha',0.6)

lm = fitlm(ed, ws);
x = linspace(min(ed), max(ed), 200)';
plot(x, predict(lm,x), 'k-', 'LineWidth',1.6)

[r,p] = corr(ed, ws, 'Type','Pearson');

xlabel('2D RS in vmPFC')
ylabel('W-symm')
set(gca,'Box','off','TickDir','out')

text(0.95,0.05, sprintf('r = %.3g\np = %.3g', r, p), ...
    'Units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom')

hold off

% --- F: NegDeviance vs ED_2d ---
subplot(2,3,6); hold on

scatter(ed, nd, 42, ...
    'MarkerFaceColor',[0.2 0.2 0.2], ...
    'MarkerEdgeColor','none', ...
    'MarkerFaceAlpha',0.6)

lm = fitlm(ed, nd);
x = linspace(min(ed), max(ed), 200)';
plot(x, predict(lm,x), 'k-', 'LineWidth',1.6)

[r,p] = corr(ed, nd, 'Type','Pearson');

xlabel('2D RS in vmPFC')
ylabel({'Negative model deviance', '(higher values indicate better fit)'})
set(gca,'Box','off','TickDir','out')

text(0.95,0.05, sprintf('r = %.3g\np = %.3g', r, p), ...
    'Units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom')

hold off

saveas(gcf, ['..' fs '5_Figs' fs 'SuppFigure.11.fig']); 
end