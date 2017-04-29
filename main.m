close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/data/c87']);
addpath([cd '/detection']);
addpath([cd '/common']);
addpath([cd '/Threshold']);
addpath([cd '/GaussianFit']);
addpath([cd '/Forms']);
addpath([cd '/pack_emd']);
addpath([cd '/pack_emd/package_emd']);
addpath([cd '/pack_emd/package_emd/EMDs/src']);

TIRF_num = 3;
SIM_num = 3*TIRF_num;
%% read imgae
% SIM_file_name = 'c87-sim-32.5nm.tif';
% TRIF_file_name = 'c87_TIRF-65nm.tif';
TRIF_file_name = 'c87_WF_2x.tif';
SIM_file_name = 're-rolling-c87.tif';

[img_TIRF, tirf_num] = tiffread(TRIF_file_name,[1, 1200]);
img_TIRF = ImagIntensity_Align(img_TIRF);

% info = imfinfo(SIM_file_name);
% img_SIM = tiffread(SIM_file_name,[1 SIM_num]);
% img_SIM = double(img_SIM);

bw_TIRF = atrous_threshold(img_TIRF(:,:,1));
boxs  = regionprops(bw_TIRF,'BoundingBox');
subplot(2,1,1)
imshow(img_TIRF(:,:,1),[]);
subplot(2,1,2)
imshow(bw_TIRF);

tic
all_profile = TIRF_Z_Profile(img_TIRF,boxs);
toc
Detecte_Event(all_profile,1);
% z_profie = gather(z_profie);
% for ii = 1:size(boxs,1)
%     figure
%     plot(all_profile(ii,:));
% end
% for ii = 1:10
% figure(2), colormap(gray)
% imagesc(regoin1(:,:,ii));
nmb = 1;
% end
%% obtained the ROI in the SIM's image
% ROI_SIM = GetROI_SIM(img_TIRF,img_SIM);

%% find particles in the ROI_SIM image
% V = FindParticles(ROI_SIM,3,3);

%% linking points
least_fram = 4;
% DV = Point_Linking(V, 1.5,least_fram);

%% Gaussian fitting
% FitResult = Point_Fitting(img_SIM,DV,2);
pixe_size = 32.5; %nanometer
% Precise =  Localization_Precise(FitResult,pixe_size);
% recon = FittingResult_Reconstru(FitResult);



%% display

