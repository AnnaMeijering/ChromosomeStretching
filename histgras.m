clear
topii=load('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\TOPIIaLengthandstiffness_new.mat');
u2os=load('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\U2OSlengthsandstiffness_new.mat');

%% Length
figure
histogram(u2os.lengths,0:0.5:12,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.lengths(find(~topii.treated)),0:0.5:12,'facealpha',.5,'edgecolor','none')
ylabel('Probability')
xlabel('Length (µm)')
legend('U2OS','HCT116 control')

figure
histogram(topii.lengths(find(~topii.treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.lengths(find(topii.treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(topii.lengths(find(~topii.treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.lengths(find(topii.treated&topii.lengths<5)),0:0.5:20,'facealpha',.5,'edgecolor','none')
histogram(topii.lengths(find(topii.treated&topii.lengths>5)),0:0.5:20,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA (small)','HCT116 +IAA (long)')

%% Compliance
figure
histogram(1./u2os.stiffness,0:0.5:6,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./topii.stiffness(find(~topii.treated)),0:0.5:6,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('U2OS','HCT116 control')

figure
histogram(1./topii.stiffness(find(~topii.treated)),0:0.8:8,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./topii.stiffness(find(topii.treated)),0:0.8:8,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(1./topii.stiffness(find(~topii.treated)),0:0.8:8,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./topii.stiffness(find(topii.treated&topii.lengths<5)),0:0.8:8,'facealpha',.5,'edgecolor','none')
histogram(1./topii.stiffness(find(topii.treated&topii.lengths>5)),0:0.8:8,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +IAA (small)','HCT116 +IAA (long)')


%% Initial stiffness
figure
histogram(u2os.stiffness_length,-0.1:0.05:0.5,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.stiffness_length(find(~topii.treated)),-0.1:0.05:0.5,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Initial Stiffness (pN/nm)')
legend('U2OS','HCT116 control')

figure
histogram(topii.stiffness_length(find(~topii.treated)),-0.1:0.05:0.5,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.stiffness_length(find(topii.treated)),-0.1:0.05:0.5,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Initial Stiffness (pN/nm)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(topii.stiffness_length(find(~topii.treated)),-0.1:0.05:0.5,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.stiffness_length(find(topii.treated&topii.lengths<5)),-0.1:0.05:0.5,'facealpha',.5,'edgecolor','none')
histogram(topii.stiffness_length(find(topii.treated&topii.lengths>5)),-0.1:0.05:0.5,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Initial Stiffness (pN/nm)')
legend('HCT116 control','HCT116 +IAA (small)','HCT116 +IAA (long)')


%% stiffness

figure
histogram(u2os.stiffness,0:0.3:3,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.stiffness(find(~topii.treated)),0:0.3:3,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Stiffness (pN/nm)')
legend('U2OS','HCT116 control')



figure
scatter(topii.lengths(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),'filled')
hold on
scatter(topii.lengths(find(topii.treated)),1./topii.stiffness(find(topii.treated)),'filled')
scatter(u2os.lengths,1./u2os.stiffness,'filled')
hold off


figure
scatter(u2os.lengths,1./u2os.stiffness,'filled')
hold on
scatter(topii.lengths(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),'filled')
xlim([0 6])
ylim([0 6])
xlabel('Chromosome length (um)')
ylabel('Compliance (nm/pN)')
[lc_centre,lc_mean,cc_mean,cc_er]=calc_meanSEMfromdatacloud(u2os.lengths,1./u2os.stiffness,0.8);
[ld_centre,ld_mean,cd_mean,cd_er]=calc_meanSEMfromdatacloud(topii.lengths(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),0.8);
 
errorbar(lc_mean,cc_mean,cc_er)
errorbar(ld_mean,cd_mean,cd_er)
hold off


[ld_centre,ld_mean,cd_mean,cd_er]=calc_meanSEMfromdatacloud(topii.lengths(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),0.8);
[ldt_centre,ldt_mean,cdt_mean,cdt_er]=calc_meanSEMfromdatacloud(topii.lengths(find(topii.treated)),1./topii.stiffness(find(topii.treated)),1);
figure
scatter(topii.lengths(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),'filled')
hold on
scatter(topii.lengths(find(topii.treated)),1./topii.stiffness(find(topii.treated)),'filled')
xlim([0 20])
ylim([0 20])
xlabel('Chromosome length (um)')
ylabel('Compliance (nm/pN)')

errorbar(ld_mean,cd_mean,cd_er)
errorbar(ldt_mean,cdt_mean,cdt_er)
set(gca, 'XScale','log', 'YScale','log')
%axis([1E-13  1E-10    1E-5  1E-3])
hold off

%% Mean and SEMS
meanL_U2OS=mean(u2os.lengths)
SEML_U2OS=std(u2os.lengths)/sqrt(length(u2os.lengths))
meanC_U2OS=mean(1./u2os.stiffness)
SEMC_U2OS=std(1./u2os.stiffness)/sqrt(length(1./u2os.stiffness))


meanL_HCTc=mean(topii.lengths(find(~topii.treated)))
SEML_HCTc=std(topii.lengths(find(~topii.treated)))/sqrt(length(topii.lengths(find(~topii.treated))))
meanL_HCTd=mean(topii.lengths(find(topii.treated)))
SEML_HCTd=std(topii.lengths(find(topii.treated)))/sqrt(length(topii.lengths(find(topii.treated))))
meanLsmall_HCTd=mean(topii.lengths(find(topii.treated&topii.lengths<5)))
SEMLsmall_HCTd=std(topii.lengths(find(topii.treated&topii.lengths<5)))/sqrt(length(topii.lengths(find(topii.treated&topii.lengths<5))))
meanLlarge_HCTd=mean(topii.lengths(find(topii.treated&topii.lengths>5)))
SEMLlarge_HCTd=std(topii.lengths(find(topii.treated&topii.lengths>5)))/sqrt(length(topii.lengths(find(topii.treated&topii.lengths>5))))
%% Wilcoxon rank test to find statistical differences between groups
[plu,hlu]=ranksum(u2os.lengths,topii.lengths(find(~topii.treated)))
[plh,hlh]=ranksum(topii.lengths(find(~topii.treated)),topii.lengths(find(topii.treated)))
[pcu,hcu]=ranksum(1./u2os.stiffness,1./topii.stiffness(find(~topii.treated)))
[pch,hch]=ranksum(1./topii.stiffness(find(~topii.treated)),1./topii.stiffness(find(topii.treated)))
[psu,hsu]=ranksum(u2os.stiffness_length,topii.stiffness_length(find(~topii.treated)))
[psh,hsh]=ranksum(topii.stiffness_length(find(~topii.treated)),topii.stiffness_length(find(topii.treated)))
