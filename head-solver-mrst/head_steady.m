function h = head_steady(geom, bc, K)
% Compute head field using TPFA discretization
% Adapted from MRST solver incompTPFA

% TPFA operators
ops = tpfa_ops(geom, bc, K);
A = ops.AD;
s = ops.rhs;

% Solution
A_fact = lufact(A);
h = lusolve(A_fact, s);