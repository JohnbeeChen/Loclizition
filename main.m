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

%% read imgae
tirf_file_name = 'c87_WF_2x.tif';
sim_file_name = 're-rolling-c87.tif';

[img_tirf, tirf_num] = tiffread(tirf_file_name);
% img_TIRF = ImagIntensity_Align(img_TIRF);

%gets the boxs of each region which events might occur
bw_tirf = atrous_threshold(img_tirf(:,:,1));
boxs  = regionprops(bw_tirf,'BoundingBox');

tic
%gets the z_profiles of each region in the @img_tirf
all_profile = TIRF_Z_Profile(img_tirf,boxs);

%makes the all profiles in @all_profile be more smooth
profile_smooth = My_SWT(all_profile,2);

%detects all event in @profile_smooth
event_infos = Detect_Event(profile_smooth);

% delet the null element in the cell @event_infos
null_loc = cellfun('isempty',event_infos);
event_infos(null_loc) = [];
boxs(null_loc) = [];

%converts the the event infos @evetn_infos to @sim_event_info
sim_event_info = TIRF_Event2SIM(event_infos);
disp('detect event is completed');

disp('fitting is ready'); 
[img_sim,sim_num] = tiffread(sim_file_name);
img_sim = double(img_sim);
result = SIM_Handle(img_sim,sim_event_info,boxs);

toc

