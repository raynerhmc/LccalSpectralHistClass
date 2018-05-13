function out_I = FilterImage_v2( in_I )

%%%% FOR GABOR FILTER %%%%
lambda  = 8;
theta   = pi/4;
psi     = [0 pi/2];
gamma   = 0.5;
bw      = 1;
%%%%%%%%%%% END %%%%%%%%%%

nfilters = 3;
n = 1;
in_I = im2double(in_I);
in_I = (in_I - mean(in_I(:)) ) / std(in_I(:));
disp([min(in_I(:)), max(in_I(:) )]);
out_I = zeros( size(in_I,1), size(in_I,2), nfilters ); 


% filter = laplacian_of_gaussian(5);
% out_I(:,:,n) = imfilter( in_I, filter, 'symmetric');
% % figure, imshow(out_I(:,:,n) , []);
% n = n+1;

% filter = getSobelFilter('y');
% out_I(:,:,n) = imfilter( in_I, filter, 'symmetric');
% n = n+1;

% filter = gabor_fn(bw,gamma,psi(1),lambda,theta ) + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta );
% out_I(:,:,n) = abs(imfilter( in_I, filter, 'symmetric'));
% % figure, imshow(out_I(:,:,n), [])
% n = n+1;
% 
% filter = gabor_fn(bw,gamma,psi(1),lambda,theta + pi/4) + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta + pi/4);
% out_I(:,:,n) = abs(imfilter( in_I, filter, 'symmetric'));
% % figure, imshow(out_I(:,:,n), [])
% n = n+1;
% 
% filter = gabor_fn(bw,gamma,psi(1),lambda,theta + pi/2) + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta + pi/2);
% out_I(:,:,n) = abs(imfilter( in_I, filter, 'symmetric'));
% % figure, imshow(out_I(:,:,n), [])
% n = n+1;

out_I(:,:,n) = imgaussfilt(in_I, 2);
% figure, imshow(out_I(:,:,n), []);
n = n+1;
 
out_I(:,:,n) = GetLBPImage(in_I);
% figure, imshow(out_I(:,:,n), []);
% [c,x] = imhist( out_I(:,:,n), 18 ) ;
% PlotImgHist(out_I(:,:,n), x,c)
% figure, imshow( out_I(:,:,n) >= 0.22 & out_I(:,:,n) <= 0.24);
n = n+1;

out_I(:,:,n) = in_I;


function LBP_Im = GetLBPImage(I)
R = 1;
L = 2*R + 1; %% The size of the LBP label
C = round(L/2);

Input_Im = padarray(I, [R,R], 'replicate');
row_max = size(Input_Im,1)-L+1;
col_max = size(Input_Im,2)-L+1;
LBP_Im = zeros(row_max, col_max);
for i = 1:row_max
    for j = 1:col_max
        A = Input_Im(i:i+L-1, j:j+L-1);
        A = A-A(C,C);
        A(A>=0) = 1;
        A(A<0) = 0;
        LBP_Im(i,j) = A(C,L) + A(L,L)*2 + A(L,C)*4 + A(L,1)*8 + A(C,1)*16 + A(1,1)*32 + A(1,C)*64 + A(1,L)*128;
    end
end
LBP_Im = LBP_Im / 255.0;