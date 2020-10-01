function [bincentre,binav,BinVal,BinSEM]=calc_meanSEMfromdatacloud(x,y,bin)
Nbin=ceil((max(x)-min(x))/bin);
for i=1:Nbin+1
binedges(i)=min(x)+(i-1)*bin;
end
bincentre=movmean(binedges,2);
bincentre=bincentre(2:end);

for j=1:Nbin
    indices=find(x>=binedges(j)&x<binedges(j+1));
    Ncounts(j)=length(indices);
    binav(j)=mean(x(indices));
    BinVal(j)=mean(y(indices));
    BinSEM(j) = std(y(indices))/sqrt(Ncounts(j)); 
    
end
i_zeros=find(Ncounts<2);
BinVal(i_zeros)=[];
BinSEM(i_zeros)=[];
bincentre(i_zeros)=[];

end
