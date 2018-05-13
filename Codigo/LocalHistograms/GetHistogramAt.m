% GETHISTOGRAMAT returns the local histogram of a given image area.
%   histogram = GETHISTOGRAMAT(HI, pattern_pos, offset) obtains the local
%   histogram of a given area from HI defined by pattern_pos ([r, c]) and  
%   an offset ([dr,dc]). The left top position of the area is equal to
%   (r-dr, c-dc) and its bottom right position is (r+dr, c+dc). The 
%   integral histogram (HI) is used to accelerated the computation of the
%   histogram.
% Author: Rayner Harold Montes Condori 
% Ref: Liu, X. and Wang, D., 2006. Image and texture segmentation using 
%      local spectral histograms. IEEE Transactions on Image Processing, 
%      15(10), pp.3066-3077.

function histogram = GetHistogramAt(HI, pattern_pos, offset)

x0 = pattern_pos(2) - offset(2);
y0 = pattern_pos(1) - offset(1);
x1 = pattern_pos(2) + offset(2);
y1 = pattern_pos(1) + offset(1);

x0 = max( x0, 1 );
y0 = max( y0, 1 );
x1 = min( x1, size(HI,2) );
y1 = min( y1, size(HI,1) );
                     
w0 = HI(y1, x1, :);
w1 = 0;
w2 = 0;
w3 = 0;
if(x0 - 1 >= 1 && y0 - 1 >= 1)
    w1 = HI(y0 - 1, x0 - 1, :);
end
if(y0 - 1 >= 1)
    w2 = HI ( y0 - 1, x1, :);
end
if(x0 - 1 >= 1)
    w3 = HI ( y1, x0 - 1, :);
end

total = (y1 - y0 + 1) * (x1 - x0 + 1);
histogram =  (w0 + w1 - w2 - w3)/ total; 
histogram = reshape(histogram, size(HI,3), 1) ;

% fprintf('total: %d\n', total)
