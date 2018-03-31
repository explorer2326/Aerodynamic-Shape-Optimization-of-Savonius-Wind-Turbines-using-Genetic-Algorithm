RECORD = dlmread ('RESULT.txt');
INPUT = RECORD(:,1:6);
OUTPUT = RECORD(:,7);
colormap(jet);

for iter = (102:121)
I = INPUT(iter,:);
f = (OUTPUT(iter)-6)/18;colorbar;caxis([-10,10]);
cm = colormap; % returns the current color map
colorID = max(1, sum(f > [0:1/length(cm(:,1)):1])); 
myColor = cm(colorID, :); % returns your color
X = I(1:3);
Y = I(4:6);
M = [0, X, 100];
N = [0, Y, 0];
CURP = [M/100;N/100];
CURV = cscvn(CURP);
points = fnplt(CURV);
plot(points(1,:),points(2,:),'Color',myColor,'LineWidth',6);
axis equal;
axis ([-0.1 1.1 0 0.75]);
hold on;
end