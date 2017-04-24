close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/PALM']);
addpath([cd '/detection']);
addpath([cd '/common']);
addpath([cd '/Threshold']);

TIRF_num = 10;
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

tic
%% obtained the ROI in the SIM's image
ROI_SIM = GetROI_SIM(img_TRIF,img_SIM);

%% find particles in the ROI_SIM image
V = FindParticles(ROI_SIM,3,3);

%% linking points
least_fram = 4;
DV = Point_Linking(V, 1.5,least_fram);

toc

%% display
for ii = 1:1
figure(1),colormap(gray)
imagesc(img_SIM(:,:,ii));
hold on 
plot(V{ii}(:,1),V{ii}(:,2),'r.');
% plot(DV(ii).trackInfo(:,3),DV(ii).trackInfo(:,4),'b*');
nmb = 1;
end
