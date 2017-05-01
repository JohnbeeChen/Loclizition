function varargout = A_TrousWT1(x,n)
% 1-D signals a trous wavelet transform
% @x: input sigals which can be a comlou vector or a matrix
% @n: scale

h = [1 4 6 4 1]/16;
y = x;
d = cell(n,1);
modeDWT = 'per';
for ii = 1:n
    lf = length(h);
    y  = wextend('1D',modeDWT,y,lf/2);
    t = conv2(y,h,'same');
    if nargin == 2
        d{ii} = y - t;
    end
    y = t;
    h = dyadup(h,'m',0);
end
% for ii = 1:num
%     signal = x(ii,:);
%     [y(ii,:),] = swt(signal,2,'db2');
% end
varargout{1} = y;
if nargin == 2
    varargout{2} = d;
end


%%---------------------------------------------------------
function ca = decomposeLOC(x,h)
% Modification for geck G980781
size2D = size(x);
% Extension.
lf    = ceil(length(h)/2);
temp  = wextend('2D','sym',x,[lf,lf]);
y = conv2(temp,h);  % 'single' replaced by 'double'
ca = keepLOC(y,size2D);


%%---------------------------------------------------------
function y = keepLOC(z,siz)
sz = size(z);
first = round((sz - siz)/2) +1;
last = first+siz-1;
y = z(first(1):last(1),first(2):last(2),:);
