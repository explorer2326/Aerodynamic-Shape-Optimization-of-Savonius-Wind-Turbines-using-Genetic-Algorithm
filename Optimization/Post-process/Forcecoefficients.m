%POSTPROCESSOR
TSR=0.8;
myfilename = sprintf('CT-SUM');
M = dlmread (myfilename,'',[4140 1 4320 1]);
u=(0:180);
hold on;
plot(u,M,'b-','LineWidth',7);
mean(M)*TSR