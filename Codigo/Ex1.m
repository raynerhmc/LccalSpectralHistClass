clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% AUTOR: RAYNER HAROLD MONTES CONDORI %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('.', filesep', 'Filters')
addpath('.', filesep', 'LocalHistograms')
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

%% Step 2: Histogram analysis
[a, x] = imhist(im2double(gray_img), 256 ) ;
figure, stem(x,a, 'LineWidth', 2)
set(gca, 'Fontsize', 22);
grid on

%% Step 3: Thresholding
level = 0.3;
% level = graythresh(gray_img);
disp(level)
bw_img = gray_img > level;
figure, imshow(bw_img)


