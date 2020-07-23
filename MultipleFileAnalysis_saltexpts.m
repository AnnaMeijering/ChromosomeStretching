%% Analysis of multiple salt experiments
clear
[filenames,paths]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\Salt experiments\*.mat',...
    'Select the INPUT DATA FILE(s)','MultiSelect','on');
NumFiles=length(filenames);

for iFile=1:NumFiles
    filepath=strcat(paths,filenames{iFile});
    chrom{iFile}=load(filepath,'datafit','k_ubound','length','top2degron','force','dist');
end


for iChrom=1:NumFiles
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
scatter(lengths_before,stiffness_before,'filled')

figure
scatter(lengths_before(top2c),lengths_change_rel_salt(top2c),'filled')
hold on
scatter(lengths_before(top2d),lengths_change_rel_salt(top2d),'filled')
xlabel('Chromosome length (um)')
ylabel('Relative length change while swollen')

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
xlabel('Chromosome length (um)')
ylabel('Relative stiffness change while swollen')

figure
scatter(lengths_before(top2c),stiffness_change_rel(top2c),'filled')
hold on
scatter(lengths_before(top2d),stiffness_change_rel(top2d),'filled')
xlabel('Chromosome length (um)')
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

