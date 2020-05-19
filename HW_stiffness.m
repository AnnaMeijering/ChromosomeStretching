function [res,res2,fprime,fofd]=HW_stiffness(d,f)

%%% Cut chromosome data, determine the stiffness and fit the stiffness as a
%%% function of the force with a powerlaw
%%% dependencies: selectdata, curve fitting toolbox
%clear
%file_name = uigetfile('*.mat');
% load(file_name)
%%% the variable title is interfering with the funtion title, so I delete
%%% it
%clear title
% d = beadbeaddist*1000; % nm
% f = forceCH1; % pN

%%% select curve to analyse
% figure()
% plot(f)
% title('select the force distance curve you want to analyze') 
% xlabel('index')
% ylabel('force / pN')
% [~, ds, fs] = selectdata('SelectionMode', 'Rect');
% close
close all
lb = 20;
ub = 200;
d_ = d(~isnan(d) & ~isnan(f));
f_ = f(~isnan(d) & ~isnan(f));
f = f_;
d = d_;
%%% fit data with polynomial of high degree 
d=d*1000; % nm
fofd = polyfit(d,f,10);  %10th degree
ff = polyval(fofd,d);
figure()
plot(d,f,'o')
hold on
plot(d,ff,'LineWidth',2)
n_smooth = ceil(length(d)/15); % calculate how many points are used for smoothing
plot(smooth(d,n_smooth),smooth(f,n_smooth),'LineWidth',2)

legend('Data','Fit','Smoothed data')
xlabel('Distance / nm')
ylabel('Force / pN')

%%% stiffness from nummerical differentiation as a comparison (heavily
%%% smooth data)
k_num =  diff(smooth(f,n_smooth))./diff(smooth(d,n_smooth)); %spring constant in pN/nm
k_num(k_num>1e4 | k_num<-1000) = NaN;
f_num = (f(2:end)'+f(1:end-1)')/2;

%%% Stiffness from derivative
fprime = polyder(fofd);
k =  polyval(fprime,d);

%%% plot results
figure()
loglog(f_num,k_num,'b')
hold on
loglog(f,k,'r','LineWidth',2)
title('select the part of the curve you want to fit') 
ylabel('stiffness / pN/nm')
xlabel('force / pN')

%%% now select data for fit
%%%[~, fs, ks] = selectdata('SelectionMode', 'Rect

% I fit both the numerical stiffness and the polynomial stiffness
%%%res = fit(fs{1}(fs{1}>0), ks{1}(fs{1}>0),'power1');
%%%res2 = fit(fs{2}(fs{2}>0), ks{2}(fs{2}>0),'power1');
k_num_ = k_num(~isnan(k_num) & ~isnan(f_num));
f_num_ = f_num(~isnan(k_num) & ~isnan(f_num));
res = fit(f_num_((f_num_>lb) & (f_num_<ub)), k_num_((f_num_>lb) & (f_num_<ub)),'power1');
res2 = fit(f((f>lb) & (f<ub))', k((f>lb) & (f<ub))','power1');
%%% plot the final results
loglog(f_num,k_num,'b')
hold on
loglog(f,k,'r','LineWidth',2)
plot(res)
plot(res2)
ylabel('Stiffness / pN/nm')
xlabel('Force / pN')
% save final results 
%save(['stiffness_' file_name(1:25)],'res','res2','f_num','k_num','f','k')
