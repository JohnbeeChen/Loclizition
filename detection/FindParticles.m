function varargout = FindParticles(img_in,siz,thk)


debug_display = 0;
threshold = thk;
A = img_in;
img_num = size(A,3);
s = siz;
if img_num == 0
    varargout{1} = -1;
    return;
end

parfor ii = 1 : img_num
img = A(:,:,ii);   
[W2 W3]=waveletTransform(img,1,threshold);
bw = im2bw(W2);
bw = bwareaopen(bw,4);
W = bw .* W2;
temp = weightedcentrid(W,s);  
mean_SIM = mean(img(:));
id = temp(:,3) < 0.6*mean_SIM;
temp(id,:) = [];
V{ii} = temp;
% nmb = 1;
end
varargout{1} = V;

end