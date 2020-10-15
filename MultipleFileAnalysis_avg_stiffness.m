%% Analysis of multiple stretching curves

clear
[filename,path]=uigetfile('D:\DataAnalysis\Chromavision\TOPIIdegrons\*.mat',...
    'Select the INPUT DATA FILE');
filepath=strcat(path,filename);
load(filepath);
[~,NumFiles]=size(FD.distances);
close all

lb = 20;
ub = 300;
f_ax = [0.1:0.1:300];

k_topo = [];
k_norm = [];
k1_topo = [];
k1_norm = [];

for iFile=1:NumFiles
    clear dAvg fAvg Forceder1 Forceder2


    d = FD.distances{iFile};
    f = FD.forces{iFile};

    d_ = d(~isnan(d) & ~isnan(f));
    f_ = f(~isnan(d) & ~isnan(f));
    f = f_(1:end-7);
    d = d_(1:end-7);
    %%% fit data with polynomial of high degree 
    d=d*1000; % nm
    fofd = polyfit(d,f,10);  %10th degree
    ff = polyval(fofd,d);
    
    n_smooth = ceil(length(d)/15); % calculate how many points are used for smoothing

    %%% stiffness from nummerical differentiation as a comparison (heavily
    %%% smooth data)
    k_num =  diff(smooth(f,n_smooth))./diff(smooth(d,n_smooth)); %spring constant in pN/nm
    k_num(k_num>1e4 | k_num<-1000) = NaN;
    f_num = (f(2:end)'+f(1:end-1)')/2;

    %%% Stiffness from derivative
    fprime = polyder(fofd);
    k =  polyval(fprime,d);

    % interpolation for averages
    [~,i] = sort(f);
    [f_un,ia,~] = unique(f(i));
    k_s = k(i);
    k_un = k_s(ia);
    k_int = interp1(f_un,k_un,f_ax);
    
    %%% plot results
    figure(1)
    if size(info{iFile},2)<3
        plot(d,f,'Color',[0.6 0.6 0.8])
        k_norm = [k_norm ; k_int]
    elseif info{iFile}{3} == 1
        plot(d,f,'Color',[0.8 0.6 0.6])
        
    elseif info{iFile}{3} == 0
        plot(d,f,'Color',[0.6 0.6 0.8])
        k_norm = [k_norm ; k_int]
    end
    hold on
    figure(2)
    if size(info{iFile},2)<3
                plot(f,k,'Color',[0.6 0.6 0.8])
        
        k1_norm = [k1_norm; nanmean(k(f<5))];
    elseif info{iFile}{3} == 1
        plot(f,k,'Color',[0.8 0.6 0.6])
        k_topo = [k_topo ; k_int];
        k1_topo = [k1_topo; nanmean(k(f<5))];
    elseif info{iFile}{3} == 0
        plot(f,k,'Color',[0.6 0.6 0.8])
        
        k1_norm = [k1_norm; nanmean(k(f<5))];
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

figure(2)
k_avg = nanmean(k_topo);
 if isempty(k_topo)
 else
plot(f_ax, k_avg,'r','LineWidth',2)
res = fit(f_ax((f_ax>lb) & (f_ax<ub))', k_avg((f_ax>lb) & (f_ax<ub))','power1');
plot(res)
 end
k_avg = nanmean(k_norm);
k_err = nanstd(k_norm);%/sqrt(length(k_norm(:,1)));
%errorbar(f_ax, k_avg,k_err,'b','LineWidth',2)
res = fit(f_ax((f_ax>lb) & (f_ax<ub))', k_avg((f_ax>lb) & (f_ax<ub))','power1');
plot(res)
legend off
xlim([1 500])
ylim([1e-2 10])
xlabel('Force / pN')
ylabel('Stiffness / pN/nm')
