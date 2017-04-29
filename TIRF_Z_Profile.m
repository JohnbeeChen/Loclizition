function varargout = TIRF_Z_Profile(tirf_in,bound_box)

gpu_tirf = gpuArray(tirf_in);
boxs = bound_box;
imgs_num = size(tirf_in,3);
regoin_num = size(bound_box,1);
% star_points = boxs{:}(1:2);
% delete(gcp('nocreate'))
% parpool(2)
for ii = 1: regoin_num
    t = boxs(ii).BoundingBox;
    start_point = t(1:2) + 0.5;
    end_point = start_point + t(3:4) - 1;
    com = start_point(1):end_point(1);
    row = start_point(2):end_point(2);
    tem_regoin = gpu_tirf(row,com,:);
    parfor jj = 1:imgs_num
        tem = tem_regoin(:,:,jj);
        profile(ii,jj) = sum(tem(:));
    end
end
varargout{1} = gather(profile);
end