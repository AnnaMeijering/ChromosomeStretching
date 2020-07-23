%% Analysis of multiple stretching curves

clear
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
load(filepath);
[~,NumFiles]=size(FD.distances);
close all

lb = 20;
ub = 200;
f_ax = [0.1:0.1:300];
f_scale = 100
f_shift = 0
k_topo = [];
k_norm = [];


for iFile=1:NumFiles
    clear dAvg fAvg Forceder1 Forceder2


    d = FD.distances{iFile};
    f = FD.forces{iFile};

    d_ = d(~isnan(d) & ~isnan(f));
    f_ = f(~isnan(d) & ~isnan(f));
    f = f_;
    d = d_;
    
    
    %%% find d where f is zero
     if (~isempty(f(f>f_scale))) && (~isempty(f(f<f_scale))) && (~isempty(f(f>f_shift))) && (~isempty(f(f<f_shift))) 
     [~,idx_1] = min(abs(f-f_scale));
     idx_1 = idx_1(1); % if there are multiple minima
    [~,idx_2] = min(abs(f-f_shift));
    idx_2 = idx_2(1); % if there are multiple minima
    
    d = (d-d(idx_2))/(d(idx_1)-d(idx_2));
    f = (f-f(idx_2))/(f(idx_1)-f(idx_2));
    
    %d = (d-d(idx_2));
    
    %%% measure initial stiffness
    d_ = d(d>-0.05 & d<0.05);
    f_ = f(d>-0.05 & d<0.05);
    
    res = polyfit(d_,f_,1);
    
    f_elast = d*res(1)+res(2);
         [~,idx_1] = min(abs(f-f_scale-f_elast));
     idx_1 = idx_1(1); % if there are multiple minima
%     
%     
%     %%% plot results
%     figure(1)
%     hold on
   % if info{iFile}{3} == 1
        %plot(d/d(idx_1),f-f_elast,'Color',[0.8 0.6 0.6])
        plot(d,f,'Color',[0.8 0.6 0.6])
%         plot(d_,d_*res(1)+res(2),'r','LineWidth',1.)
% 
%         k_topo = [k_topo, res(1)/1000];
    %elseif info{iFile}{3} == 0
     %   plot(d,f,'Color',[0.6 0.6 0.8])
%         plot(d_,d_*res(1)+res(2),'b','LineWidth',1.)
% 
%         k_norm = [k_norm, res(1)/1000];
    %end

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