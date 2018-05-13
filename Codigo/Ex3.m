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


%% Step 1: Reading Image
disp('---------------------> Reading Image <-----------------------');

%%%%%%%%%%%%%%% To Edit %%%%%%%%%%%%%%%%
chosen_img = 1; % Number from 1 to 15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img_path = [directory_path, img_names{chosen_img} ];
gray_img = rgb2gray( imread(img_path) );
figure, imshow(gray_img)

%% Step 2: Filtering Image
disp('---------------------> Filtering Image <-----------------------');
tic;
filtered_img = FilterImage_v1(gray_img);
toc;

%% Step 3: Computing HI
disp('------------------------> Computing HI <-----------------------');
tic;
HI = GetIntegralHistogram( filtered_img, -1 );
toc;

%% Step 4: Computing distance image
disp('-----------------> Computing Pattern Image <-------------------');
tic;
central_point = [274, 526]; % [row , column]
offset = [25, 10];
rectangle('Position', [central_point(2) - offset(2), central_point(1) - offset(1), offset(2) * 2 + 1, offset(1) * 2 + 1], 'EdgeColor', 'g', 'LineWidth', 4);
patt_image = GetPatternImage(HI, central_point, offset);
toc;

%% Step 5: Computing Histogram of distance image
patt_image = (patt_image - min(patt_image(:))) / (max(patt_image(:)) - min(patt_image(:)));
[c,x] = imhist( patt_image, 256 ) ;
PlotImgHist(patt_image, x,c)

%% Step 6: Thresholding 
disp('------------> Applying  Thresholding <-----------------');
tic;
level = 0.4;
% level = graythresh(patt_image);
disp(level)
bw_img = patt_image > level;
figure, imshow(bw_img)
toc;