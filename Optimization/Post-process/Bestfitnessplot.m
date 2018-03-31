RECORD = dlmread ('RESULT.txt');
OUTPUT = RECORD(:,7);
colormap(jet);
for i=0:19
    Cp=[];
for iter = (20*i+2:20*i+21)
f = OUTPUT(iter);
Cp=[Cp f];
end
as = sort(Cp);
best = as(20);
fig1 = scatter((i+1),best,200,'b','filled');
hold on;
end
xlabel('Generation');ylabel('Power Coefficient(%)');
titlename=['Best Fitness Value'];
filename=['BestFitness.jpeg'];
title(titlename,'FontSize', 20);
saveas(fig1,filename);