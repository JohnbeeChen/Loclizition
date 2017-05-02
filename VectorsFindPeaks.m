function varargout = VectorsFindPeaks(inVectors)
% find m's 1D signal's peaks and other information where m is the number of
% the row of the inVectors

num = size(inVectors,1);

parfor ii = 1 : num
    
    event_iffos{ii} = My_FindPeaks(inVectors(ii,:));
%     [pks,locs,widths,proms] = findpeaks(inVectors(ii,:));
%     peaks_infos{ii}(1,:) = pks;
%     peaks_infos{ii}(2,:) = locs;
%     peaks_infos{ii}(3,:) = widths;
%     peaks_infos{ii}(4,:) = proms;
end
varargout{1} = event_iffos;


function varargout = My_FindPeaks(inVector)
% find a 1D signal's peaks and other information

[pks,locs,widths,proms] = findpeaks(inVector);
pks_info = [pks; locs;widths;proms];
mean_proms = mean(proms(:));
id = pks_info(4,:) < mean_proms;
pks_info(:,id) = [];
num = size(pks_info,2);
event_duration = zeros(num,3);
for ii = 1:num
    tem = inVector - pks_info(1,ii)+ pks_info(4,ii) - 1;
    tem(tem<0) = 0;
    zeros_loc = find(~tem);

    satrt_loc = find(zeros_loc < pks_info(2,ii),1,'first');
    end_loc = find(zeros_loc > pks_info(2,ii),1,'first');
    event_duration(ii,1:2) = [zeros_loc(satrt_loc),zeros_loc(end_loc)];
    event_duration(ii,3) =  event_duration(ii,2) -  event_duration(ii,1);
%     subplot(2,1,1),plot(inVector);
%     subplot(2,1,2),plot(tem);
%     
%     nmb = 1;
end
events_infos = mat2cell(pks_info,[1,1,1,1]);
events_infos{3} = event_duration;
varargout{1} = events_infos;