clear all

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat', testID));

% Exact variograms
covfunc = {@covMaterniso, 1};
std_dev = 1.0;
covhyp  = log([cor_len; std_dev]);
[vgram, x] = block_avg_vgram_calc(geom.L(1), geom.N(1), pad, covfunc, covhyp);

% Estimated parameters
ml  = load(sprintf('%s_hypo_ML.mat',  testID));
loo = load(sprintf('%s_hypo_LOO.mat', testID));

ml_idx  = (ml.status == 1);
loo_idx = (loo.status == 1);

data = [ml.hypo(ml_idx, :); loo.hypo(loo_idx, :)];
tag  = [repmat('ML    ', sum(ml_idx), 1); repmat('LOO-CV', sum(loo_idx), 1)];

data(:, 9) = data(:, 3) .* data(:, 6) .* data(:, 9);

hypo_idx = [1, 2, 3, 4, 5, 6, 7, 9];

ymin = [0.00, 0.0, 0.4, 0.0, 0.0, 0.60, 0.0, 0.1];
ymax = [0.25, 5.0, 1.0, 0.2, 1.2, 1.25, 0.2, 1.0];
Nha  = length(hypo_idx);

lm = 0.08; rm = 0.05;
tm = 0.00; bm = 0.10;
fw = 0.16; fh = 0.42;
sp = (1.0 - lm - rm - 4 * fw) / 3;
sh = (1.0 - tm - bm - 2 * fh);

hapos = [lm + 0 * fw + 0 * sp, bm + 1 * fh + 1 * sh, fw, 0.35;
         lm + 1 * fw + 1 * sp, bm + 1 * fh + 1 * sh, fw, 0.35;
         lm + 2 * fw + 2 * sp, bm + 1 * fh + 1 * sh, fw, 0.35;
         lm + 3 * fw + 3 * sp, bm + 1 * fh + 1 * sh, fw, 0.35;
         lm + 0 * fw + 0 * sp, bm + 0 * fh + 0 * sh, fw, 0.35;
         lm + 1 * fw + 1 * sp, bm + 0 * fh + 0 * sh, fw, 0.35;
         lm + 2 * fw + 2 * sp, bm + 0 * fh + 0 * sh, fw, 0.35;
         lm + 3 * fw + 3 * sp, bm + 0 * fh + 0 * sh, fw, 0.35];

title = {'$\lambda_c$', '$\nu_c$', '$\sigma_c$', '$\lambda_f$', '$\nu_f$', '$\sigma_f$', '$\lambda_{cf}$', '$\sigma_{cf}$'};
% val = [NaN, NaN, sqrt(vgram.c(end)), cor_len, 0.50, std_dev, NaN, vgram.cf(end) / (sqrt(vgram.c(end) * vgram.f(end)))];
val = [NaN, NaN, sqrt(vgram.c(end)), cor_len, 0.50, std_dev, NaN, vgram.cf(end)];

hf = figure('Visible', 'off', 'Position', [0, 0, 600, 450]);
ha = gobjects(Nha, 1);
for k = 1 : Nha
    hak = subplot(2, 4, k); hak.NextPlot = 'add'; ha(k) = hak;
    hbk = boxplot(data(:, hypo_idx(k)), tag, 'Symbol', '', 'Colors', 'k', 'Parent', hak);
    hak.YLim = [ymin(k), ymax(k)];
    set(findobj(hbk, 'LineStyle', '--'), 'LineStyle','-');
    if ~isnan(val(k))
        plot(hak.XLim, val(k) * ones(1, 2), 'k--', 'Parent', hak);
    end
end
for k = 1 : Nha
    ha(k).Position = hapos(k, :);
    ha(k).Title.String = title{k};
    ha(k).Title.Interpreter    = 'latex';
    ha(k).TickLabelInterpreter = 'latex';
end
export_fig(sprintf('%s_hypo.eps', testID), '-transparent', hf);
