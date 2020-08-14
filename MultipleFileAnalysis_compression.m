%% Analysis of multiple stretching curves

%clear
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
load(filepath);
[~,NumFiles]=size(FD.distances);
close all
f0 = 0
f1 = 200

f_ax = [0.1:0.1:300];

k_topo_0 = [];
k_norm_0 = [];

k_topo_1 = [];
k_norm_1 = [];

l_topo_0 = [];
l_norm_0 = [];

l_topo_1 = [];
l_norm_1 = [];

for iFile=1:NumFiles
    clear dAvg fAvg Forceder1 Forceder2


    d = FD.distances{iFile};
    f = FD.forces{iFile};

    d_ = d(~isnan(d) & ~isnan(f));
    f_ = f(~isnan(d) & ~isnan(f));
    f = f_;
    d = d_;
    
    
    %%% find d where f is zero
    if (~isempty(f(f>0))) && (~isempty(f(f<0)))
    [~,idx_0] = min(abs(f-f0));
    idx_0 = idx_0(1); % if there are multiple minima
    
    %%% measure initial stiffness around zero elongation
    d_ = d(d>d(idx_0)-0.05 & d<d(idx_0)+0.05);
    f_ = f(d>d(idx_0)-0.05 & d<d(idx_0)+0.05);
    
    res_0 = polyfit(d_,f_,1);
    
    %%% measure stiffness around 150 pN
    d_ = d(f>f1-25 & f<f1+25);
    f_ = f(f>f1-25 & f<f1+25);
    
    res_1 = polyfit(d_,f_,1);
        [~,idx_1] = min(abs(f-f1));
    idx_1 = idx_1(1); % if there are multiple minima
%     
%     
%     %%% plot results
%     figure(1)
%     hold on
    if info{iFile}{3} == 1
        plot(d,f,'Color',[0.8 0.6 0.6])
%         plot(d_,d_*res(1)+res(2),'r','LineWidth',1.)
% 
        k_topo_0 = [k_topo_0, res_0(1)/1000];
                k_topo_1 = [k_topo_1, res_1(1)/1000];
        l_topo_0 = [l_topo_0, d(idx_0)];
                l_topo_1 = [l_topo_1, d(idx_1)];
    elseif info{iFile}{3} == 0
        plot(d,f,'Color',[0.6 0.6 0.8])
%         plot(d_,d_*res(1)+res(2),'b','LineWidth',1.)

        k_norm_0 = [k_norm_0, res_0(1)/1000];
 
        k_norm_1 = [k_norm_1, res_1(1)/1000];
               l_norm_0 = [l_norm_0, d(idx_0)];
                l_norm_1 = [l_norm_1, d(idx_1)];
    end

    hold on
  
    

    
    %%% now select data for fit
    %%%[~, fs, ks] = selectdata('SelectionMode', 'Rect

    % I fit both the numerical stiffness and the polynomial stiffness
    %%%res = fit(fs{1}(fs{1}>0), ks{1}(fs{1}>0),'power1');
    %%%res2 = fit(fs{2}(fs{2}>0), ks{2}(fs{2}>0),'power1');
%     k_num_ = k_num(~isnan(k_num) & ~isnan(f_num));
%     f_num_ = f_num(~isnan(k_num) & ~isnan(f_num));
%     res = fit(f_num_((f_num_>lb) & (f_num_<ub)), k_num_((f_num_>lb) & (f_num_<ub)),'power1');
%     res2 = fit(f((f>lb) & (f<ub))', k((f>lb) & (f<ub))','power1');
    %%% plot the final results

    end
    
end
% xlim([0,0.2])

ylabel('Force / pN')
xlabel('Compression / µm')


%%% plot of difference lengths
figure

group = [repmat(['L_norm_low'],length(l_norm_0),1);repmat(['L_topo_low'],length(l_topo_0),1);repmat(['L_norm_hgh'],length(l_norm_1),1);repmat(['L_topo_hgh'],length(l_topo_1),1)]
data = [l_norm_0 ,l_topo_0, l_norm_1,l_topo_1];

boxplot(data, group,'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Length / µm','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
% 
% xlabel('','FontSize', 20)
% set(gca,'XTickLabel',[]);
% ylim([0,5.5])
% box on
% hold on
 x_plot=ones(length(l_norm_0),1);
 scatter(x_plot(:),l_norm_0(:),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

 x_plot=2*ones(length(l_topo_0),1);
 scatter(x_plot(:),l_topo_0(:),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=3*ones(length(l_norm_1),1);
 scatter(x_plot(:),l_norm_1(:),20,'filled','MarkerFaceColor', [0. 0 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=4*ones(length(l_topo_1),1);
 scatter(x_plot(:),l_topo_1(:),20,'filled','MarkerFaceColor', [0.8 0 0],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 
 
 %%% plot of difference stiffnesses
figure

group = [repmat(['k_norm_low'],length(k_norm_0),1);repmat(['k_topo_low'],length(k_topo_0),1);repmat(['k_norm_hgh'],length(k_norm_1),1);repmat(['k_topo_hgh'],length(l_topo_1),1)]
data = [k_norm_0 ,k_topo_0, k_norm_1,k_topo_1];

boxplot(data, group,'Widths',0.55,'Colors', [00.3 0.3 0.3])
hold on
 set(gcf,'position',[10,10,500,350])
  set(findobj(gca,'type','line'),'linew',1.5)
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
 ylabel('Stiffness / pN/nm','FontSize', 16)
set(gca,'FontSize', 12,'linewidth',1.)
% 
% xlabel('','FontSize', 20)
% set(gca,'XTickLabel',[]);
% ylim([0,5.5])
% box on
% hold on
 x_plot=ones(length(k_norm_0),1);
 scatter(x_plot(:),k_norm_0(:),20,'filled','MarkerFaceColor', [0. 0. 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);

 x_plot=2*ones(length(k_topo_0),1);
 scatter(x_plot(:),k_topo_0(:),20,'filled','MarkerFaceColor', [0.8 0 0.],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=3*ones(length(k_norm_1),1);
 scatter(x_plot(:),k_norm_1(:),20,'filled','MarkerFaceColor', [0. 0 0.8],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 x_plot=4*ones(length(k_topo_1),1);
 scatter(x_plot(:),k_topo_1(:),20,'filled','MarkerFaceColor', [0.8 0 0],'MarkerFaceAlpha',0.7','jitter','on','jitterAmount',0.1);
 
 % 
%print('Box_Marian.png','-dpng','-r600')
