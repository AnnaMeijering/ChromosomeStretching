function test=boxplot_forcedrops()
[forcedrop,distchange,distchangerel,maxforce,stretchrank,pull_speed]=calc_distchangeafterstretches();

forces=[];
distances=[];
distrel=[];
maxf=[];
rank=[];

for i=1:length(forcedrop)
    forces=horzcat(forces,forcedrop{i});
    distances=horzcat(distances,distchange{i});
    distrel=horzcat(distrel,distchangerel{i});
    maxf=horzcat(maxf,maxforce{i});
    rank=horzcat(rank,stretchrank{i});
    
end
index_lowforce=find(maxf>0&maxf<150);
index_medforce=find(maxf>150&maxf<450);
index_highforce=find(maxf>450);

index_rank1=find(rank==1);
index_rank2=find(rank==2);
index_rank3=find(rank==3);
index_rank4=find(rank==4);

distno4=distances;
distrelno4=distrel;
rankno4=rank;
distno4(index_rank4)=[];
distrelno4(index_rank4)=[];
rankno4(index_rank4)=[];

figure
boxplot(distances(index_lowforce),rank(index_lowforce))
xlabel('Rank in stretch cycle')
ylabel('Chromosome length change (µm)')
title('Stretching to ~100pN')

figure
boxplot(distances(index_medforce),rank(index_medforce))
xlabel('Rank in stretch cycle')
ylabel('Chromosome length change (µm)')
title('Stretching to ~300pN')

figure
boxplot(distances(index_highforce),rank(index_highforce))
xlabel('Rank in stretch cycle')
ylabel('Chromosome length change (µm)')
title('Stretching to ~700pN')

figure
boxplot(distances,rank)
xlabel('Rank in stretch cycle')
ylabel('Chromosome length change (µm)')
title('All stretching cycles combined')

figure
boxplot(distno4,rankno4)
xlabel('Rank in stretch cycle')
ylabel('Chromosome length change (µm)')
title('All stretching cycles combined')

figure
boxplot(distrelno4,rankno4)
xlabel('Rank in stretch cycle')
ylabel('Relative chromosome length change (µm)')
title('All stretching cycles combined')

figure
boxplot(distances(index_rank1),pull_speed(index_rank1))
xlabel('Pulling speed (um/s)')
ylabel('Chromosome length change (µm)')
title('Only first stretches')

figure
histogram(distances(index_rank3),'BinWidth',0.01)

% figure
% histogram(distrel(index_rank3),'BinWidth',0.02)

% figure
% boxplot(distrel,rank)
% xlabel('Rank in stretch cycle')
% ylabel('Relative chromosome length change')
% title('All stretching cycles combined')

[test.rank1h,test.rank1p]=ttest(distances(index_rank1));
[test.rank2h,test.rank2p]=ttest(distances(index_rank2));
[test.rank3h,test.rank3p]=ttest(distances(index_rank3));

[test.rank12h,test.rank12p]=ttest2(distances(index_rank1),distances(index_rank2),'Vartype','unequal');
[test.rank13h,test.rank13p]=ttest2(distances(index_rank1),distances(index_rank3),'Vartype','unequal');
[test.rank23h,test.rank23p]=ttest2(distances(index_rank2),distances(index_rank3),'Vartype','unequal');

% [test.rankrel1h,test.rankrel1p]=ttest(distrel(index_rank1));
% [test.rankrel2h,test.rankrel2p]=ttest(distrel(index_rank2));
% [test.rankrel3h,test.rankrel3p]=ttest(distrel(index_rank3));
% 
% [test.rankrel12h,test.rankrel12p]=ttest2(distrel(index_rank1),distrel(index_rank2),'Vartype','unequal');
% [test.rankrel13h,test.rankrel13p]=ttest2(distrel(index_rank1),distrel(index_rank3),'Vartype','unequal');
% [test.rankrel23h,test.rankrel23p]=ttest2(distrel(index_rank2),distrel(index_rank3),'Vartype','unequal');

end