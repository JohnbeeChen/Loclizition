function varargout = global_threshold(X,thres)
% @X    : input image
% @thres: the level of the threshold where thres in 0 to 1

img = double(X);
k = thres;

max_v = max(img(:));
min_v = min(img(:));

tem = min_v + k*(max_v - min_v);

bw = zeros(size(img));
bw(img>tem) = 1;

if nargout == 1
    varargout{1} = logical(bw);   
end
end