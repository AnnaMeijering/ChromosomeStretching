
function [RelIntensities, Xtotaldiffrel,Xcontribution,orderedI,IntOrder]=fluorstretchinganalysis()
[Xcoords Ycoords Ntraces background intensities]=loadcoords();

for i=1:Ntraces
starts(i)=min(Ycoords{i});
ends(i)=max(Ycoords{i});
end

Tstart=cast(ceil(max(starts)),'double');
Tend=cast(floor(min(ends)),'double');
Tlist=(Tstart:1:Tend);

figure
for j=1:Ntraces
Xtraces{j}= interp1(Ycoords{j},Xcoords{j},Tlist);
plot(Tlist,Xtraces{j})
hold on

end
xlabel('Time (s)')
ylabel('Distance (px)')
hold off
TotalLengthChange=(Xtraces{Ntraces}(end)-Xtraces{Ntraces}(1))-(Xtraces{1}(end)-Xtraces{1}(1)); 

figure
for k=1:Ntraces-1
Xdiffabs{k}=Xtraces{k+1}-Xtraces{k};
Xdiffrel{k}=(Xdiffabs{k}-Xdiffabs{k}(1))/Xdiffabs{k}(1);
Xtotaldiffabs(k)=Xdiffabs{k}(end)-Xdiffabs{k}(1);
Xtotaldiffrel(k)=Xdiffrel{k}(end);
Xcontribution(k)=Xtotaldiffabs(k)/TotalLengthChange;
plot(Tlist,Xdiffrel{k})
hold on

end
xlabel('Time (s)')
ylabel('Relative length change')
hold off

if background<min(intensities)
MeanIntensities=intensities-background;
else 
    MeanIntensities=intensities-min(intensities);
end
[~,orderedI]=sort(intensities);
IntOrder=linspace(0,1,length(intensities));

RelIntensities=MeanIntensities/sum(MeanIntensities);
figure
scatter(RelIntensities,Xtotaldiffrel)
xlabel('Relative H2B-eGFP intensity (a.u.)')
ylabel('Relative extension')
end
