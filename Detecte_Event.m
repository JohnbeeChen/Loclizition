function varargout = Detecte_Event(profiles,n)
% nmb

[num,len] = size(profiles);
scale = n;

swt_value = My_SWT(profiles,scale);
event_infos = VectorsFindPeaks(swt_value);

for ii = 1:num
    if ~isempty(event_infos{ii})
        start_loc = event_infos{ii}{5}(:,1);
        end_loc = event_infos{ii}{5}(:,2);
        botom_value = event_infos{ii}{1}(:) - event_infos{ii}{4}(:);
        n = 3;
        figure
        subplot(n,1,1)
        plot(profiles(ii,:));
        
        subplot(n,1,2)
        plot(swt_value(ii,:));
        hold on
        plot(start_loc,botom_value,'r.');
        plot(end_loc,botom_value,'b.');
        hold off
        
        subplot(n,1,3)
        plot(profiles(ii,:));
        hold on
        plot(swt_value(ii,:));
        hold off
        %     subplot(n,1,4)
        %     plot(diffs(ii,:));
        nmb = 1;
    end
end
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

