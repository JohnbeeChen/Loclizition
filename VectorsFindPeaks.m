function varargout = VectorsFindPeaks(inVectors)

num = size(inVectors,1);

for ii = 1 : num
    My_FindPeaks(inVectors(ii,:));
    [pks,locs,widths,proms] = findpeaks(inVectors(ii,:));
    peaks_infos{ii}(1,:) = pks;
    peaks_infos{ii}(2,:) = locs;
    peaks_infos{ii}(3,:) = widths;
    peaks_infos{ii}(4,:) = proms;
end
varargout{1} = peaks_infos;


function varargout = My_FindPeaks(inVector)
% find a 1D signal's peaks and other information

[pks,locs,widths,proms] = findpeaks(inVector);
num = length(pks);
for ii = 1:num
    tem = inVector - proms(ii);
end