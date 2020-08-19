%% Analysis of multiple salt experiments
clear
[filenames,paths]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');
NumFiles=length(filenames);

for iFile=1:NumFiles
    filepath=strcat(paths,filenames{iFile});
    chrom{iFile}=load(filepath);
end

%% obtain stiffness and length for all chromosomes
f_lb=100;           %lowerbound value for stiffness fit
f_ub=200;           %upperbound value for stiffness fit
k_threshold=0.02;   %stiffness threshold for length determination
for iChrom=1:NumFiles
    for istretch=1:3
        [chrom{iChrom}.datafit{istretch},chrom{iChrom}.stiffness{istretch},...
            chrom{iChrom}.k_model{istretch},chrom{iChrom}.ks_mean{istretch}]...
            = HW_stiffness_version2(chrom{iChrom}.dist{istretch},...
            chrom{iChrom}.force{istretch},f_lb,f_ub);
        chrom{iChrom}.k_ubound{istretch}=chrom{iChrom}.k_model{istretch}.p1;
        
        chrom{iChrom}.length{istretch}=length_from_stiffness(...
            chrom{iChrom}.dist{istretch}(2:end),chrom{iChrom}.force{istretch}(2:end),chrom{iChrom}.stiffness{istretch},k_threshold);
    end

    %Save stiffnesses and lengths in vectors for histograms and scatters
    lengths_before(iChrom)=chrom{iChrom}.length{1};
    lengths_high(iChrom)=chrom{iChrom}.length{2};
    lengths_after(iChrom)=chrom{iChrom}.length{3};
    
    stiffness_before(iChrom)=chrom{iChrom}.k_ubound{1};
    stiffness_high(iChrom)=chrom{iChrom}.k_ubound{2};
    stiffness_after(iChrom)=chrom{iChrom}.k_ubound{3};
end
lengths_change_rel_salt=(lengths_high-lengths_before)./lengths_before;
lengths_change_rel=(lengths_after-lengths_before)./lengths_before;
stiffness_change_rel_salt=(stiffness_high-stiffness_before)./stiffness_before;
stiffness_change_rel=(stiffness_after-stiffness_before)./stiffness_before;
compliance_change_rel=(1./stiffness_after-1./stiffness_before)./(1./stiffness_before);


for i=1:NumFiles
   top2(i)=chrom{i}.top2degron; 
end
top2c=find(top2==0);
top2d=find(top2==1);

colour='kr';
figure
for i=1:NumFiles
    plot(chrom{i}.dist{3},chrom{i}.force{3},colour(chrom{i}.top2degron+1))
    hold on
end
hold off

mean(stiffness_before(top2c))
mean(stiffness_before(top2d))
mean(stiffness_high(top2c))
mean(stiffness_high(top2d))
mean(stiffness_after(top2c))
mean(stiffness_after(top2d))

figure
scatter(lengths_before(top2c),1./stiffness_before(top2c),'filled')
hold on
scatter(lengths_before(top2d),1./stiffness_before(top2d),'filled')
xlabel('Initial Chromosome length (um)')
ylabel('Initial stiffness (pN/nm)')


figure
scatter(lengths_before(top2c),lengths_change_rel_salt(top2c),'filled')
hold on
scatter(lengths_before(top2d),lengths_change_rel_salt(top2d),'filled')
xlabel('Initial Chromosome length (um)')
ylabel('Relative length change while swollen')

figure
scatter(lengths_before(top2c),lengths_change_rel(top2c),'filled')
hold on
scatter(lengths_before(top2d),lengths_change_rel(top2d),'filled')
xlabel('Initial Chromosome length (um)')
ylabel('Relative length after swelling')

figure
scatter(stiffness_before(top2c),stiffness_change_rel_salt(top2c),'filled')
hold on
scatter(stiffness_before(top2d),stiffness_change_rel_salt(top2d),'filled')
xlabel('Initial stiffness (pN/nm)')
ylabel('Relative stiffness change while swollen')

figure
scatter(lengths_before(top2c),stiffness_change_rel_salt(top2c),'filled')
hold on
scatter(lengths_before(top2d),stiffness_change_rel_salt(top2d),'filled')
xlabel('Initial Chromosome length (um)')
ylabel('Relative stiffness change while swollen')

