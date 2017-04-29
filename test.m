
% spmd
%   A = rand(3,2); 
% end
% for i = 1:length(A)
%    figure;imagesc(A{i}); 
% end
% tic
% Data = 1:100;  
% spmd  
%     switch labindex  
%         case 1  
%             Data = Data+1;  
%         case 2  
%             Data = Data+2;  
%     end  
% end  
% toc
% parpool('local')
% p  = gcp('nocreate');
% if isempty(p)
%     poolsize  = 0;
% else
%     poolsize = p.NumWorkers
% end
% delete(gcp('nocreate'))
% parpool(2)
% tic
% spmd
%    q = magic(labindex + 2); 
% end
% for ii  = 1 :length(q)
%     figure;imagesc(q{ii});
% end
% toc
x=0:2047;  
a=load('data.txt');   %???data.txt?????????(current directory)?  
n=5; % n???????????  
mean = ones(1,n)./n;  %mean?1×n?????????????1/n  
y = conv(a,mean);  
y=y(1:length(y)-length(mean)+1);  
figure;  
subplot(1,2,1);plot(x,a);  
xlabel('????????');  
subplot(1,2,2);plot(x,y);  
xlabel('????????');  