NumStretch = 7; 

I50pN=find(force.x{NumStretch}>50);
I150pN=find(force.x{NumStretch}>150);

DistFit = trap_distance{NumStretch}(I50pN(1):I150pN(1));
ForceFit = force.x{NumStretch}(I50pN(1):I150pN(1));

P = polyfit(DistFit,ForceFit,1);
yfit = P(1)*trap_distance{NumStretch}+P(2);

figure
plot(trap_distance{NumStretch},force.x{NumStretch}) 
hold on;
plot(trap_distance{NumStretch},yfit,'r-.');


