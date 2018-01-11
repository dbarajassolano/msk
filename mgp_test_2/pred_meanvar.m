clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat',  testID));
ml  = load(sprintf('%s_hypo_ML.mat', testID));
loo = load(sprintf('%s_hypo_LOO.mat', testID));

Nlow    = geom.N / 2;
geomlow = geom_2d(geom.L, Nlow);

% Coarse
tic;
[pred_coarse_ml, ~, ~] = mgp_nystrom(geom, Nlow, ml.hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

% Fine
tic;
[pred_fine_ml, ~, ~] = mgp_nystrom(geom, Nlow, ml.hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;


% Coarse
tic;
[pred_coarse_loo, ~, ~] = mgp_nystrom(geom, Nlow, loo.hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

% Fine
tic;
[pred_fine_loo, ~, ~] = mgp_nystrom(geom, Nlow, loo.hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;

% Output
save(sprintf('%s_pred_meanvar.mat', testID), 'pred_coarse_ml', 'pred_fine_ml', 'pred_coarse_ml', 'pred_fine_ml');