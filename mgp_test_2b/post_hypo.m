clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat', testID));

% Exact variograms
covfunc = {@covMaterniso, 1};
std_dev = 1.0;
covhyp  = log([cor_len; std_dev]);
[vgram, x] = block_avg_vgram_calc(geom.L(1), geom.N(1), pad, covfunc, covhyp);

% Estimated variograms
ml = load(sprintf('%s_hypo_ML.mat', testID));
hypp_ml = hypo_process(ml.hypo);
loo = load(sprintf('%s_hypo_LOO.mat', testID));
hypp_loo = hypo_process(loo.hypo);

fprintf('Exact & %.3g & %.3g & %.3g & --- & \\itshape %.3g & --- & --- & \\itshape %.3g & %.3g & %.3g \\\\\n', cor_len, std_dev, 0.5, sqrt(vgram.c(end)), vgram.cf(end) / sqrt(vgram.c(end) * vgram.f(end)), 0.0, 0.0);

fprintf('ML & %.3g & %.3g & %.3g & %.3g & %.3g & %.3g & %.3g & %.3g & \\num{%.3g} & \\num{%.3g} \\\\\n', hypp_ml.l2, hypp_ml.s2, hypp_ml.v2, hypp_ml.l1, hypp_ml.s1, hypp_ml.v1, hypp_ml.l12, hypp_ml.rho, hypp_ml.sn2, hypp_ml.sn1);

fprintf('LOO-CV & %.3g & %.3g & %.3g & %.3g & %.3g & %.3g & %.3g & %.3g & \\num{%.3g} & \\num{%.3g} \\\\\n', hypp_loo.l2, hypp_loo.s2, hypp_loo.v2, hypp_loo.l1, hypp_loo.s1, hypp_loo.v1, hypp_loo.l12, hypp_loo.rho, hypp_loo.sn2, hypp_loo.sn1);