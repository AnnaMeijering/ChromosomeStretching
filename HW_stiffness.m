%%% Cut chromosome data, determine the stiffness and fit the stiffness as a
%%% function of the force with a powerlaw
%%% dependencies: selectdata, curve fitting toolbox
clear
file_name = uigetfile('*.mat');
load(file_name)
%%% the variable title is interfering with the funtion title, so I delete
%%% it
clear title
d = beadbeaddist*1000; % nm
f = forceCH1; % pN

%%% select curve to analyse
figure
plot(f)
title('select the force distance curve you want to analyze') 
xlabel('index')
ylabel('force / pN')
[~, ds, fs] = selectdata('SelectionMode', 'Rect');
close

%%% fit data with polynomial of high degree 
pf = polyfit(ds,fs,10);  %10th degree
ff = polyval(pf,ds);
plot(ds,fs,'o')
hold on
plot(ds,ff,'LineWidth',2)
legend('Data','Fit')
xlabel('Distance / nm')
ylabel('Force / pN')

%%% stiffness from nummerical differentiation as a comparison (heavily
%%% smooth data)
k_num =  diff(smooth(fs,1001))./diff(smooth(ds,1001)); %spring constant in pN/nm
k_num(k_num>1e4 | k_num<-1000) = NaN;
f_num = fs(2:end);

%%% Stiffness from derivative
fprime = polyder(pf);
k =  polyval(fprime,ds);

%%% plot results
figure()
loglog(f_num,k_num,'b')
hold on
loglog(fs,k,'r','LineWidth',2)
title('select the part of the curve you want to fit') 
ylabel('stiffness / pN/nm')
xlabel('force / pN')

%%% now select data for fit
[~, fss, ks] = selectdata('SelectionMode', 'Rect');
% I fit both the numerical stiffness and the polynomial stiffness
res = fit(fss{1}(fss{1}>0), ks{1}(fss{1}>0),'power1')
res2 = fit(fss{2}(fss{2}>0), ks{2}(fss{2}>0),'power1')

%%% plot the final results
loglog(fs(2:end),k_num,'b')
hold on
loglog(fs,k,'r','LineWidth',2)
plot(res)
plot(res2)
ylabel('Stiffness / pN/nm')
xlabel('Force / pN')
% save final results 
save(['stiffness_' file_name(1:25)],'res','res2','f_num','k_num','fs','k')
