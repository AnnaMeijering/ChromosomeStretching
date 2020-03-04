function AvArray = averagearray( A , n )
% Averages an array A over blocks of length n

AvArray = arrayfun(@(i) mean(A(i:i+n-1)),1:n:length(A)-n+1)';
end