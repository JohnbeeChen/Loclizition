function varargout = JudgeSamePoint(point1,point2,pixelSize)
% input points like this[xc,yc,sigma_x,sigma_y]

y1 = IsInEllipse(point1,point2(1:2),pixelSize);
y2 = IsInEllipse(point2,point1(1:2),pixelSize);

if y1*y2 == 1
    flag = 1;% the two points are the same point
elseif y1 + y2 == 0
    flag = 2;% the two points are totally different
else
    flag = 3;% the two points may be same or not a point
end
varargout{1} = flag;

function y = IsInEllipse(myEllipse,point,pixelSize)
% the input ellipse @myEllipse just like this[xc,yc,a,b]
% the input point @point_x just like this[x0,y0]

elli_point = myEllipse(1:2);
elli_axis = myEllipse(3:4)./pixelSize;
tem = (point - elli_point).^2./elli_axis;
tem = sum(tem) - 1;
if tem > 0
    y = 0;
else 
    y =1;
end
