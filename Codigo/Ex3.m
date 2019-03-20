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
rgb_img = imread(img_path);
gray_img = rgb2gray( rgb_img );
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
mode = 'FgMore'; 
tic;
switch mode
    case 'FgOne'
        central_point = [274, 526];% [linha , coluna]
        offset = [25, 10];
        rectangle('Position', [central_point(2) - offset(2), central_point(1) - offset(1), offset(2) * 2 + 1, offset(1) * 2 + 1], 'EdgeColor', 'g', 'LineWidth', 4);
        patt_image = GetPatternImage(HI, central_point, offset);
    case 'FgMore'
        central_points = [[274, 526]; [212, 314]; [324, 779]];
        offset = [25, 10];
        patt_image = ones(size(filtered_img,1), size(filtered_img,2)) * 100000;
        for c_id = 1:length(central_points)
            rectangle('Position', [central_points(c_id,2) - offset(2), central_points(c_id,1) - offset(1), offset(2) * 2 + 1, offset(1) * 2 + 1], 'EdgeColor', 'g', 'LineWidth', 4);
            patt_temp_image = GetPatternImage(HI, central_points(c_id,:), offset);
            patt_image = min(patt_image, patt_temp_image);
        end
    case 'FgOneBgOne'
        fg_cpoint = [274, 526];
        bg_cpoint = [195, 408];
        offset = [25, 10];
        rectangle('Position', [fg_cpoint(2) - offset(2), fg_cpoint(1) - offset(1), offset(2) * 2 + 1, offset(1) * 2 + 1], 'EdgeColor', 'g', 'LineWidth', 4);
        rectangle('Position', [bg_cpoint(2) - offset(2), bg_cpoint(1) - offset(1), offset(2) * 2 + 1, offset(1) * 2 + 1], 'EdgeColor', 'r', 'LineWidth', 4);
        fg_patt_image = GetPatternImage(HI, fg_cpoint, offset);
        bg_patt_image = GetPatternImage(HI, bg_cpoint, offset);
        patt_image = fg_patt_image - bg_patt_image;
    case 'Kmeans'
        offset = [25, 10];
        num_rows = size(HI, 1);
        num_cols = size(HI, 2);
        num_feats = size(HI, 3);
        nColors = 3;
        all_hists = GetAllHistograms(HI, offset);
        [cluster_idx, cluster_centers] = kmeans(all_hists,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
        cluster_image = reshape(cluster_idx,num_cols, num_rows)';
%         figure, imshow(cluster_image ~= 2, [])
        patt_image=cluster_image;
end
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