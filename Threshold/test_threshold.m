close all;
clear;
clc;
im = imread('\data\input.png');
r = 10;
y = adaptive_thresh(im,r);
imshow(y);