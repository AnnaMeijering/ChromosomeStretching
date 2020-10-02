%% Analysis of multiple stretching curves

clear
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
load(filepath);
[~,NumFiles]=size(FD.distances);

for iFile=1:NumFiles
    FD.times{iFile} = 1:length(FD.forces{iFile});
    
f_lb=100;           %lowerbound value for stiffness fit
f_ub=200;           %upperbound value for stiffness fit
k_threshold=0.02;   %stiffness threshold for length determination
[chrom{iFile}.datafit,chrom{iFile}.stiffness,chrom{iFile}.k_model,chrom{iFile}.ks_mean,...
    chrom{iFile}.k_model_low,chrom{iFile}.length,l_index{iFile},chrom{iFile}.f_num]...
   = HW_stiffness_version2b(FD.distances{iFile},FD.forces{iFile},f_lb,f_ub,k_threshold);        
%[chrom{iFile}.length,index_l(iFile)]=length_from_stiffness(FD.distances{iFile}(2:end),FD.forces{iFile}(2:end),chrom{iFile}.stiffness,k_threshold);
chrom{iFile}.k_ubound=chrom{iFile}.k_model.p1;
%chrom{iFile}.k_lowforce=mean(chrom{iFile}.stiffness(1:index_l(iFile)));


f_ub_i=find(FD.forces{iFile}>f_ub);
f_ub_v=f_ub_i(1);


figure
plot(FD.distances{iFile},FD.forces{iFile},'k')
hold on
plot(FD.distances{iFile}(f_ub_v-100:f_ub_v),FD.forces{iFile}(f_ub_v-100:f_ub_v),'r')
vline(chrom{iFile}.length)
fk_plot{iFile}=FD.distances{iFile}*1000.*chrom{iFile}.k_model.p1+chrom{iFile}.k_model.p2;
plot(FD.distances{iFile},fk_plot{iFile},'m')
ylim([-50 500])
hold off

% figure
% plot(FD.distances{iFile},FD.forces{iFile},'k')
% hold on
% plot(FD.distances{iFile}(f_ub_v-100:f_ub_v),FD.forces{iFile}(f_ub_v-100:f_ub_v),'r')
% vline(chrom{iFile}.length)
% dk_plot{iFile}=linspace(FD.distances{iFile}(f_ub_v-100),FD.distances{iFile}(f_ub_v),101);
% fk_plot{iFile}=180+(dk_plot{iFile}-dk_plot{iFile}(1))*1000.*chrom{iFile}.k_ubound;
% plot(dk_plot{iFile}-0.05,fk_plot{iFile},'m')
% hold off

%     [res{iFile},res2{iFile},fprime{iFile},fofd{iFile}]=HW_stiffness(FD.distances{iFile},FD.forces{iFile});
%      pwl(iFile) = res{iFile}.b;
%      pwl2(iFile) = res2{iFile}.b;

end


colour='kr';
condition={'Control','Degraded'};

for k=1:NumFiles
    if length(info{k}) == 3
        treated(k)=info{k}{3};
    else 
        treated(k) = 0;
    end
    grouping{k}=condition{treated(k)+1};
    for m=1:length(FD.forces{k})-2
    FD.forcedif{k}(m)=FD.forces{k}(m+2)-FD.forces{k}(m);
    FD.distdif{k}(m)=FD.distances{k}(m+2)-FD.distances{k}(m);
    end
    
    ibreak{k}=find(FD.forcedif{k}<-1.5);
    iibreak{k}=diff(ibreak{k});
    double_ibreaks{k}=find(iibreak{k}==1)+1;
    ibreak{k}(double_ibreaks{k})=[];
    numbreak(k)=length(ibreak{k});
    if numbreak(k)>25
        numbreak(k)=0;
        numbreak_outliers(k)=numbreak(k);
        ibreak{k}=[];
    end
    
    breakforce{k}=FD.forces{k}(ibreak{k});
    breakdif{k}=FD.forcedif{k}(ibreak{k});
    
end
    icontrol=find(treated==0);
    idegraded=find(treated==1);
    breakdif_control=[];
    breakdif_degraded=[];
    breakforce_control=[];
    breakforce_degraded=[];
    
    for i=icontrol;
        breakdif_control=[breakdif_control breakdif{i}];
        breakforce_control=[breakforce_control breakforce{i}];
    end
    for i=idegraded;
        breakdif_degraded=[breakdif_degraded breakdif{i}];
        breakforce_degraded=[breakforce_degraded breakforce{i}];
    end
    
    breakdifs=horzcat(breakdif_control,breakdif_degraded);
    breakforces=horzcat(breakforce_control,breakforce_degraded);
    g_control=repmat({'Control'},1,length(breakdif_control));
    g_degraded=repmat({'Degraded'},1,length(breakdif_degraded));
    g=[g_control, g_degraded];

figure
boxplot(numbreak,grouping)
title('Number of rupture events')

figure
boxplot(breakdifs,g)
title('Size of rupture events')

figure
boxplot(breakforces,g)
title('Force at which rupture events take place')



%%
for iChrom=1:NumFiles
 lengths(iChrom)=chrom{iChrom}.length;
 stiffness(iChrom)=chrom{iChrom}.k_ubound;
 stiffness_low(iChrom)=chrom{iChrom}.k_model_low.p1;
end



figure
scatter(lengths,stiffness,'filled')
xlabel('Initial Chromosome length (um)')
ylabel('Initial stiffness (pN/nm)')

figure
histogram(lengths,0:0.5:6,'facealpha',.5,'edgecolor','none')
xlabel('Initial Chromosome length (um)')
ylabel('Frequency')

figure
histogram(stiffness,0:0.3:3,'facealpha',.5,'edgecolor','none')
xlabel('Initial stiffness (pN/nm)')
ylabel('Frequency')

