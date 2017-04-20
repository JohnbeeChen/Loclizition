close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/ExtractSposts']);
addpath([cd '/GaussianFit']);
addpath([cd '/Threshold']);
addpath([cd '/Denoising']);
addpath([cd '/MS_VST']);
addpath([cd '/detection']);
addpath([cd '/common']);

%% read imgae
% file_name = 'cell-1-bleaching.tif';
% file_name = 'c87_TIRF-65nm.tif';
file_name = 'C1-H_cell2_647.tif';

%% read tiff image
img = tiffread(file_name,1);
img = double(img);

V = findParticles(img,4);
figure,colormap(gray);
imagesc(img);
hold on 
plot(V(:,1),V(:,2),'r.');

fit_radiul = 4;
pixel_size = 107; %nanometers
tic
[center,uncen] = PALM_Fitting(img,V,fit_radiul,pixel_size);
t = toc
figure,colormap(gray);
imagesc(img);
hold on 
plot(center(:,1),center(:,2),'r.');

nmb = 1;

