X = [-147.060625 -147.761589345791 -56.6178827652612 57.12175 77.6264465052658 191.705287100066];
%PUBLISHED[-123.83 -122.83 -109.99 45.39 50.6147 117.7];

x1 = X(1); x2 = X(2); x3 = X(3); y1 = X(4); y2 = X(5); y3 = X(6);

CURP = [x1 x2 x3;y1 y2 y3];
CURV = cscvn(CURP);
points = fnplt(CURV);
straight = linspace(-200,-125);
axi = zeros(100,1);
circle(0,0,115,'k--');
hold on;
arc(0,0,200,'k-',90,180);
arc(0,0,125,'k-',90,180);
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
circle_down(-50,0,50,'k-');
circle_up(50,0,50,'k-');
hold on;
axis equal;
plot(points(1,:),points(2,:),'k-','LineWidth',3);
scatter(x1,y1,100,'k','filled');
scatter(x2,y2,100,'k','filled');
scatter(x3,y3,100,'k','filled');
plot(axi,-straight,'k-');
plot(straight,axi,'k-');
axis([-200 115 -115 200]);