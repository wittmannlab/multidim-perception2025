function stats_out = compareRefRDM2candRDMs_cd201025(cur_RDM, models, userOptions)

% Cur_rdm is a struct containig all of the subjects neural rdms
% Models contains all model rdms we want to copare against nerual rdms

% Loop over each subject and do 2 things
% 1. Compare Neural data to eachmodel using kendalls tau
% 2. Shuffle Neural data and compare again


num_shuffles    = userOptions.significanceTestPermutations;
corrtype        = userOptions.distanceMeasure;
tails           = userOptions.tails;

% Initialize 
corrmat         = zeros(numel(cur_RDM), numel(models));
medianVec       = zeros(numel(cur_RDM),1); % vector of median 0


% Get the name of the Roi
roiname = strrep(strrep(cur_RDM(1).name, ' | ', '_'), '-', '_');
splitStrings = split(roiname, '_s');
roiname = splitStrings{1};


for im =1:numel(models)
    modRDM_vec              = vectorizeRDM(models(im).RDM);
    model_name              = matlab.lang.makeValidName(models(im).name);
       
    for is =1:numel(cur_RDM)
        subRDM_vec = vectorizeRDM(cur_RDM(is).RDM);
    
        % ---1. Compare Neural data to eachmodel using kendalls tau -------
        [subcorr,pval] = corr(subRDM_vec',modRDM_vec','Type',corrtype,'Tail',tails);
         
        % --- 2. Shuffle Neural data and compare again --------------------
        random_indices = arrayfun(@(x) randperm(length(subRDM_vec)), 1:num_shuffles, 'UniformOutput', false);
        random_indices = cell2mat(random_indices');

        % --- Use the random indices to shuffle the vector ----------------
        shuffled_subRDM_vecs = subRDM_vec(random_indices);
        
        % --- Compute Corr for each shuffled vector against modRDM --------
        corr_nulldist      = arrayfun(@(i) corr(shuffled_subRDM_vecs(i, :)',modRDM_vec','Type',corrtype,'Tail',tails), 1:num_shuffles);
        corr_nulldist_mean  = mean(corr_nulldist);
        
        % --- subtract subs correlation from bootstrapped coorelation -----
        corrmat(is,im) = subcorr -corr_nulldist_mean;
    end
    
    % --- Perform a one-sided Wilcoxon signed-rank test -------------------
    [p, h, stats] = signrank(corrmat(:,im),medianVec, 'tail', 'right'); % 'right' tests if the median of differences is greater than zero

    stats_out.(model_name).p          = p;
    stats_out.(model_name).h          = h;
    stats_out.(model_name).signrank   = stats.signedrank;
    stats_out.(model_name).zval       = stats.zval;

    stats_out.(model_name).corrVals   = corrmat(:,im);
    stats_out.(model_name).corrtype   = corrtype;
end


end


        
