function [vgram, x] = block_avg_vgram_calc(Lx, Nx, pad, covfunc, covhyp)

% Geometry
dx   = Lx / Nx;
L    = [Lx + dx * pad, dx * (pad + 1)];
N    = [Nx + pad, pad + 1];
geom = geom_2d(L, N);

% Fine covariance
Kf = feval(covfunc{:}, covhyp, geom.xc);
idx_init = 0.5 * pad * (N(1) + 1) + 1;
idx_end  = idx_init + Nx - 1;
x = (0 : Nx - 1) * dx;

% Coarse covariance
h = [0.5 / pad; (1 / pad) * ones(pad - 1, 1); 0.5 / pad];
H = h * h';

Lf = chol(Kf, 'lower');
Lc = zeros(Nx, size(L, 2));

for i = 1 : size(Kf, 2);
    Lfm = reshape(Lf(:, i), N(1), [])';
    Lcm = (filter2(H, Lfm, 'valid'))';
    Lc(:, i) = Lcm(:);
end
Kc  = Lc * Lc';
Kcf = Lc * Lf';

Kfv  = Kf(idx_init, idx_init : idx_end);
Kcv  = Kc(1, :);
Kcfv = Kcf(1, idx_init : idx_end);

vgram = struct('c', Kcv(1) - Kcv, 'f', Kfv(1) - Kfv, 'cf', Kcfv(1) - Kcfv);