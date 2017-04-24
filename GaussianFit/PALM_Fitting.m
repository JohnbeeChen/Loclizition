function varargout = PALM_Fitting(X,peaks,radius,pixe_size)


img_in = X;
region_num = size(peaks,1);
if region_num == 0
    varargout{1} = -1;
    return;
end
% Initial the
img_sz = size(img_in);
fit_lentgh = 2*int32(radius) + 1;
in_centroid = int32(peaks(:,1:2));
fit_strat_point(:,1) = in_centroid(:,1) - radius; %start point
fit_strat_point(:,2) = in_centroid(:,2) - radius;

gray2photon_coefficent = 10.0/300;

centroid = zeros(region_num,2);
uncertain = centroid;
bg_noise = zeros(1,region_num);
photons_num = zeros(1,region_num);

parfor ii = 1:region_num
    start_p = fit_strat_point;
    img_size = img_sz;
    box_x = 1 : fit_lentgh; box_x = box_x + start_p(ii,1) - 1;
    box_y = 1 : fit_lentgh; box_y = box_y +  start_p(ii,2) - 1;
    % avoid the overflowed indexes
    box_x(box_x<1) = [];box_x(box_x>img_size(2)) = [];
    box_y(box_y<1) = [];box_y(box_y>img_size(1)) = [];    
    % notice: the location of the coordinates is different
    fit_img = img_in(box_y,box_x);
%     [xc,yc,amp,width] = gauss2dcirc(fit_img,1);
    wdx = 1;wdy = 1;
    amp = peaks(ii,3);
    [Y,X] = meshgrid(box_y,box_x);

    [fit_result,fit_gof] = createFit1(X(:),Y(:),fit_img(:),in_centroid(ii,1),in_centroid(ii,2),wdx,wdy,amp);
    centroid(ii,:) = [fit_result.x0,fit_result.y0];
    amp = fit_result.amp;
    % standard deviation of each direction (nanometres)
    std_devia = [fit_result.sigmax,fit_result.sigmay];
    bg_noise(ii) = gray2photon_coefficent * fit_gof.rmse;
    photons_num(ii) = 2*pi*gray2photon_coefficent*amp*std_devia(1)*std_devia(2);
    
    %% estimates the uncentains of the centrid
    N = photons_num(ii);
    b = bg_noise(ii);
    a = pixe_size;

    term = zeros(3,2);
    term(1,:) = a*std_devia.^2/N;
    term(2,:) = a.^2/12/N;
    term(3,:) = 8*pi*b.^2.*a^2*std_devia.^4/(N.^2);
    uncertain(ii,:) = sqrt(sum(term));
    centroid(ii,:) = [fit_result.x0,fit_result.y0];
    nmb = 1;
end

if nargout >= 1
    varargout{1} = centroid;
end
if nargout == 2
    varargout{2} = uncertain;
end
end

