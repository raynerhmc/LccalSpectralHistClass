% GETPATTERNIMAGE returns the pattern image from a precomputed integral
% histogram and a given pattern histogram.
%   patt_image = GETPATTERNIMAGE(HI, pattern_pos, offset) returns the
%   pattern image (patt_image) from a given HI and a particular pattern 
%   histogram. The pattern histogram is computed from the area defined by 
%   pattern_pos ([r, c]) and offset ([dr,dc]). The left top position of the
%   area is equal to (r-dr, c-dc) and its bottom right position is (r+dr, 
%   c+dc).
% Author: Rayner Harold Montes Condori 
% Ref: Liu, X. and Wang, D., 2006. Image and texture segmentation using 
%      local spectral histograms. IEEE Transactions on Image Processing, 
%      15(10), pp.3066-3077.
function patt_image = GetPatternImage( HI, pattern_pos, offset )
patt_image = zeros(size(HI, 1), size(HI, 2));
pattern_hist = GetHistogramAt(HI, pattern_pos, offset);
% disp(pattern_hist)
for row = 1:size(HI, 1)
    for col = 1:size(HI, 2)
        pos_hist = GetHistogramAt(HI, [row,col], offset);
%         disp(pos_hist)
        patt_image(row, col) = sum( ( ( pattern_hist - pos_hist ) .^ 2 ) ./ ( pattern_hist + pos_hist + 1e-9 ) );
    end
end


