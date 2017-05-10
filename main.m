close all;
% clear;
clc;
addpath([cd '/data']);
addpath([cd '/data/c87']);
addpath([cd '/detection']);
addpath([cd '/common']);
addpath([cd '/Threshold']);
addpath([cd '/GaussianFit']);
addpath([cd '/Forms']);
% addpath([cd '/pack_emd']);
% addpath([cd '/package_emd']);
% addpath([cd '/package_emd/EMDs']);
% addpath([cd '/package_emd/EMDs/src']);

% TIRF_num = 3;
% SIM_num = 3*TIRF_num;
%% read imgae
% SIM_file_name = 'c87-sim-32.5nm.tif';
% TRIF_file_name = 'c87_TIRF-65nm.tif';
tirf_file_name = 'c87_WF_2x.tif';
sim_file_name = 're-rolling-c87.tif';

[img_tirf, tirf_num] = tiffread(tirf_file_name);
% img_TIRF = ImagIntensity_Align(img_TIRF);

% info = imfinfo(SIM_file_name);


bw_tirf = atrous_threshold(img_tirf(:,:,1));
boxs  = regionprops(bw_tirf,'BoundingBox');

tic
all_profile = TIRF_Z_Profile(img_tirf,boxs);
swt_value = My_SWT(all_profile,2);
event_infos = Detect_Event(swt_value);
% delet the null element in the cell
null_loc = cellfun('isempty',event_infos);
event_infos(null_loc) = [];
boxs(null_loc) = [];
sim_event_info = TIRF_Event2SIM(event_infos);
disp('detect event is completed');

[img_sim,sim_num] = tiffread(sim_file_name);
img_sim = double(img_sim);

toc

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


