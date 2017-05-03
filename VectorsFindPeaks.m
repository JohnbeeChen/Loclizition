function varargout = VectorsFindPeaks(inVectors)
% find m's 1D signal's peaks and other information where m is the number of
% the row of the inVectors

num = size(inVectors,1);

for ii = 1 : num
    
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
max_v = max(inVector(:));
min_v = min(inVector(:));
thre = 0.2 * (max_v - min_v);
[pks,locs,widths,proms] = findpeaks(inVector,'MinPeakProminence',thre);
if isempty(pks)
    varargout{1} = [];
    return;
end
pks_info = [pks; locs; widths; proms];

num = length(pks);
event_duration = zeros(num,3);
for ii = 1 : num
    % move the curve to half-high of the peak
    tem = inVector - pks(ii) + 0.5*proms(ii);
    tem(tem<0) = 0;
    zeros_locs = find(~tem);
    peak_loc =  locs(ii);
    % find the nearest zeors_locs in the left and right of the peak
    start_loc = find(zeros_locs < peak_loc,1,'last');
    end_loc = find(zeros_locs > peak_loc,1,'first');
    event_duration(ii,1:2) = [zeros_locs(start_loc),zeros_locs(end_loc)];
    event_duration(ii,3) =  event_duration(ii,2) -  event_duration(ii,1) + 1;
end
% %  I gave up to find the whole-high width for a while
% if 0
%     % 2 times half-heigh widths as the whole-high widths,it doesn't work well
%     % event start point
%     event_duration(:,1) = pks_info(2,:) - pks_info(3,:);
%     % event end point
%     event_duration(:,2) = pks_info(2,:) + pks_info(3,:);
%     event_duration(:,3) = 2 * pks_info(2,:) + 1;
%
% else % directly find the whole-high widths
%     for ii = 1:num
%         if isempty(pks)
%
%
%         else
%             tem = inVector - pks_info(1,ii)+ pks_info(4,ii) - 1;
%             tem(tem<0) = 0;
%             zeros_locs = find(~tem);
%             peak_loc =  pks_info(2,ii);
%             % find the nearest zeors_locs in the left and right of the peak
%             satrt_loc = find(zeros_locs < peak_loc,1,'last');
%             end_loc = find(zeros_locs > peak_loc,1,'first');
%             % find the minmum localiztion around the peak
%             [minmum_v,minimum_locs] = findpeaks(-tem,'MinPeakProminence',200);
%             if ~isempty(minimum_locs)
%                 left_mini_loc = find(minimum_locs < peak_loc,1,'last');
%                 right_mini_loc = find(minimum_locs > peak_loc,1,'first');
%             end
%
%             event_duration(ii,1:2) = [minimum_locs(left_mini_loc),minimum_locs(right_mini_loc)];
%             event_duration(ii,3) =  event_duration(ii,2) -  event_duration(ii,1) + 1;
%         end
%     end
% end
events_infos = mat2cell(pks_info,[1,1,1,1]);
events_infos{5} = event_duration;
varargout{1} = events_infos;