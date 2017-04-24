function [centroid, uncertain] = SMM_Localization(img_in,regoin_bound,pixel_size)
% Localization Accuracy in Single-Molecule Microscopy
% @img_in: input image
% @regoin_bound: the bound of  each union region in the img_in
% @pixel_size: pixe size of the detector (nanometres)
% @ceteroid: centroid of each region (pixel local)
% @uncertain: uncertain of each ceteroid  (nanometres)

% author: Johnbee<Tianjiu14@outlook.com>
% date: 2017/04/01

% Gets the number of the regoin
region_num = size(regoin_bound,1);
if region_num == 0
    centroid = [-1 -1];
    uncertain = centroid;
    return;
end
% Initial the output parameter
centroid = zeros(region_num,2);
uncertain = centroid;
gray2photon_coefficent = 10.0/300;
for ii = 1:region_num
    box_x = 1 : regoin_bound(ii,3); box_x = box_x + floor(regoin_bound(ii,1));
    box_y = 1 : regoin_bound(ii,4); box_y = box_y + floor(regoin_bound(ii,2));
    % notice: the location of the coordinates is different
    fit_img = img_in(box_y,box_x);
    
    %% Fitting of the Gaussian Distribution
    [Y,X] = meshgrid(box_y,box_x);
    % Firstly to estimate the parameters of the Gaussian Distribution
%     [xc,yc,amp,wdx,wdy] = gauss2dellipse(fit_img(:),X(:),Y(:),1);
    [xc,yc,amp,width] = gauss2dcirc(fit_img,1);
    wdx = width;wdy = width;
    % Optimizes the parameters of the Gaussian Distribution
    [fit_result,fit_gof] = createFit1(X(:),Y(:),fit_img(:),xc,yc,wdx,wdy,amp);
    % Gets the estimator of the background noise
    % rmse means that Root Mean Squeard Error
    bg_noise = gray2photon_coefficent * fit_gof.rmse;
    % Gets the distribution of the result of the fitting
    %     p = gaussian_distri2(fit_result.x0,fit_result.y0,fit_result.sigmax,fit_result.sigmay,box_x,box_y);
    %     p = gaussian_distri2(xc,yc,wdx,wdy,box_x,box_y);
    
    % Estimates the total number of photons in the spot
    %     photons_num = sum(fit_img(:).*p(:))./sum(p(:).^2);
    photons_num = gray2photon_coefficent*amp*wdx*wdy;
%     error_fit = (amp*p - fit_img).^2;
%     bg_noise = sqrt(sum(error_fit(:))/numel(fit_img));
    if 0
        %% Estimates the uncertainty of each direction
        N = photons_num;
        a = pixel_size;
        % standard deviation of each direction (nanometres)
        std_devia = a * [wdx, wdy];
        term = zeros(3,2);
        term(1,:) = std_devia.^2;
        term(2,:) = a.^2/12;
        term(3,:) = 8*pi*bg_noise.^2.*std_devia.^2/(a.^2 * N);
        uncertain(ii,:) = sqrt(sum(term)./N);
        centroid(ii,:) = [xc,yc];
    else
        %% Estimates the uncertainty of each direction
        N = photons_num;
        a = pixel_size;
        % standard deviation of each direction (nanometres)
        std_devia = a * [fit_result.sigmax, fit_result.sigmay];
        term = zeros(3,2);
        term(1,:) = std_devia.^2/N;
        term(2,:) = a.^2/12/N;
        term(3,:) = 8*pi*bg_noise.^2.*std_devia.^4/(a.^2 * N.^2);
        uncertain(ii,:) = sqrt(sum(term));
        centroid(ii,:) = [fit_result.x0,fit_result.y0];
        nmb = [xc,yc,wdx,wdy];
        nmb = nmb;
    end
end