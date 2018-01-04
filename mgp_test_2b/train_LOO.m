clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat', testID));

% Multivariate Matèrn kernel
covfunc = {{@covMN}, {@covMN}, {@covMN}};

% Initial guess
l1  = 0.15; nu1  = 1.0; s1 = 0.5;
l2  = 0.10; nu2  = 0.5; s2 = 1.0;
l12 = 0.10;
rho = 0.5;

hyp0 = [log([l1; nu1; s1; l2; nu2; s2; l12]); log((rho + 1) / (1 - rho)); log(1e-2); log(1e-2)];
[nlml0, K0] = LOOlikm(hyp0, covfunc, {xcobs, xfobs}, {ycobs, yfobs});

% Optimization
maxfunevals = 5000;
opts = optimoptions('fmincon', 'Algorithm', 'interior-point', 'FiniteDifferenceType', 'central', 'MaxFunctionEvaluations', maxfunevals);
hypo = fmincon(@(h) LOOlikm(h, covfunc, {xcobs, xfobs}, {ycobs, yfobs}), hyp0, [], [], [], [], [], [], @mgp_cons, opts);
[nlmlo, Ko] = LOOlikm(hypo, covfunc, {xcobs, xfobs}, {ycobs, yfobs});

% Output
fprintf('NLML Init\t%g\tFinal\t%g\n', nlml0, nlmlo);
save(sprintf('%s_hypo_LOO.mat', testID), 'hypo');