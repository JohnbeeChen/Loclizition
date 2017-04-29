function varargout = ImagIntensity_Align(imagsIn)

nums = size(imagsIn,3);
if nums < 2
   varargout{1} = -1;
   return;
end
imags = imagsIn;
image1 = imags(:,:,1);
intensity_sum1 = sum(image1(:));
for ii = 2:nums
    tem_imag = imags(:,:,ii);
    tem_intensity = sum(tem_imag(:));
    alpha = intensity_sum1/tem_intensity;
    imags(:,:,ii) = imags(:,:,ii) * alpha;
end
varargout{1} = imags;
end