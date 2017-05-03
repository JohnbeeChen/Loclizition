A = swt_value;
num = size(A,1);
for ii = 1:num
    
   findpeaks(A(ii,:),'MinPeakProminence',1000,'Annotate','extents');
   nmb
end
