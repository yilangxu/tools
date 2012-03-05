% For single timestep

function [ll] = length_scale(data,index,dx)

    if ~exist('index','var'), index = 1; end
    if ~exist('dx','var'), dx = 1; end
    
    data = shiftdim(data,index-1);
    s   = size(data);
    if length(s) == 2, s(3) = 1; end
    jump1 = ceil(s(2)/10);
    jump2 = ceil(s(3)/10);
    
    for i=1:jump1:s(2)
        for j=1:jump2:s(3)
            ind = sub2ind([10 10],ceil(i/jump1),ceil(j/jump2));
            [covx(ind,:),lagx] = xcov(data(:,i,j)-mean(data(:,i,j)),'biased');
        end
    end
    
    mean_covx = mean(covx,1);
    i1 = s(1);
    i2 = find(mean_covx(i1:end) < 0);
    if numel(i2) == 0, ll = NaN; return; end
    i2 = s(1)-1 + i2(1);
    
    p = polyfit(lagx(i2-1:i2)*dx,mean_covx(i2-1:i2),1);
    ll = roots(p);
    %ll = r((r < lagx(i2)*dx) & (r > 0));
   % ll = abs(lagx(find_approx(mean_covx,0,1))*dx);