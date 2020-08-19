function [l_chrom, l_index]=length_from_stiffness(d,f,k,k_threshold)

% remove first 70 data points from vectors
d=d(70:end);
k=k(70:end);
f=f(70:end);
arraysize=size(k);

if k(1)>k_threshold
    a=find(k(1:ceil(arraysize/5))<k_threshold);
    b=find(f>0);
    if isempty(a)
        if f(1)<0
            l_chrom=d(b(1));
        else
        l_chrom=d(1);
        end
    else 
        l_chrom=d(a(end));
    end
    
else
    k_abovethreshold=find(k>k_threshold);
    if isempty(k_abovethreshold)
        k_abovethreshold=find(f>50);
    elseif f(k_abovethreshold(1))>50
        k_abovethreshold=find(f>50);
    end
    
    l_chrom=d(k_abovethreshold(1));
end
index_l=find(d==l_chrom);
l_index=index_l(1)+70;
end
