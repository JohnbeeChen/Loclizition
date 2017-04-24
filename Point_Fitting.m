function varargout = Point_Fitting(img_in,DV,radius)

frams_num = size(DV,1);
img = img_in;
radius = int32(radius);
% fit_lentgh = 2*radius + 1;
FittingInfos = cell(frams_num,1);
gray2photon_coefficent = 1/(0.8*0.46);
size_img = size(img(:,:,1));
% fit_strat_point(:,1) = in_centroid(:,1) - radius; %start point
% fit_strat_point(:,2) = in_centroid(:,2) - radius;

%[start_fram,stop_fram,xc_fit,yc_fit,x_uncertiance,y_uncertiance,Num_photon,b_noise]
parfor ii = 1 : frams_num
    tem_points = DV{ii};
    points_num = size(tem_points,1);
    fitting_info = zeros(points_num,8);
    for jj = 1 : points_num
        start_fram = tem_points(jj,1);
        stop_fram = tem_points(jj,2);
        tem_img = img(:,:,start_fram:stop_fram);
        tem_img = mulity_img_add(tem_img);
        xc = int16(tem_points(jj,3));
        yc = int16(tem_points(jj,4));

        [fit_result,fit_gof] = GaussianFit2D(tem_img,[xc,yc],radius);
        amp = fit_result.amp;
        % standard deviation of each direction (nanometres)
        std_devia = [fit_result.sigmax,fit_result.sigmay];
        bg_noise = gray2photon_coefficent * fit_gof.rmse;
        photons_num = 2*pi*gray2photon_coefficent*amp*std_devia(1)*std_devia(2);
        
        fitting_info(jj,1) = start_fram;
        fitting_info(jj,2) = stop_fram;
        fitting_info(jj,3) = fit_result.x0;       
        fitting_info(jj,4) = fit_result.y0;  
        fitting_info(jj,5) = fit_result.sigmax;       
        fitting_info(jj,6) = fit_result.sigmay;  
        fitting_info(jj,7) = photons_num;       
        fitting_info(jj,8) = bg_noise;          
    end
    t = size_img;
    id = fitting_info(:,3) < 0;
    fitting_info(id,:) = [];
    id = fitting_info(:,3) > t(2);
    fitting_info(id,:) = [];
    id = fitting_info(:,4) < 0;
    fitting_info(id,:) = [];
    id = fitting_info(:,4) > t(1);
    fitting_info(id,:) = [];    
    FittingInfos{ii} = fitting_info;
end
varargout{1} = FittingInfos;
end

function y = mulity_img_add(imgs)

sz = size(imgs,3);
y = zeros(size(imgs(:,:,1)));
for ii = 1:sz
    y = y + imgs(:,:,ii);
end
end