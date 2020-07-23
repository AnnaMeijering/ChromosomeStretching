function length=length_from_stiffness(d,f,k,k_threshold)

% remove first ten data points from vectors
d=d(70:end);
k=k(70:end);
f=f(70:end);
arraysize=size(k);

if k(1)>k_threshold
    a=find(k(1:ceil(arraysize/5))<k_threshold);
    b=find(f>0);
    if isempty(a)
        if f(1)<0
            length=d(b(1));
        else
        length=d(1);
        end
    else 
        length=d(a(end));
    end
    
else
    k_abovethreshold=find(k>k_threshold);
    
    if isempty(k_abovethreshold)
        length=d(end);
    else
    length=d(k_abovethreshold(1));
end
end
