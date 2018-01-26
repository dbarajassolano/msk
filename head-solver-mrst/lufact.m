function factors = lufact(A)

N = length(A);
[L, U, p, q, R] = lu(A, 'vector');
qi(q) = 1 : N;

factors = struct('L', L, 'U', U, 'p', p, 'qi', qi, 'R', R, 'N', N);