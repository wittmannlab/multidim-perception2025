function behav_rat(sub, outpath)
% Analysis of rating data
% 1. Rating dissimilarity matrix



DIS = NaN(16,16,numel(sub));
DIS_col = NaN(4,4,numel(sub));
DIS_mot = NaN(4,4,numel(sub));
for is = 1:numel(sub)
    T = sub{is}.T;
    tt = T.tt;
    rr = T.zrating;
    [~,~,c1] = dimTrans(T.col1,T.mot1,[]);
    [~,~,c2] = dimTrans(T.col2,T.mot2,[]);
    
    % get disimilarity matrix
    for i1 = 1:16
        for i2=1:16
            DIS(i1,i2,is) = nanmean(rr(c1==i1&c2==i2));
        end
    end
    for i1=1:4
        for i2=1:4
            dc = T.col1-T.col2;
            dm = T.mot1-T.mot2;
            DIS_col(i1,i2,is) = nanmean(rr(T.col1==i1&T.col2==i2&dm==0));
            DIS_mot(i1,i2,is) = nanmean(rr(T.mot1==i1&T.mot2==i2&dc==0));
        end
    end
end

% Calculate mean DIS across subjects
meanDIS = mean(DIS, 3);

% Prepare labels
[coind,moind] = dimTrans([],[],1:16);
[~,~,bothlab] = getStimLabels(coind,moind);

% Create a table with row and column labels
T = array2table(meanDIS, 'RowNames', bothlab, 'VariableNames', bothlab);

% Save as CSV
filename =  [outpath 'behav_rat_matrix_' date '.csv'];
writetable(T, filename, 'WriteRowNames', true);



% #########################################################################
mds_dims = 2;
mdstype  = 'cmd';

rel_mat = (mean(DIS,3)+mean(DIS,3)')./2;         % get symmetric relational matrix
rel_mat = rel_mat + (-(min(min(rel_mat))));      % get positive values
rel_mat = rel_mat-(diag(diag(rel_mat)));         % set diagonal to 0
   
% Perform mds
switch mdstype
    case 'cmd'  
        [Y e]  = cmdscale(rel_mat,mds_dims);

    case 'nmd'
        stress = 1;
        while stress>nmd_max_stress
            [Y stress mds_error]  = mdscale(rel_mat,mds_dims);
            disp(['current stress:',num2str(stress)]);
        end
end   

for id = 1:width(Y)
    variablenames{id} = ['dim_',num2str(id)];
end
 
% Create a table with row and column labels
T = array2table(Y,'VariableNames', variablenames);

% Save as CSV
filename =  [outpath 'behav_rat_mds_' date '.csv'];
writetable(T, filename, 'WriteRowNames', true);




% #########################################################################
% Glm on rating data

B = [];
for is = 1:numel(sub)
    T = sub{is}.T;
    X           = [(T.col1-T.col2).^2 (T.mot1 - T.mot2).^2];
    B(is,:)     = glmfit(zscore(X),T.zrating);    
    B(is,:)     = glmfit(zscore(X),T.zrating);  
end

% Create a table with row and column labels
T = array2table(B,'VariableNames', {'difference-bias','ColorDist','MotionDist'});

% Save as CSV
filename =  [outpath 'behav_rat_glm_' date '.csv'];
writetable(T, filename, 'WriteRowNames', true);



end