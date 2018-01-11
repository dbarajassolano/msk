clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat', testID));

% Multivariate Matèrn kernel
covfunc = {{@covMN}, {@covMN}, {@covMN}};

% Optimization options
maxfunevals = 5000;
opts = optimoptions('fmincon', 'Algorithm', 'interior-point', 'FiniteDifferenceType', 'central', 'MaxFunctionEvaluations', maxfunevals, 'Display', 'off');
warning('off', 'MATLAB:nearlySingularMatrix');
warning('off', 'MATLAB:illConditionedMatrix');
warning('off', 'MATLAB:singularMatrix');

% Nf = 50; % Override Nf defined in setup.m

nlml0  = zeros(Nf, 1);
nlmlo  = zeros(Nf, 1);
status = zeros(Nf, 1);
hypo   = zeros(Nf, 12);

for k = 1 : Nf
    
    % Initial guess
    % l1  = 0.10; nu1  = 2.0; s1 = std(ycobs(:, k));
    % l2  = 0.05; nu2  = 0.5; s2 = std(yfobs(:, k));
    % l12 = 0.05;
    % rho = 0.5;
    l1  = 0.11; nu1  = 2.41; s1 = 0.58;
    l2  = 0.09; nu2  = 0.49; s2 = std(yfobs(:, k)); %s2 = 0.88;
    l12 = 0.10;
    rho = 0.7;
    
    % Model selection
    hyp0   = [log([l1; nu1; s1; l2; nu2; s2; l12]); log((rho + 1) / (1 - rho)); log(1e-3); log(1e-3)];
    nlml0k = LOOlikm(hyp0, covfunc, {xcobs, xfobs}, {ycobs(:, k), yfobs(:, k)});
    tic
    try
        [hypok, nlmlok, statusk] = fmincon(@(h) LOOlikm(h, covfunc, {xcobs, xfobs}, {ycobs(:, k), yfobs(:, k)}), hyp0, [], [], [], [], [], [], @mgp_cons, opts);
    catch
        continue
    end
    hypo(k, :) = hypo_process_row(hypok);
    nlml0(k)   = nlml0k;
    nlmlo(k)   = nlmlok;
    status(k)  = statusk;

    fprintf('k: %d\tNLML Init\t%g\tFinal\t%g\tTime [s]\t%g\tStatus\t%d\n', k, nlml0k, nlmlok, toc, statusk);
end

% Output    
save(sprintf('%s_hypo_LOO.mat', testID), 'hypo', 'nlml0', 'nlmlo', 'status');