function y = adaptive_thresh(x,r)
% adaptive local thresholding method
% @x: inputted image
% @r: radius of the widow

%% debug option
debug_flag = 0;
if debug_flag
   x = imread('\data\input.png'); 
   r = 3;
end
%% 
p = 2;q = 10;R = 0.6;k = 0.25;

im = double(x);
lf =  ceil(r/2);
sz = size(x);
y = zeros(sz);
% normaliztion of the inputted image
nl_x = (im - min(im(:)))./(max(im(:)) - min(im(:)));
% extension of the image
temp  = wextend('2D','zpd',nl_x,[lf,lf]);
h = ones(r)./(r.^2); 
Ex = conv2(temp,h); %E(x)
Ex2 = conv2(temp.^2,h);%E(x^2)
Ex_raw = keepLOC(Ex,sz); %keep the size as same as inputted image
Ex2_raw = keepLOC(Ex2,sz);%keep the size as same as inputted image
Sx = real(sqrt(Ex2_raw - Ex_raw.^2));% Sx = sqrt(E(x)^2 - E(x^2))

% seek the threshold value 
Thr = Ex_raw.*(1 +p*exp(-q.*Ex_raw) + k*(Sx./R -1));
diff = nl_x - Thr;

diff_line = diff(:);
less_index = find(diff_line<0);
if ~isempty(less_index)
    diff_line(less_index) = 0;
end
result = reshape(diff_line,sz);
y = logical(result);

if debug_flag
    close all;
    imshow(y);
end
end

%---------------------------------------------------------
function y = keepLOC(z,siz)
    sz = size(z);
    first = round((sz - siz)/2);
    last = first+siz-1;
    y = z(first(1):last(1),first(2):last(2),:);
end