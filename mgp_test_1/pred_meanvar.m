clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat',  testID));
load(sprintf('%s_hypo_ML.mat', testID));

Nlow    = geom.N / 2;
geomlow = geom_2d(geom.L, Nlow);

% Coarse
tic;
[pred_coarse, predlow_coarse, ~] = mgp_nystrom(geom, Nlow, hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

% Fine
tic;
[pred_fine, predlow_fine, ~] = mgp_nystrom(geom, Nlow, hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;

% Output
save(sprintf('%s_pred_meanvar.mat', testID), 'pred_coarse', 'pred_fine');