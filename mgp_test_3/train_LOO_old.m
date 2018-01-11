clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat', testID));

% Multivariate Matèrn kernel
covfunc = {{@covMN}, {@covMN}, {@covMN}};

% Optimization options
maxfunevals = 5000;
opts = optimoptions('fmincon', 'Algorithm', 'interior-point', 'FiniteDifferenceType', 'central', 'MaxFunctionEvaluations', maxfunevals);

nlml0  = zeros(Nf, 1);
nlmlo  = zeros(Nf, 1);
hypo   = zeros(Nf, 12);
status = false(Nf, 1);

for k = 1 : Nf
    
    % Initial guess
    l1  = 0.10; nu1  = 2.0; s1 = std(ycobs(:, k));
    l2  = 0.05; nu2  = 0.5; s2 = std(yfobs(:, k));
    l12 = 0.05;
    rho = 0.5;
    
    % Model selection
    hyp0   = [log([l1; nu1; s1; l2; nu2; s2; l12]); log((rho + 1) / (1 - rho)); log(1e-3); log(1e-3)];
    nlml0k = LOOlikm(hyp0, covfunc, {xcobs, xfobs}, {ycobs(:, k), yfobs(:, k)});
    tic
    try
        hypok  = fmincon(@(h) LOOlikm(h, covfunc, {xcobs, xfobs}, {ycobs(:, k), yfobs(:, k)}), hyp0, [], [], [], [], [], [], @mgp_cons, opts);
        nlmlok = LOOlikm(hypok, covfunc, {xcobs, xfobs}, {ycobs(:, k), yfobs(:, k)});
    catch
        continue
    end
    toc
    hypo(k, :) = hypo_process_row(hypok);
    nlml0(k)   = nlml0k;
    nlmlo(k)   = nlmlok;
    status(k)  = true;

    fprintf('NLML Init\t%g\tFinal\t%g\n', nlml0k, nlmlok);
end

% Output    
save(sprintf('%s_hypo_LOO.mat', testID), 'hypo', 'nlml0', 'nlmlo', 'status');