clear all;

% Setup
testID = 'mgp_test_1';
sID    = 's1';
Ns     = 1000;
seed   = 0;
load(sprintf('../%s%s%s_setup.mat',   testID, filesep, testID));
load(sprintf('../%s%s%s_hypo_ML.mat', testID, filesep, testID));

% Nystrom sampler setup
Nlow    = geom.N / 2;
geomlow = geom_2d(geom.L, Nlow);

tic;
[~, ~, Lf] = mgp_nystrom(geom, Nlow, hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;

tic;
[~, ~, Lc] = mgp_nystrom(geom, Nlow, hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

% Sampler
Yf = zeros(geom.Nc, Ns);
Yc = zeros(geom.Nc, Ns);
rng(seed);
tic;
for i = 1 : Ns
    xi = randn(geomlow.Nc, 1);
    Yc(:, i)  = Lc * xi;
    Yf(:, i)  = Lf * xi;
end
toc;

save(sprintf('%s_%s_Y.mat', testID, sID), 'Yc', 'Yf');
