clear all;

% Setup
testID = 'mgp_test_1';
sID    = 's0';
scale  = 'coarse';
Ns     = 100;
seed   = 0;
load(sprintf('../%s%s%s_setup.mat',   testID, filesep, testID));
load(sprintf('../%s%s%s_hypo_ML.mat', testID, filesep, testID));

mean = 0.0;
fac  = 1.0;
condeval = @(y) exp(mean + fac * y);

% Nystrom sampler setup
Nlow    = geom.N / 2;
geomlow = geom_2d(geom.L, Nlow);

tic;
[pred, predlow, L] = mgp_nystrom(geom, Nlow, hypo, yfobs, ycobs, xfobs, xcobs, scale);
toc;

% Sampler
rng(seed);
tic;
for i = 1 : Ns
    xi = randn(geomlow.Nc, 1);
    y  = L * xi;
    K  = condeval(y);
    dlmwrite(sprintf('normal/%s_%s_%04d.txt',    testID, sID, i - 1), y, 'precision', '%.8e');
    dlmwrite(sprintf('lognormal/%s_%s_%04d.txt', testID, sID, i - 1), K, 'precision', '%.8e');
end
toc;

% Reference
switch scale
  case 'coarse'
    yref = yc;
  case 'fine'
    yref = fine;
end
dlmwrite(sprintf('normal/%s_%s_ref.txt',    testID, sID), yref,           'precision', '%.8e');
dlmwrite(sprintf('lognormal/%s_%s_ref.txt', testID, sID), condeval(yref), 'precision', '%.8e');
