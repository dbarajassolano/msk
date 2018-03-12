clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat',  testID));
Nlow    = geom.N / 2;
geomlow = geom_2d(geom.L, Nlow);

%% ML plugin prediction
ML = load(sprintf('%s_hypo_ML.mat', testID));

% Coarse
tic;
[pred_coarse_ML, ~, ~] = mgp_nystrom(geom, Nlow, ML.hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

tic;
[pred_coarse_only_ML, ~, ~] = gp_nystrom(geom, Nlow, ML.hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

% Fine
tic;
[pred_fine_ML, ~, ~] = mgp_nystrom(geom, Nlow, ML.hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;

tic;
[pred_fine_only_ML, ~, ~] = gp_nystrom(geom, Nlow, ML.hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;

% Output
save(sprintf('%s_pred_meanvar.mat', testID), 'pred_coarse_ML', 'pred_fine_ML', 'pred_coarse_only_ML', 'pred_fine_only_ML');

%% LOO-CV plugin prediction
LOO = load(sprintf('%s_hypo_LOO.mat', testID));

% Coarse
tic;
[pred_coarse_LOO, ~, ~] = mgp_nystrom(geom, Nlow, LOO.hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

tic;
[pred_coarse_only_LOO, ~, ~] = gp_nystrom(geom, Nlow, LOO.hypo, yfobs, ycobs, xfobs, xcobs, 'coarse');
toc;

% Fine
tic;
[pred_fine_LOO, ~, ~] = mgp_nystrom(geom, Nlow, LOO.hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;

tic;
[pred_fine_only_LOO, ~, ~] = gp_nystrom(geom, Nlow, LOO.hypo, yfobs, ycobs, xfobs, xcobs, 'fine');
toc;

% Output
save(sprintf('%s_pred_meanvar.mat', testID), 'pred_coarse_ML', 'pred_fine_ML', 'pred_coarse_only_ML', 'pred_fine_only_ML', 'pred_coarse_LOO', 'pred_fine_LOO', 'pred_coarse_only_LOO', 'pred_fine_only_LOO');