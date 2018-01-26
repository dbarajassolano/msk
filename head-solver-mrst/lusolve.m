function x = lusolve(factors, F)
% Linear system solver using L-U factorization

F = factors.R \ F;
x = factors.L \ F(factors.p, :);
x = factors.U \ x;
x = x(factors.qi, :);
