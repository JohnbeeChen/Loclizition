close all;
clear;
clc;
addpath([cd '/data']);
% addpath([cd '/PALM']);
addpath([cd '/detection']);
addpath([cd '/common']);
addpath([cd '/Threshold']);
addpath([cd '/GaussianFit']);
tic
TIRF_num = 3;
SIM_num = 3*TIRF_num;
%% read imgae
SIM_file_name = 'c87-sim-32.5nm.tif';
TRIF_file_name = 'c87_TIRF-65nm.tif';

img_TRIF = tiffread(TRIF_file_name,[1 TIRF_num]);
img_TRIF = double(img_TRIF);
% figure,colormap(gray);
% imagesc(img_TRIF);

img_SIM = tiffread(SIM_file_name,[1 SIM_num]);
img_SIM = double(img_SIM);


%% obtained the ROI in the SIM's image
ROI_SIM = GetROI_SIM(img_TRIF,img_SIM);

%% find particles in the ROI_SIM image
V = FindParticles(ROI_SIM,3,3);

%% linking points
least_fram = 4;
DV = Point_Linking(V, 1.5,least_fram);

%% Gaussian fitting
FitResult = Point_Fitting(img_SIM,DV,2);
pixe_size = 32.5; %nanometer
Precise =  Localization_Precise(FitResult,pixe_size);
toc

%% display
for ii = 1:1
figure(1),colormap(gray)
imagesc(img_SIM(:,:,ii));
hold on 
% plot(Precise{ii}(:,3),FitResult{ii}(:,4),'r.');
plot(FitResult{ii}(:,3),FitResult{ii}(:,4),'r.');
% plot(DV(ii).trackInfo(:,3),DV(ii).trackInfo(:,4),'b*');
nmb = 1;
end
