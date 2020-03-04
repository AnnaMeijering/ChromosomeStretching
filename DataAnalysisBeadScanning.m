% Data Analysis of force scanning data: 20181205 mol#10 (Fixed Bead) and
% 20190404 exp6 (Scan Trap). 

forceScanTrap=data.FD_Data.Force_Channel_1__pN_.data;
timeScanTrap=data.FD_Data.Time__ms_.data;
distScanTrap=timeScanTrap/1000*0.2;
maxforceScanTrap = find(forceScanTrap==max(forceScanTrap));
minforceScanTrap = find(forceScanTrap==min(forceScanTrap));
mid = floor(mean([minforceScanTrap,maxforceScanTrap]));
midforceScanTrap = forceScanTrap(mid);
norm1forceScanTrap = forceScanTrap-midforceScanTrap;
norm2forceScanTrap = norm1forceScanTrap/max(norm1forceScanTrap);
norm2distScanTrap = distScanTrap-distScanTrap(mid);


forceFixedBead=data.FD_Data.Force_Channel_1__pN_.data;
timeFixedBead=data.FD_Data.Time__ms_.data;
distFixedBead=timeFixedBead/1000*0.1;
maxforceFixedBead = find(forceFixedBead==max(forceFixedBead));
minforceFixedBead = find(forceFixedBead==min(forceFixedBead));
midFixedBead = floor(mean([minforceFixedBead,maxforceFixedBead]));
midforceFixedBead = forceFixedBead(midFixedBead);
norm1forceFixedBead = forceFixedBead-midforceFixedBead;
norm2forceFixedBead = norm1forceFixedBead/max(norm1forceFixedBead);
norm2distFixedBead = distFixedBead-distFixedBead(midFixedBead);

figure
plot(norm2distScanTrap,norm2forceScanTrap)
hold on
plot(norm2distFixedBead,norm2forceFixedBead)
hold off