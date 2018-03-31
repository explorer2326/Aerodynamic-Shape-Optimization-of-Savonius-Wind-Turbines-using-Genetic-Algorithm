RECORD = dlmread ('RESULT.txt');
OUTPUT = RECORD(:,7);


for iter = (1:20)
f = mat(iter,7);
fig1 = scatter((i+1),f,200,'r','LineWidth',2);
axis ([0 15 0 36]);
hold on;
end
end
xlabel('Generation');ylabel('Power Coefficient(%)');
titlename=['Fitness Value'];
filename=['Fitness.jpeg'];
title(titlename,'FontSize', 55);
saveas(fig1,filename);