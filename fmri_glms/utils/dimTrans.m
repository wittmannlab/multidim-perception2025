function [cout,mout,spout] = dimTrans(co1,mo1,sp2d)
% transforms 1D perspective with two co-occuring vectors to 2D perspective with one vector, MKW 2022
%
% INPUT:    THIS IS OPTIONAL!, EITHER
%           - mo1 and co1: two vectors or matrices (!) with motion and color dimension; sp2d must be empty
%           - sp2: 2d coordinates to be transformed in 1D coordinates
%
% OUPTUT: the corresponding other thing;
%%

% get dimensionality:
if isempty(co1)
    dimsize = size(sp2d);
else
    dimsize = size(co1);
end

% squash but reshape afterwards:
co1 = co1(:);
mo1 = mo1(:);
sp2d= sp2d(:);


% hard coded transformation table
% co1, mo1, sp2d
tt = [ ...
    0 0 0 % zero is catch trial
    1 1 1
    1 2 2
    1 3 3
    1 4 4
    2 1 5
    2 2 6
    2 3 7
    2 4 8
    3 1 9
    3 2 10
    3 3 11
    3 4 12
    4 1 13
    4 2 14
    4 3 15
    4 4 16];

% prepare output
mout  = [];
cout  = [];
spout = [];

% check what the input is:
if isempty(mo1)
    for i = 1:numel(sp2d)
        cout = [cout tt(tt(:,3)==sp2d(i),1)];
        mout = [mout tt(tt(:,3)==sp2d(i),2)];     
    end
    cout = reshape(cout',dimsize);
    mout = reshape(mout',dimsize);
else
    for i = 1:numel(mo1)
        pick = intersect(find(co1(i)==tt(:,1)),find(mo1(i)==tt(:,2)));
        spout= [spout tt(pick,3)];
    end
    spout = reshape(spout,dimsize);
end



end

