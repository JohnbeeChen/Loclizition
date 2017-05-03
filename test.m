A = swt_value;
num = size(A,1);
for ii = 1:num
    max_v = max(A(ii,:));
    min_v = min(A(ii,:));
    thre = 0.2 * (max_v - min_v);
    findpeaks(A(ii,:),'MinPeakProminence',thre,'Annotate','extents');
    nmb
end
