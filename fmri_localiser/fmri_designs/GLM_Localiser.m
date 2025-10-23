function [onsets,names,durations,pmod,orth,CONTRAST]= glm_L002(loc)
% gets onsets for a localiser design
% INPUT: SUBDATA
%
%
%
%
%%


%--------------- prepare variables:
scanStart       = loc.timing.triggerTimeSecs(6);
blockOnsets     = loc.timing.blockStart - scanStart;
blockduration   = loc.timing.blockduration;
motionOnsets    = blockOnsets(loc.coh ~= 0);
colourOnsets    = blockOnsets(loc.col ~= 0.5);
motionDur       = blockduration(loc.coh ~= 0);
colourDur       = blockduration(loc.col ~= .5);




names           = [];
onsets          = [];
durations       = [];
pmod            = [];
orth            = [];

%--------------- Define Regressors:

names{1}        = 'Colour';
onsets{1}       = colourOnsets;
durations{1}    = colourDur;

names{2}        = 'Motion';
onsets{2}       = motionOnsets;
durations{2}    = motionDur;



CONTRAST.names  = {'col_loc','mot_loc','col_m_mot'};                                                        
CONTRAST.v      = {[1 0 ]; [0  1]; [1 -1]};                                                          % you do have to ignore the motion regressors here; 
                                   



