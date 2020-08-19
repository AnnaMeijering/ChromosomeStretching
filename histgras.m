clear
topii=load('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\TOPIIaLengthandstiffness.mat');
u2os=load('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\U2OSlengthsandstiffness.mat');

figure
histogram(u2os.length,0:0.5:6,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.length(find(~topii.treated)),0:0.5:6,'facealpha',.5,'edgecolor','none')
ylabel('Probability')
xlabel('Length (µm)')
legend('U2OS','HCT116 control')


figure
histogram(topii.length(find(~topii.treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.length(find(topii.treated)),0:0.5:20,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA')


figure
histogram(1./u2os.stiffness,0:0.5:6,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./topii.stiffness(find(~topii.treated)),0:0.5:6,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('U2OS','HCT116 control')

figure
histogram(u2os.stiffness,0:0.3:3,'facealpha',.5,'edgecolor','none')
hold on
histogram(topii.stiffness(find(~topii.treated)),0:0.3:3,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Stiffness (pN/nm)')
legend('U2OS','HCT116 control')


figure
histogram(1./topii.stiffness(find(~topii.treated)),0:0.8:8,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./topii.stiffness(find(topii.treated)),0:0.8:8,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +IAA')

figure
scatter(topii.length(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),'filled')
hold on
scatter(topii.length(find(topii.treated)),1./topii.stiffness(find(topii.treated)),'filled')
scatter(u2os.length,1./u2os.stiffness,'filled')
hold off


figure
scatter(u2os.length,1./u2os.stiffness,'filled')
hold on
scatter(topii.length(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),'filled')
xlim([0 6])
ylim([0 6])
xlabel('Chromosome length (um)')
ylabel('Compliance (nm/pN)')
[lc_mean,cc_mean,cc_er]=calc_meanSEMfromdatacloud(u2os.length,1./u2os.stiffness,0.5);
[ld_mean,cd_mean,cd_er]=calc_meanSEMfromdatacloud(topii.length(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),0.5);
 
errorbar(lc_mean,cc_mean,cc_er)
errorbar(ld_mean,cd_mean,cd_er)
hold off


figure
scatter(topii.length(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),'filled')
hold on
scatter(topii.length(find(topii.treated)),1./topii.stiffness(find(topii.treated)),'filled')
xlim([0 20])
ylim([0 20])
xlabel('Chromosome length (um)')
ylabel('Compliance (nm/pN)')
[ld_mean,cd_mean,cd_er]=calc_meanSEMfromdatacloud(topii.length(find(~topii.treated)),1./topii.stiffness(find(~topii.treated)),0.5);
[ldt_mean,cdt_mean,cdt_er]=calc_meanSEMfromdatacloud(topii.length(find(topii.treated)),1./topii.stiffness(find(topii.treated)),0.5);
 
errorbar(ld_mean,cd_mean,cd_er)
errorbar(ldt_mean,cdt_mean,cdt_er)
set(gca, 'XScale','log', 'YScale','log')
%axis([1E-13  1E-10    1E-5  1E-3])
hold off