function [l_chrom, l_index, k_plateau]=length_from_stiffness_Hannes(d,f,k,f_threshold,n_sigma)

%%%
% Parameters: Distance d, Force f, Stiffness k,
% Optional: the force cutoff that defines our low force regime f_threshold
% the number of stiffness std deviations above the plateau stiffness that
% we define as onset of stiffening

if nargin == 3
    f_threshold = 50;
    n_sigma = 1;
end
%%% calculate the kernel density of the stiffness at low forces
%%% and extract the "most likely stiffness",
%%% which should be the plateau stiffness and the std dev
[ksd,xi] = ksdensity(k(f<f_threshold));
k_plateau = xi(ksd == max(ksd));
sigma = nanstd(k(f<f_threshold));
    
cut_off = ceil(length(f)/10); %% remove the first and last data points since the are often outliers
d_2 = d(cut_off:end-cut_off);
k_2 = k(cut_off:end-cut_off);
%%% the onset of stiffening is happening when the stiffness deviates from
%%% the plateau by n_sigma std deviations
l_chrom = max(d_2(k_2<k_plateau+n_sigma*sigma)); 
l_index=find(d==l_chrom);
end
