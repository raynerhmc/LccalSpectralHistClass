% GETINTEGRALHISTOGRAM returns the accumulated (integral) histogram of an
% image of N channels.
%   HI = GETINTEGRALHISTOGRAM( filtered_img, nbins ) returns the integral
%   histogram (HI) of an image (filtered_img) of size (Nr x Nc x Nch). The
%   size of HI will be of (Nr x Nc x Nch * nbins) 
% Author: Rayner Harold Montes Condori
% Ref: Liu, X. and Wang, D., 2006. Image and texture segmentation using 
%      local spectral histograms. IEEE Transactions on Image Processing, 
%      15(10), pp.3066-3077.
function HI = GetIntegralHistogram( filtered_img, nbins )

if nbins < 2
    disp('nbins is setted to be 18!')
    nbins = 18;
end
num_rows = size( filtered_img, 1 );
num_cols = size( filtered_img, 2 );
num_channels = size( filtered_img, 3);

HI = zeros(num_rows, num_cols, num_channels * nbins);

for channel = 1: num_channels
    min_value = min(min( filtered_img(:,:,channel) ) );
    max_value = max(max( filtered_img(:,:,channel)));
    
    step = (max_value - min_value) / nbins;

    cont = 1;
    disp([min_value, max_value, step]);
    for z1 = min_value:step:(max_value - step)
        z2 = z1 + step;
        if cont == nbins
            z2 = z2 + step;
        end
        HI(:,:,(channel - 1) * nbins + cont ) = GetChannelHI(filtered_img(:,:, channel), z1, z2);
        cont = cont + 1;
    end
end


function HI = GetChannelHI( I_filtered, z1, z2)
size_I = size(I_filtered);
num_rows = size_I(1);
num_cols = size_I(2);
HI = zeros(num_rows, num_cols);
RS = zeros(num_rows, num_cols);
for col = 1:num_cols
    if I_filtered(1, col) >= z1 && I_filtered(1, col) < z2
        RS(1, col) = 1;
    end
end

for row = 2:num_rows
    for col = 1:num_cols
        if I_filtered(row, col) >= z1 && I_filtered(row, col) < z2
            RS(row, col) = RS(row - 1, col) + 1;
        else 
            RS(row, col) = RS(row -1, col);
        end
    end
end

HI(:,1) = RS(:,1);

for row = 1:num_rows
    for col = 2:num_cols
        HI(row, col) = HI(row, col - 1) + RS(row, col);
    end
end
