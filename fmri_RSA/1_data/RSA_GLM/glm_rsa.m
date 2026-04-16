function [onsets,names,durations,pmod,orth,CONTRAST]= glm_rsa(B)
% gets onsets for a localiser design
% INPUT: SUBDATA
%
%
%%
%--------------- prepare variables:
scanStart       = B.timing.triggerTimeSecs(6);
rdkon           = B.timing.rdk_start - scanStart;                    

names           = [];
onsets          = [];
durations       = [];
pmod            = [];
orth            = [];

%-------------- Prepare variables:
tt   = B.rs.twod;    % current stimulus

for i = 1:16
        onnow = rdkon(tt==i); % 
        names{i}        = ['stimulus_' num2str(i,'%02d')];
        onsets{i}       = onnow;
        durations{i}    = .8;  
end

% define contrasts in order of recessor occurance
CONTRAST.names  = {names{:}};    
cons            = eye(numel(names));
CONTRAST.v      = cellfun(@(y) cons(y,:),num2cell(1:size(cons,2)),'UniformOutput',0); 



                                                            