colour='kkkrrrbbbcccmmm';
j=1;
    figure
for i=[2 4 5 8 12 18 23 26 32 37 40 41 44]
plot(FD.distances{i},FD.forces{i},colour(j))
j=j+1;
hold on
vline(length(i))
ylim([-50 300])
xlim([0.5 5])
end



figure
scatter(lengths(find(~treated)),1./stiffness(find(~treated)),'filled')
hold on
scatter(lengths(find(treated)),1./stiffness(find(treated)),'filled')
hold off


figure
histogram(lengths(find(~treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
hold on
histogram(lengths(find(treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(stiffness(find(~treated&lengths<5)),0:0.1:3,'facealpha',.5,'edgecolor','none','Normalization','probability')
hold on
histogram(stiffness(find(treated&lengths<5)),0:0.1:3,'facealpha',.5,'edgecolor','none','Normalization','probability')
ylabel('Probability')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(1./stiffness(find(~treated)),0:1:8,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness(find(treated(15:end))+14),0:1:8,'facealpha',.5,'edgecolor','none')
histogram(1./stiffness(find(treated(1:14))),0:1:8,'facealpha',.5,'edgecolor','none')
ylabel('Probability')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +4h Noc+Aux','HCT116 +2h Noc +2h Noc+Aux')

figure
histogram(1./stiffness_low(find(~treated)),0:30:300,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness_low(find(treated&lengths<5)),0:30:300,'facealpha',.5,'edgecolor','none')
histogram(1./stiffness_low(find(treated&lengths>5)),0:30:300,'facealpha',.5,'edgecolor','none')
ylabel('Probability')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +Aux (short)','HCT116 +Aux (long)')
figure
histogram(1./stiffness_low(find(~treated)),-500:10:500,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness_low(find(treated)),-500:10:500,'facealpha',.5,'edgecolor','none')
ylabel('Probability')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +Aux')

 figure 
boxplot(1./stiffness_low(stiffness_low>0), treated(stiffness_low>0),'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Relative length change (high salt vs normal)','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(top2c),1);
 scatter(x_plot(:),lengths_change_rel_salt(top2c),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(top2d),1);
 scatter(x_plot(:),lengths_change_rel_salt(top2d),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);


figure
histogram(length(find(~treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
hold on
histogram(length(find(treated(15:end))+14),0:0.5:20,'facealpha',.5,'edgecolor','none')
histogram(length(find(treated(1:14))),0:0.5:20,'facealpha',.5,'edgecolor','none')
ylabel('Probability')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +4h Noc+Aux','HCT116 +2h Noc +2h Noc+Aux')


figure
for iFile=7
plot(FD.distances{iFile},FD.forces{iFile})
hold on
end
xlim([0 6])
ylim([-100 400])
xlabel('Distance (um)')
ylabel('Force (pN)')


figure
for iFile=[10 11 12 13 15 16 17 18 19 20]
    strain{iFile}=FD.distances{iFile}./length(iFile);
plot(strain{iFile},FD.forces{iFile})
hold on
end
xlim([0.5 2])
ylim([-100 400])
xlabel('Strain')
ylabel('Force (pN)')

figure
for iFile=1:NumFiles
colour='krbc';
plot(FD.distances{iFile}-chrom{iFile}.length,FD.forces{iFile}-FD.forces{iFile}(l_index(iFile)),colour(treated(iFile)+1))
hold on
ylim([-50 300])
xlim([-0.5 2])
end
    figure
for iFile=1:NumFiles

colour='krbc';
d=(-0.5:0.01:0.5);
fkl_plot{iFile}=d.*1000.*chrom{iFile}.k_model_low.p1;
plot(FD.distances{iFile}-chrom{iFile}.length,FD.forces{iFile}-FD.forces{iFile}(l_index(iFile)),colour(treated(iFile)+1))
hold on
plot(d,fkl_plot{iFile},colour(treated(iFile)+3))
hold on
ylim([-50 300])
xlim([-0.5 2])
end
figure
for iFile=1:NumFiles

colour='krbc';
d=(-0.5:0.01:0.5);
fkl_plot{iFile}=d.*1000.*chrom{iFile}.k_model_low.p1;
plot(d,fkl_plot{iFile},colour(treated(iFile)+3))
hold on
ylim([-50 300])
xlim([-0.5 2])
end

top2c=find(~treated);
top2d=find(treated);
figure
for iFile=top2c
plot(FD.distances{iFile}-chrom{iFile}.length,FD.forces{iFile}-FD.forces{iFile}(l_index(iFile)),'k')
hold on
ylim([-50 300])
xlim([-0.5 2])
end
figure
for iFile=top2d
plot(FD.distances{iFile}-chrom{iFile}.length,FD.forces{iFile}-FD.forces{iFile}(l_index(iFile)),'r')
hold on
ylim([-50 300])
xlim([-0.5 2])
end
figure
for iFile=top2c

colour='krbc';
d=(-0.5:0.01:0.5);
fkl_plot{iFile}=d.*1000.*chrom{iFile}.k_model_low.p1;
plot(d,fkl_plot{iFile},'c')
hold on
ylim([-50 300])
xlim([-0.5 2])
end
figure
for iFile=top2d

d=(-0.5:0.01:0.5);
fkl_plot{iFile}=d.*1000.*chrom{iFile}.k_model_low.p1;
plot(d,fkl_plot{iFile},'b')
hold on
ylim([-50 300])
xlim([-0.5 2])
end



figure
for i=1:NumFiles
    %SumF=chrom{1,i}.f_num+SumF;
    loglog(chrom{1,i}.f_num,chrom{1,i}.stiffness,'color',[0,0,0]+0.01*i)
    hold on
end