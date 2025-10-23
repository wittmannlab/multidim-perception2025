function [onsets,names,durations,pmod,orth,CONTRAST]= glm_D035(B)
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

pmod(1).name{1}  = 'ED_1d';
pmod(1).param{1} = zscore(ed(tt==1 |tt==0));
pmod(1).poly{1}  = 1;

pmod(1).name{2}  = 'absCurrMot1d';
pmod(1).param{2} = zscore(absmot(tt==1 |tt==0));
pmod(1).poly{2}  = 1;

pmod(1).name{3}  = 'absCurrCol1d';
pmod(1).param{3} = zscore(abscol(tt==1 |tt==0));
pmod(1).poly{3}  = 1;
orth{1} = 0;

%-
names{2}        = 'RDKon_2d';
onsets{2}       = rdkon(tt==2);
durations{2}    = .8;

pmod(2).name{1}  = 'ED_2d';
pmod(2).param{1} = zscore(ed(tt==2));
pmod(2).poly{1}  = 1;

pmod(2).name{2}  = 'absCurrMot2d';
pmod(2).param{2} = zscore(absmot(tt==2));
pmod(2).poly{2}  = 1;

pmod(2).name{3}  = 'absCurrCol2d';
pmod(2).param{3} = zscore(abscol(tt==2));
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
CONTRAST.names  = {'C_1d','ED_1d','aCurMot1d','aCurCol1d', 'C_2d','ED_2d','aCurMot2d','aCurCol2d', 'DEC','OtherRDKs'};
cons            = eye(numel(CONTRAST.names));
CONTRAST.v      = cellfun(@(y) cons(y,:),num2cell(1:size(cons,2)),'UniformOutput',0) ;      

CONTRAST.names{end+1} = 'absCurMot';
CONTRAST.v{end+1} = [0 0 1 0 0 0 1 0 0 0];

CONTRAST.names{end+1} = 'absCurColr';
CONTRAST.v{end+1} = [0 0 0 1 0 0 0 1 0 0];


