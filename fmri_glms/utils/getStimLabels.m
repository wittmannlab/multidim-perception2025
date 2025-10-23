function [colab,molab,both] = getStimLabels(co,mo)
% quick function for getting labels for the QS stimulus space:
% input can be either colors (1-4), motion (1-4), or both (output accordingly)

allmo = {'<--','<-','->','-->'};
allco = {'gg',' g',' r','rr'};

colab = {};
molab = {};
both  = {};

if ~isempty(co)
   for ic = 1:numel(co)
       colab{ic} = allco(co(ic));
   end
end

if nargin > 1
    if ~isempty(mo)
        for im = 1:numel(mo)
            molab{im} = allmo(mo(im));
        end
    end
end

if nargin > 1
    for ic=1:numel(co)
        p1 = molab{ic};
        p2 = colab{ic};
        both{ic} = [p1{:} ' | ' p2{:}];
    end
end



end

