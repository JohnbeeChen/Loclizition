function varargout = Detecte_Event(profiles,varargin)
% nmb

[num,len] = size(profiles);

if nargin == 0
    step = 1;
else
    step = abs(varargin{1});
end
% profiles_next = profiles(:,(step+1) : len);
% profiles_new = profiles(:,1:(len - step));
diffs = my_diff(profiles,1);
meds = my_med(profiles);
diffs_mean =  my_diff(meds,1);
swt_value = My_SWT(profiles);
for ii = 1:num
    figure
    subplot(4,1,1)
    plot(profiles(ii,:));
    subplot(4,1,2)
    plot(diffs(ii,:));
    subplot(4,1,3)
    plot(meds(ii,:));
    hold on
    plot(profiles(ii,:));
    hold off
    subplot(4,1,4)
    plot(diffs_mean(ii,:));
    nmb = 1;
end
varargout{1} = 1;

end

function y = my_diff(x,step)

profiles = x;
len = size(x,2);
profiles_next = profiles(:,(step+1) : len);
profiles_new = profiles(:,1:(len - step));
y = profiles_next - profiles_new;
end
function y = mean_filter(x,n)

num = size(x,1);
for ii = 1:num
    a = x(ii,:);
    %     n=10; %
    mean = ones(1,n)./n;  %
    t = conv(a,mean);
    tem = t(1:length(t)-length(mean)+1);
    y(ii,:) = tem;
end
end

function y = my_med(x)

num = size(x,1);
y = zeros(size(x));
for ii = 1:num
    
    tem = x(ii,:);
    imf = emd(tem);
    if max(tem) < 50
        tem = sum(imf(5:end,:),1);
    else
        tem = sum(imf(4:end,:),1);
    end
    y(ii,:) = tem;
end

end

