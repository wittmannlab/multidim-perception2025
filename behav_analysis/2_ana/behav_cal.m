function behav_cal(sub, outpath)
% Behavioural calibration

    n_subjects = numel(sub);
    % Define variable names
    variablenames = {'sub_id','betaCol_1','betaCol_2','betaMot_1','betaMot_2',...
        'col_1','col_2','col_3','col_4',...
        'mot_1','mot_2','mot_3','mot_4',...
        'pedaldist'};

    % Initialize table with appropriate size
    cal_dat_table = array2table(nan(n_subjects, numel(variablenames)), 'VariableNames', variablenames);

    % Initialize the array columns as cell arrays
    cal_dat_table.col_p_c_r     = cell(n_subjects, 1);  % For the array that will hold strings or arrays
    cal_dat_table.col_coh       = cell(n_subjects, 1);    % Another column for strings or arrays
    cal_dat_table.mot_p_c_r     = cell(n_subjects, 1);  % For the array that will hold strings or arrays
    cal_dat_table.mot_coh       = cell(n_subjects, 1);    % Another column for strings or arrays
    cal_dat_table.S             = cell(n_subjects, 1);    % Another column for strings or arrays

    % --- Loop through each subject -------------------------------------------
    for is = 1:n_subjects
            T = sub{is};

            % --- Perform GLM fits --------------------------------------------
            b_col           = glmfit(T.T.col(T.T.trial_type==2),T.T.decision(T.T.trial_type==2),'binomial','Link','probit');  % Color trials
            b_mot           = glmfit(T.T.coh(T.T.trial_type==1),T.T.decision(T.T.trial_type==1),'binomial','Link','probit');  % Motion trials

            S = get_s(T.pedaldist);

            % --- Calculate Probabilities at each coherance level -------------
            mot_values      = unique(T.T.coh(T.T.trial_type==1));
            col_values      = unique(T.T.col(T.T.trial_type==2));

            for i = 1:length(mot_values)          
                % --- Motion 
                mot_totalcount(i,1) = sum(T.T.trial_type== 1 & T.T.coh==mot_values(i));                      % get the total number of trials at that coherance
                mot_rightcount(i,1) = sum(T.T.trial_type== 1 & T.T.coh==mot_values(i) & T.T.decision==1);    % get the nuber of times participant responded right at that coherance

                % --- Color 
                col_totalcount(i,1) = sum(T.T.trial_type== 2 & T.T.col==col_values(i));                      % get the total number of trials at that coherance
                col_rightcount(i,1) = sum(T.T.trial_type== 2 & T.T.col==col_values(i) & T.T.decision==1);    % get the nuber of times participant responded right at that coherance
            end

            p_choose_right_col(is,:)            = (col_rightcount./col_totalcount)';
            p_choose_right_mot(is,:)            = (mot_rightcount./mot_totalcount)';

            % Assign values to the table using variable names
            cal_dat_table.sub_id(is)            = is;  % Assign subject ID
            cal_dat_table.betaCol_1(is)         = b_col(1);  % Coefficients for color trials
            cal_dat_table.betaCol_2(is)         = b_col(2);  
            cal_dat_table.betaMot_1(is)         = b_mot(1);  % Coefficients for motion trials
            cal_dat_table.betaMot_2(is)         = b_mot(2);  

            cal_dat_table.col_1(is)             = T.col(1);  % Color values
            cal_dat_table.col_2(is)             = T.col(2);
            cal_dat_table.col_3(is)             = T.col(3);
            cal_dat_table.col_4(is)             = T.col(4);

            cal_dat_table.col_p_c_r{is}         = jsonencode(p_choose_right_col(is,:));  % Convert array to a MATLAB-like string
            cal_dat_table.col_coh{is}           = jsonencode(col_values');   % Same for coherence values

            cal_dat_table.mot_1(is)             = T.coh(1);  % Motion values
            cal_dat_table.mot_2(is)             = T.coh(2);
            cal_dat_table.mot_3(is)             = T.coh(3);
            cal_dat_table.mot_4(is)             = T.coh(4);

            cal_dat_table.mot_p_c_r{is}         = jsonencode(p_choose_right_mot(is,:));  % Convert array to a MATLAB-like string
            cal_dat_table.mot_coh{is}           = jsonencode(mot_values');  % Same for coherence values

            cal_dat_table.pedaldist(is)         = T.pedaldist;  % Pedal distance
            
            cal_dat_table.S{is}                 =  jsonencode(S);
    end

    % Save table to CSV
    writetable(cal_dat_table, [outpath 'behav_cal_' date '.csv']);

    function S = get_s(pedaldist)
    s(1) = norminv(1-pedaldist);
    s(4) = norminv(pedaldist);

    D = (s(4) - s(1))/6;
    s(2) = -D;
    s(3) = D;

    S(1)    = 1-normcdf(s(1));
    S(2)    = 1-normcdf(s(2));
    S(3)    = 1-normcdf(s(3));
    S(4)    = 1-normcdf(s(4));
    end
end
