close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/PALM']);
addpath([cd '/detection']);
addpath([cd '/common']);
addpath([cd '/Threshold']);
%% read imgae
SIM_file_name = 'c87-sim-32.5nm.tif';
TRIF_file_name = 'c87_TIRF-65nm.tif';

t = Tiff(SIM_file_name,'r');