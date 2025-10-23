function behav_rs(sub, outpath)
% RS decision analysis
% 1. Calculate percent correct per block
% 2. Calculate effects of Cl and Ml on decisions, collapsed over blocks
% MKW 2024

n_rs = 3; % number of blocks
n_subjects = numel(sub);

% Initialize arrays
PC = zeros(n_subjects, n_rs);
GLM_effects = zeros(n_subjects, 3); % Intercept, Cl effect, Ml effect

for is = 1:n_subjects
    X_all = []; % For storing all blocks' data
    Y_all = []; % For storing all blocks' decisions
    
    for ib = 1:n_rs
        T = sub{is}.B{ib}.dec;
        
        % Calculate percent correct
        EDl = sqrt((T.LC-T.corel).^2 + (T.LM-T.morel).^2);
        EDr = sqrt((T.RC-T.corel).^2 + (T.RM-T.morel).^2);
        correct_choices = (T.dec==1)==((EDl-EDr)>=0); % 0/1 for incorrect/correct; 0 is left, 1 is right
        PC(is, ib) = mean(correct_choices) * 100;
        
        % Prepare data for GLM (collapsed over blocks)
        Cl = (T.LC-T.corel).^2 - (T.RC-T.corel).^2;
        Ml = (T.LM-T.morel).^2 - (T.RM-T.morel).^2;
        X_all = [X_all; Cl, Ml];
        Y_all = [Y_all; T.dec];
    end
    
    % Fit GLM for Cl and Ml effects (collapsed over blocks)
    GLM_effects(is, :) = glmfit(X_all, Y_all, 'binomial', 'Link', 'probit');
end

% Save percent correct to CSV
pc_table = array2table(PC, 'VariableNames', {'Block1', 'Block2', 'Block3'});
writetable(pc_table, [outpath 'behav_rs_pcCorrect_' date '.csv']);

% Save GLM effects to CSV
effect_names = {'Intercept', 'Colour distance', 'Motion distance'};
glm_table = array2table(GLM_effects, 'VariableNames', effect_names);
writetable(glm_table, [outpath 'behav_rs_glm_' date '.csv']);



%% also save trial types for 0 and 1d across subjects
ED_2D = []; 
ED_01D = [];
subnos_01D = [];
subnos_2D = [];

for is = 1:n_subjects
    % for ib = 1:n_rs
    ib = 1;
        tt_sub          = sub{is}.B{ib}.rs.tt;
        ED_01D          = [ED_01D ; sub{is}.B{ib}.rs.ED(ismember(tt_sub,[0,1]))];
        subnos_01D      = [subnos_01D ; ones(sum(ismember(tt_sub,[0,1])),1)*is];

        ED_2D           = [ED_2D  ; sub{is}.B{ib}.rs.ED(ismember(tt_sub,[2]))];
        subnos_2D      = [subnos_2D ; ones(sum(tt_sub==2),1)*is];
    % end
end


% Save  to CSV
effect_names = {'ED','subno'};
glm_table = array2table([ED_01D,subnos_01D], 'VariableNames', effect_names);
writetable(glm_table, [outpath 'behav_rs_ED_tt01_' date '.csv']);

% Save  to CSV
effect_names = {'ED','subno'};
glm_table = array2table([ED_2D,subnos_2D], 'VariableNames', effect_names);
writetable(glm_table, [outpath 'behav_rs_ED_tt2_' date '.csv']);





end