function varargout = Detecte_Event(profiles,n)
% nmb

[num,len] = size(profiles);
scale = n;

swt_value = My_SWT(profiles,scale);

% for ii = 1:num
%     n = 4;
%     figure
%     subplot(n,1,1)
%     plot(profiles(ii,:));
%     subplot(n,1,2)
%     plot(swt_value(ii,:));
%     subplot(n,1,3)
%     plot(profiles(ii,:));
%     hold on
%     plot(swt_value(ii,:));
%     hold off
%     subplot(n,1,4)
%     plot(diffs(ii,:));
%     nmb = 1;
% end
varargout{1} = swt_value;

end

function y = my_diff(x,step)

profiles = x;
len = size(x,2);
profiles_next = profiles(:,(step+1) : len);
profiles_new = profiles(:,1:(len - step));
y = profiles_next - profiles_new;
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

