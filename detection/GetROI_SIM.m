function varargout = GetROI_SIM(img_tirf,img_sim)
% Gets the ROI of the sim image @img_sim by obtaining the union regions
% from the corresponding TIRF image @img_tirf
% Note : the numbel of the @img_sim is three times as much as @img_tirf
% Arthou : Johnbee
% Date   :2017/04/22


% debug_display = 0;
img_TRIF = img_tirf;
img_SIM = img_sim;
sz_t = size(img_TRIF,3);
sz_s = size(img_SIM,3);
if sz_s/sz_t ~= 3
    varargout{1} = -1;
    return;
end
ROI_SIM(:,:,sz_s) = zeros(size(img_SIM(:,:,1)));
bw_TIRF = ROI_SIM;
for ii = 1:sz_t
    W3_TRIF = Detection(img_TRIF(:,:,ii),0);
    bw = global_threshold(W3_TRIF,0.01);
    SE = strel('disk',2);
    bw = imopen(bw,SE);
    SE = strel('disk',2);
    bw_TIRF(:,:,ii) = imclose(bw,SE);
end
bw_TIRF = gpuArray(bw_TIRF);
img_SIM = gpuArray(img_SIM);
ROI_SIM = gpuArray(ROI_SIM);
for ii = 1:sz_s
   t = floor((ii+2)/3); 
   ROI_SIM(:,:,ii) = double(bw_TIRF(:,:,t)).*double(img_SIM(:,:,ii));
end
varargout{1} = gather(ROI_SIM);
end