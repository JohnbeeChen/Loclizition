close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/PALM']);
addpath([cd '/detection']);
addpath([cd '/common']);
addpath([cd '/Threshold']);

 spmd 
 A = rand(3,2);
 end
 for i = 1: length(A)
     figure;imagesc(A{i});
 end