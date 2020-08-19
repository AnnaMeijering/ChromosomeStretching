%% Analysis of multiple stretching curves

clear
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
load(filepath);
[~,NumFiles]=size(FD.distances);
close all
L1 = []
L2 = []
k_norm = []
k_topo = []
L_norm = []
L_topo = []
for iFile=1:NumFiles
    clear dAvg fAvg Forceder1 Forceder2


    d = FD.distances{iFile};
    f = FD.forces{iFile};

    d_ = d(~isnan(d) & ~isnan(f));
    f_ = f(~isnan(d) & ~isnan(f));
    f = f_;
    d = d_;
    d=d*1000; % nm

%     figure
%     plot(d,f)
%     hold on
    %%% #1 length at F = 0 pN
    [~,idx] = min(abs(f)-0);
    L1 = [L1 d(idx)];
%     vline(d(idx),'g')
    

    
    
    %%% fit data with polynomial of high degree 
    fofd = polyfit(d,f,10);  %10th degree
    ff = polyval(fofd,d);
    
    %%% Stiffness from derivative
    fprime = polyder(fofd);
    k =  polyval(fprime,d);
    d_s = d((k>0.02) & (f>0));
    L2 = [L2 d_s(1)];
    
    
    res_0 = polyfit(d(d<d_s(1)),f(d<d_s(1)),1);

  %  vline(d_s(1),'r')
    
    if info{iFile}{3} == 1
        plot(d,f,'Color',[0.8 0.6 0.6])
        k_topo = [k_topo ; res_0(1)];
        L_topo = [L_topo; d_s(1)]
    elseif info{iFile}{3} == 0
        plot(d,f,'Color',[0.6 0.6 0.8])
                L_norm = [L_norm; d_s(1)]

        k_norm = [k_norm; res_0(1)];
    end
    
    hold on
    plot(d(d<d_s(1)),d(d<d_s(1))*res_0(1)+res_0(2),'k')
end
