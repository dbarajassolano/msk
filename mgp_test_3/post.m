clear all

testID = ID_mgp_test;
ml  = load(sprintf('%s_hypo_ML_old.mat',  testID));
loo = load(sprintf('%s_hypo_LOO_old.mat', testID));

ml_t1 = ~(ml.nlmlo < -100);
ml_t2 = (ml.nlmlo < ml.nlml0);
ml_idx = ml.status & ml_t1 & ml_t2;

loo_t1 = ~(loo.nlmlo < -100);
loo_t2 = (loo.nlmlo < loo.nlml0);
loo_idx = loo.status & loo_t1 & loo_t2;

data = [ml.hypo(ml_idx, :); loo.hypo(loo_idx, :)];
tag  = [repmat('ML ', sum(ml_idx), 1); repmat('LOO', sum(loo_idx), 1)];