figure
scatter(lengths_before(top2c),stiffness_change_rel(top2c),'filled')
hold on
scatter(lengths_before(top2d),stiffness_change_rel(top2d),'filled')
xlabel('InitialChromosome length (um)')
ylabel('Relative stiffness change after swelling')

figure
group = [repmat({'stiffness_before'},length(stiffness_before),1);repmat({'stiffness_high'},length(stiffness_high),1);repmat({'stiffness_after'},length(stiffness_after),1)];
data = [stiffness_before,stiffness_high,stiffness_after];
boxplot(data, group,'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Stiffness / pN/nm','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(stiffness_before),1);
 scatter(x_plot(:),stiffness_before(:),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(stiffness_high),1);
 scatter(x_plot(:),stiffness_high(:),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=3*ones(length(stiffness_after),1);
 scatter(x_plot(:),stiffness_after(:),20,'filled','MarkerFaceColor', [0. 0 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

figure 
boxplot(lengths_change_rel, top2,'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Relative length change','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(top2c),1);
 scatter(x_plot(:),lengths_change_rel(top2c),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(top2d),1);
 scatter(x_plot(:),lengths_change_rel(top2d),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

 figure 
boxplot(lengths_change_rel_salt, top2,'Widths',0.55,'Colors', [00.3 0.3 0.3])
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
boxplot(compliance_change_rel, top2,'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Relative compliance change','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(top2c),1);
 scatter(x_plot(:),compliance_change_rel(top2c),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(top2d),1);
 scatter(x_plot(:),compliance_change_rel(top2d),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

 figure 
boxplot(stiffness_change_rel_salt, top2,'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Relative stiffness change (high salt vs normal)','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(top2c),1);
 scatter(x_plot(:),stiffness_change_rel_salt(top2c),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(top2d),1);
 scatter(x_plot(:),stiffness_change_rel_salt(top2d),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

  figure 
boxplot(stiffness_change_rel, top2,'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Relative stiffness change','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(top2c),1);
 scatter(x_plot(:),stiffness_change_rel(top2c),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(top2d),1);
 scatter(x_plot(:),stiffness_change_rel(top2d),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

 
 
figure
histogram(stiffness_high,0:0.05:0.7,'facealpha',.5,'edgecolor','none','Normalization','probability')
ylabel('Probability')
xlabel('Stiffness / pN/nm')
legend('before')

figure
histogram(stiffness_high,0:0.05:0.7,'facealpha',.5,'edgecolor','none','Normalization','probability')
ylabel('Probability')
xlabel('Stiffness / pN/nm')
legend('during')

figure
histogram(stiffness_after,0:0.05:0.7,'facealpha',.5,'edgecolor','none','Normalization','probability')
ylabel('Probability')
xlabel('Stiffness / pN/nm')
legend('after')

 figure
histogram(lengths_before(top2c),0:2:36,'facealpha',.5,'edgecolor','none')
hold on
histogram(lengths_before(top2d),0:3:36,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(lengths_high(top2c),0:2:36,'facealpha',.5,'edgecolor','none')
hold on
histogram(lengths_high(top2d),0:3:36,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(lengths_after(top2c),0:2:36,'facealpha',.5,'edgecolor','none')
hold on
histogram(lengths_after(top2d),0:3:36,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Length (µm)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(1./stiffness_before(top2c),0:2:80,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness_before(top2d),0:2:80,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(1./stiffness_high(top2c),0:2:80,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness_high(top2d),0:4:80,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(1./stiffness_after(top2c),0:2:80,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness_after(top2d),0:4:80,'facealpha',.5,'edgecolor','none')
ylabel('Frequency')
xlabel('Compliance (nm/pN)')
legend('HCT116 control','HCT116 +IAA')

figure
histogram(lengths_before(top2c),0:1:20,'facealpha',.5,'edgecolor','none')
hold on
histogram(lengths_after(top2c),0:1:20,'facealpha',.5,'edgecolor','none')
xlabel('Chromosome length (um)')
ylabel('Frequency')
figure
histogram(lengths_before(top2d),0:3:30,'facealpha',.5,'edgecolor','none')
hold on
histogram(lengths_after(top2d),0:3:30,'facealpha',.5,'edgecolor','none')
xlabel('Chromosome length (um)')
ylabel('Frequency')

figure
histogram(stiffness_before(top2c),0:0.1:0.8,'facealpha',.5,'edgecolor','none')
hold on
histogram(stiffness_after(top2c),0:0.1:0.8,'facealpha',.5,'edgecolor','none')
figure
histogram(stiffness_before(top2d),0:0.1:0.8,'facealpha',.5,'edgecolor','none')
hold on
histogram(stiffness_after(top2d),0:0.1:0.8,'facealpha',.5,'edgecolor','none')

figure
histogram(1./stiffness_before(top2c),0:0.5:15,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness_after(top2c),0:0.5:15,'facealpha',.5,'edgecolor','none')
xlabel('Compliance (nm/pN)')
ylabel('Frequency')
figure
histogram(1./stiffness_before(top2d),0:3:54,'facealpha',.5,'edgecolor','none')
hold on
histogram(1./stiffness_after(top2d),0:3:54,'facealpha',.5,'edgecolor','none')
xlabel('Compliance (nm/pN)')
ylabel('Frequency')

figure
group = [repmat({'compliance_before_c'},length(stiffness_before(top2c)),1);...
    repmat({'compliance_after_c'},length(stiffness_after(top2c)),1);...
    repmat({'compliance_before_d'},length(stiffness_before(top2d)),1);...
    repmat({'compliance_after_d'},length(stiffness_after(top2d)),1)];
data = [1./stiffness_before(top2c),1./stiffness_after(top2c),1./stiffness_before(top2d),1./stiffness_after(top2d)];
boxplot(data, group,'Widths',0.4,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,1000,700])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Compliance (nm/pN)','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(top2c),1);
 scatter(x_plot(:),1./stiffness_before(top2c),20,'filled','MarkerFaceColor', [0 0 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(top2c),1);
 scatter(x_plot(:),1./stiffness_after(top2c),20,'filled','MarkerFaceColor', [0 0 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=3*ones(length(top2d),1);
 scatter(x_plot(:),1./stiffness_before(top2d),20,'filled','MarkerFaceColor', [0.8 0 0],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=4*ones(length(top2d),1);
 scatter(x_plot(:),1./stiffness_after(top2d),20,'filled','MarkerFaceColor', [0.8 0 0],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 
[pd,hd]=ranksum(1./stiffness_before(top2d),1./stiffness_after(top2d));
[pc,hc]=ranksum(1./stiffness_before(top2c),1./stiffness_after(top2c));
[pcd,hcd]=ranksum(1./stiffness_before(top2c),1./stiffness_before(top2d));

figure
group = [repmat({'length_before_c'},length(stiffness_before(top2c)),1);...
    repmat({'length_after_c'},length(stiffness_after(top2c)),1);...
    repmat({'length_before_d'},length(stiffness_before(top2d)),1);...
    repmat({'length_after_d'},length(stiffness_after(top2d)),1)];
data = [lengths_before(top2c),lengths_after(top2c),lengths_before(top2d),lengths_after(top2d)];
boxplot(data, group,'Widths',0.4,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,1000,700])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Compliance (nm/pN)','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
 x_plot=ones(length(top2c),1);
 scatter(x_plot(:),lengths_before(top2c),20,'filled','MarkerFaceColor', [0 0 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=2*ones(length(top2c),1);
 scatter(x_plot(:),lengths_after(top2c),20,'filled','MarkerFaceColor', [0 0 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=3*ones(length(top2d),1);
 scatter(x_plot(:),lengths_before(top2d),20,'filled','MarkerFaceColor', [0.8 0 0],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=4*ones(length(top2d),1);
 scatter(x_plot(:),lengths_after(top2d),20,'filled','MarkerFaceColor', [0.8 0 0],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

[pdl,hdl]=ranksum(lengths_before(top2d),lengths_after(top2d));
[pcl,hcl]=ranksum(lengths_before(top2c),lengths_after(top2c));
[pcld,hcdl]=ranksum(lengths_before(top2c),lengths_before(top2d));
