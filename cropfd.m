clear
load('D:\DataAnalysis\Chromavision\Emma\workspace_20190129-101111 Check new sample  #001-003.mat')
plot(dist.abs{1})

force.x{1}(1:2)=[];
force.y{1}(1:2)=[];
dist.abs{1}(1:2)=[];

plot(dist.abs{1})
save('D:\DataAnalysis\Chromavision\Emma\workspace_20190129-101111 Check new sample  #001-003_cropped.mat')