NumStretch = 1; 

I50pN=find(force.x{NumStretch}>50);
I150pN=find(force.x{NumStretch}>250);

DistFit = dist.abs{NumStretch}(I50pN(1):I150pN(1));
ForceFit = force.x{NumStretch}(I50pN(1):I150pN(1));

P = polyfit(DistFit,ForceFit,1);
yfit = P(1)*dist.abs{NumStretch}+P(2);

figure
plot(dist.abs{NumStretch},force.x{NumStretch}) 
hold on;
plot(dist.abs{NumStretch},yfit,'r-.');


