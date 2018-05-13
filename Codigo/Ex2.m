clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% AUTOR: RAYNER HAROLD MONTES CONDORI %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('.', filesep', 'Filters')
directory_path = ['..', filesep, 'Dados', filesep, 'Arvore1', filesep];
img_ext = 'jpg';
img_names = dir( [directory_path, '*.', img_ext] );
img_names = sort({img_names.name});


%% Step 1: Reading and displaying image

%%%%%%%%%%%%%%% To Edit %%%%%%%%%%%%%%%%
chosen_img = 1; % Number from 1 to 15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img_path = [directory_path, img_names{chosen_img} ];

gray_img = rgb2gray( imread(img_path) );
gray_img = im2double(gray_img);
figure, imshow(gray_img)

%% Step 2: Filtering
filter_id = 'sobel';
switch filter_id
    case 'sobel'
        filter = getSobelFilter('x');
%         filter2 = getSobelFilter('y');
        filtered_img = imfilter(gray_img, filter);
%         filtered2_img = imfilter(gray_img, filter2);
%         filtered_img = sqrt( filtered_img.^2 + filtered2_img.^2);
    case 'log'
        filter = laplacian_of_gaussian(5);
        filtered_img = imfilter(gray_img, filter);
    case 'gauss'
        filtered_img = imgaussfilt( gray_img, 10);
    case 'gabor'
        lambda  = 10;   % size of the filter
        theta   = pi/2; % orientation of the filter
        filter = gabor_fn(1,0.5,0,lambda,theta ) + 1i * gabor_fn(1,0.5,pi/2,lambda,theta );
        filtered_img = abs(imfilter(gray_img, filter));
    case 'bank_gabor'
        lambda  = 10;   % size of the filter
        filtered_img = zeros( size(gray_img) );
        for theta = pi/4:pi/2:(3*pi/4)
            filter = gabor_fn(1,0.5,0,lambda,theta ) + 1i * gabor_fn(1,0.5,pi/2,lambda,theta );
            filtered_img = filtered_img  + abs(imfilter(gray_img, filter));
        end
end

filtered_img = (filtered_img - min(filtered_img(:))) / (max(filtered_img(:)) - min(filtered_img(:)));
[a, x] = imhist(filtered_img, 256) ;
PlotImgHist(filtered_img, x,a)



%% Step 3: Thresholding
level = graythresh(filtered_img);
disp(level)
bw_img = filtered_img > 0.5;
figure, imshow(bw_img)

