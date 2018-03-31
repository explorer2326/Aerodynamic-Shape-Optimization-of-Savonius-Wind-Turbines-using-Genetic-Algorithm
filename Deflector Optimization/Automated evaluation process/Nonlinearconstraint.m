function [c,ceq] = nonlc2(x)
x1 = x(1); x2 = x(2); x3 = x(3); y1 = x(4); y2 = x(5); y3 = x(6);
%upper bound
c(1) = x1^2 + y1^2 -40000;
c(2) = x2^2 + y2^2 -40000;
c(3) = x3^2 + y3^2 -40000;
%itermediate relationship
c(4) = 100-(x1-x2)^2-(y1-y2)^2;
c(5) = 100-(x3-x2)^2-(y3-y2)^2;
k1 = y1/x1; k2 = y2/x2;k3 = y3/x3;
k4 = (y2-y1)/(x2-x1);k5 = (y3-y2)/(x3-x2);
c(6) = 1 + k4*k5+k5-k4;
%lower bound
CURP = [x1 x2 x3;y1 y2 y3];
CURV = cscvn(CURP);
points = fnplt(CURV);
a = points(1,:);
f = points(2,:);
num = length(points);
for pointid = 1:num,
c(6+pointid) = 15625 - a(pointid)^2 - f(pointid)^2;
end
c = c';
ceq = [];
end
