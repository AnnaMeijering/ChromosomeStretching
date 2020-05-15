function [F] = fOdijkInv_f0(d, Lp, Lc, S, F0, kT)
% As fOdijkInv, with force offset included (for convenience)
%
% SEE ALSO:
% fOdijkInv

if nargin < 6
    kT = 4.11;
end

F = fOdijkInv(d, Lp, Lc, S, kT)+F0;

end

