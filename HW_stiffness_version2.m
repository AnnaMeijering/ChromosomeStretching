function [res,k_num,k_ubound,ks_mean]=HW_stiffness_version2(d,f,f_lbound,f_ubound)

%%% Ddetermine the stiffness and fit the stiffness as a
%%% function of the force with a powerlaw
%%% dependencies: selectdata, curve fitting toolbox

%%% fit data with polynomial of high degree 
d=d*1000; % nm
% figure()
% plot(d,f,'o')
% hold on
 n_smooth = ceil(length(d)/15); % calculate how many points are used for smoothing
% plot(smooth(d,n_smooth),smooth(f,n_smooth),'LineWidth',2)

legend('Data','Smoothed data')
xlabel('Distance / nm')
ylabel('Force / pN')

%%% stiffness from nummerical differentiation as a comparison (heavily
%%% smooth data)
k_num =  diff(smooth(f,n_smooth))./diff(smooth(d,n_smooth)); %spring constant in pN/nm
k_num(k_num>1e4 | k_num<-1000) = NaN;
f_num = f(2:end);

index_lbound=find(f_num>f_lbound);
index_ubound=find(f_num>f_ubound);
if isempty(index_lbound)
    index_lbound=length(f_num)-500;
    index_ubound=length(f_num);
elseif isempty(index_ubound)
    index_ubound=length(f_num);
end

fs=f_num(index_lbound(1):index_ubound(1))';
ks=k_num(index_lbound(1):index_ubound(1));
k_ubound=nanmean(ks(end-20:end));
ks_mean=nanmean(ks);

% I fit both the numerical stiffness and the polynomial stiffness
res = fit(fs(fs>0), ks(fs>0),'power1'); %fit to smoothened data

%%% plot the final results
% figure
% loglog(f(2:end),k_num,'b')
% hold on
% plot(res)
% ylabel('Stiffness / pN/nm')
% xlabel('Force / pN')

end

% save final results 
%save(['stiffness_' file_name(1:25)],'res','res2','f_num','k_num','f','k')
