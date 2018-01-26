clear all;

%% Geometry
Lx = 2.0; Ly = 1.0;
Nx = 128; Ny = 64;
dx = Lx / Nx; dy = Ly / Ny;
x = (dx / 2 : dx : Lx - dx / 2)';
y = (dy / 2 : dy : Ly - dy / 2)';
geom = cartGrid([Nx, Ny], [Lx, Ly]);
geom = computeGeometry(geom);
Nc = geom.cells.num;

%% Boundary conditions
hl = 1; hr = 0;
bc = pside([], geom, 'LEFT' , hl);
bc = pside(bc, geom, 'RIGHT', hr);

%% Conductivity field

% Covariance function
covfunc = {@covSEiso};
mean_Y  = 1.0;
cor_len = 0.2;
std_dev = 1.0;
hyp.cov = log([cor_len; std_dev]);
sn      = 1e-6;
hyp.lik = log(sn);

% Field
rng(0);
KY = feval(covfunc{:}, hyp.cov, geom.cells.centroids) + diag(ones(Nc, 1)) * sn^2;
tic;
Y  = mean_Y + chol(KY)' * randn(Nc, 1);
toc
K = exp(Y);

%% Solution
tic;
h = head_steady(geom, bc, K);
toc

hf = figure;
ha = axes('Box', 'off');
imagesc(x, y, reshape(h, Nx, [])'); colorbar;
