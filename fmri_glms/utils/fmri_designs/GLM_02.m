function [onsets,names,durations,pmod,orth,CONTRAST]= glm_D002(B)
% gets onsets for a localiser design
% INPUT: SUBDATA
%
%
%
%
%%

%--------------- prepare variables:
scanStart       = B.timing.triggerTimeSecs(6);
rdkon           = B.timing.rdk_start - scanStart;

ed              = B.rs.ED;
tt              = B.rs.tt;

abscol          = abs(B.rs.col-2.5);
absmot          = abs(B.rs.mot-2.5);

dcolabs         = B.rs.dcol_abs;
dmotabs         = B.rs.dmot_abs;

% decisions
decon = B.timing.catch_start- scanStart;
decon = decon(~isnan(decon));
rt     = B.dec.rt;
%----

names           = [];
onsets          = [];
durations       = [];
pmod            = [];
orth            = [];

%--------------- Define Regressors:

names{1}        = 'RDKon_1d';
onsets{1}       = rdkon(tt==1 |tt==0);
durations{1}    = .8;

pmod(1).name{1}  = 'motchange';
pmod(1).param{1} = zscore(dmotabs(tt==1 |tt==0));
pmod(1).poly{1}  = 1;

pmod(1).name{2}  = 'colchange';
pmod(1).param{2} = zscore(dcolabs(tt==1 |tt==0));
pmod(1).poly{2}  = 1;

pmod(1).name{3}  = 'absCurrMot1d';
pmod(1).param{3} = zscore(absmot(tt==1 |tt==0));
pmod(1).poly{3}  = 1;

pmod(1).name{4}  = 'absCurrCol1d';
pmod(1).param{4} = zscore(abscol(tt==1 |tt==0));
pmod(1).poly{4}  = 1;
orth{1} = 0;

%-

names{2}        = 'RDKon_2d';
onsets{2}       = rdkon(tt==2);
durations{2}    = .8;

pmod(2).name{1}  = 'motchange';
pmod(2).param{1} = zscore(dmotabs(tt==2));
pmod(2).poly{1}  = 1;

pmod(2).name{2}  = 'colchange';
pmod(2).param{2} = zscore(dcolabs(tt==2));
pmod(2).poly{2}  = 1;

pmod(2).name{3}  = 'StimInt2d';
pmod(2).param{3} = zscore(absmot(tt==2)+abscol(tt==2)); 
pmod(2).poly{3}  = 1;
orth{2} = 0;


%-
names{3}        = 'DEC';
onsets{3}       = decon+rt;
durations{3}    = 0;

names{4}        = 'OtherRDKs';
onsets{4}       = rdkon(tt<0&B.rs.col~=0); % isolates trials that are rdks, not decisions, but are not of tt==0/1/2
durations{4}    = .8;


% define contrasts in order of recessor occurance
CONTRAST.names  = {'C_1d','motchange1d','colchange1d','aCurMot1d','aCurCol1d', 'C_2d', 'motchange2d','colchange2d','stimint2d','DEC','OtherRDKs'};
cons            = eye(numel(CONTRAST.names));
CONTRAST.v      = cellfun(@(y) cons(y,:),num2cell(1:size(cons,2)),'UniformOutput',0) ;      


