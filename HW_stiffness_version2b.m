function [res,k_num,k_model,k_plateau,k_model_low,l_chrom,l_index,f_num]=HW_stiffness_version2b(d,f,f_lbound,f_ubound,k_threshold)

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

% legend('Data','Smoothed data')
% xlabel('Distance / nm')
% ylabel('Force / pN')

%%% stiffness from nummerical differentiation as a comparison (heavily
%%% smooth data)
k_n =  diff(smooth(f,n_smooth))./diff(smooth(d,n_smooth)); %spring constant in pN/nm
k_n(k_n>1e4 | k_n<-1000) = NaN;
f_n = f(2:end);
d_n = d(2:end);

k_num = k_n(~isnan(k_n)' & ~isnan(f_n));
f_num = f_n(~isnan(k_n)' & ~isnan(f_n));
d_num = d_n(~isnan(f_n) & ~isnan(d_n));
[l_chrom, l_index, k_plateau]=length_from_stiffness_Hannes(d_num./1000,f_num,k_num);

index_lbound=find(f_num>f_lbound);
index_mbound=find(f_num>(f_ubound-50));
index_ubound=find(f_num>f_ubound);
if isempty(index_lbound)
    index_lbound=length(f_num)-500;
    index_mbound=length(f_num)-50;
    index_ubound=length(f_num);
elseif isempty(index_ubound)
    index_mbound=length(f_num)-50;
    index_ubound=length(f_num);
end

dss=d_num(index_mbound(1):index_ubound(1))';
fss=f_num(index_mbound(1):index_ubound(1))';

%     l_index_0=l_index-100;
%     if l_index_0<0
%         l_index_0=1;
%     end
l_index_0=1;

dl=d_num(l_index_0:l_index)';
fl=f_num(l_index_0:l_index)';

fs=f_num(index_lbound(1):index_ubound(1))';
ks=k_num(index_lbound(1):index_ubound(1));

ks_mean=nanmean(ks);

% I fit both the numerical stiffness and the polynomial stiffness
res = fit(fs(fs>0), ks(fs>0),'power1'); %powerlaw fit to KF between lower- and upperbound force
k_model= fit(dss(fss>0), fss(fss>0),'poly1'); %linear fit to FD around upperbound force
k_model_low=fit(dl,fl,'poly1');

end

