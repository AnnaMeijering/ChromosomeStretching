[Xcoords Ycoords Ntraces]=loadcoords();

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

figure
for k=1:Ntraces-1
Xdiffabs{k}=Xtraces{k+1}-Xtraces{k};
Xdiffrel{k}=(Xdiffabs{k}-Xdiffabs{k}(1))/Xdiffabs{k}(1);
Xtotaldiffrel(k)=Xdiffrel{k}(end);
    
plot(Tlist,Xdiffrel{k})
hold on

end
xlabel('Time (s)')
ylabel('Relative length change')
hold off

MeanIntensities=[678.586 760.331 881.618 605.978 719.299];
figure
scatter(MeanIntensities-267.312,Xtotaldiffrel)
xlabel('Histone intensity (a.u.)')
ylabel('Relative extension')
