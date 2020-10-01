function [nbreak,rank]=boxplot_ruptures()
[maxforce,stretchrank,numbreak]=rupture_analysis();

nbreak=[];
maxf=[];
rank=[];

for i=1:length(numbreak)
    nbreak=horzcat(nbreak,numbreak{i});
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

rupindex=find(nbreak>1);
Nrank1=length(index_rank1);
Nrank2=length(index_rank2);
Nrank3=length(index_rank3);
rankrup=rank(rupindex);
ruprank1=find(rankrup==1);
ruprank2=find(rankrup==2);
ruprank3=find(rankrup==3);

relrup1=length(ruprank1)/Nrank1;
relrup2=length(ruprank2)/Nrank2;
relrup3=length(ruprank3)/Nrank3;
relrup=[relrup1 relrup2 relrup3];
errup1=sqrt(length(ruprank1))/Nrank1;
errup2=sqrt(length(ruprank2))/Nrank2;
errup3=sqrt(length(ruprank3))/Nrank3;
errlow=[errup1 errup2 errup3];
errhigh=errlow;

figure
bar([1 2 3],relrup)
hold on
er=errorbar([1 2 3],relrup,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

% distno4=distances;
% distrelno4=distrel;
% rankno4=rank;
% distno4(index_rank4)=[];
% distrelno4(index_rank4)=[];
% rankno4(index_rank4)=[];

figure
boxplot(nbreak(index_lowforce),rank(index_lowforce))
xlabel('Rank in stretch cycle')
ylabel('number of ruptures in stretch')
title('Stretching to ~100pN')

figure
boxplot(nbreak(index_medforce),rank(index_medforce))
xlabel('Rank in stretch cycle')
ylabel('number of ruptures in stretch')
title('Stretching to ~300pN')

figure
boxplot(nbreak(index_highforce),rank(index_highforce))
xlabel('Rank in stretch cycle')
ylabel('number of ruptures in stretch')
title('Stretching to ~700pN')

figure
boxplot(nbreak,rank)
xlabel('Rank in stretch cycle')
ylabel('Chromosome length change (µm)')
title('All stretching cycles combined')


figure
histogram(nbreak(index_rank3),'BinWidth',0.01)

% figure
% histogram(distrel(index_rank3),'BinWidth',0.02)

% figure
% boxplot(distrel,rank)
% xlabel('Rank in stretch cycle')
% ylabel('Relative chromosome length change')
% % title('All stretching cycles combined')
% 
% [test.rank1h,test.rank1p]=ttest(distances(index_rank1));
% [test.rank2h,test.rank2p]=ttest(distances(index_rank2));
% [test.rank3h,test.rank3p]=ttest(distances(index_rank3));
% 
% [test.rank12h,test.rank12p]=ttest2(distances(index_rank1),distances(index_rank2),'Vartype','unequal');
% [test.rank13h,test.rank13p]=ttest2(distances(index_rank1),distances(index_rank3),'Vartype','unequal');
% [test.rank23h,test.rank23p]=ttest2(distances(index_rank2),distances(index_rank3),'Vartype','unequal');

% [test.rankrel1h,test.rankrel1p]=ttest(distrel(index_rank1));
% [test.rankrel2h,test.rankrel2p]=ttest(distrel(index_rank2));
% [test.rankrel3h,test.rankrel3p]=ttest(distrel(index_rank3));
% 
% [test.rankrel12h,test.rankrel12p]=ttest2(distrel(index_rank1),distrel(index_rank2),'Vartype','unequal');
% [test.rankrel13h,test.rankrel13p]=ttest2(distrel(index_rank1),distrel(index_rank3),'Vartype','unequal');
% [test.rankrel23h,test.rankrel23p]=ttest2(distrel(index_rank2),distrel(index_rank3),'Vartype','unequal');

end