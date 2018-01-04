clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat', testID));

% Exact variograms
covfunc = {@covMaterniso, 1};
std_dev = 1.0;
covhyp  = log([cor_len; std_dev]);
[vgram, x] = block_avg_vgram_calc(geom.L(1), geom.N(1), pad, covfunc, covhyp);

% Empirical variograms
[evgf, xf] = evgram(xfobs, yfobs);
[evgc, xc] = evgram(xcobs, ycobs);

% Estimated variograms
ml = load(sprintf('%s_hypo_ML.mat', testID));
vgram_ml = plugin_vgram_calc(ml.hypo, x);

loo = load(sprintf('%s_hypo_LOO.mat', testID));
vgram_loo = plugin_vgram_calc(loo.hypo, x);

xpres = 0.1;
xmax = ceil(max([xf; xc]) / xpres) * xpres;
% ymax = max([1.0, max(evgf), max(evgc)]);

% hf = figure;
% % hf = figure('Visible', 'off');
% ha = axes('Box', 'on', 'NextPlot', 'add', 'YLim', [0, ymax], 'XLim', [0, xmax], 'TickLabelInterpreter', 'latex');
% hp1 = plot(x, vgram.f, 'r', x, vgram.c, 'b', x, vgram.cf, 'k', 'Parent', ha);
% hp2 = plot(xf, evgf, 'rx', xc, evgc, 'bx', 'Parent', ha);
% hp3 = plot(x, vgram_ml.f, 'r--', x, vgram_ml.c, 'b--', x, vgram_ml.cf, 'k--', 'Parent', ha);
% set([hp1; hp2; hp3], 'LineWidth', 2.0);
% hl = legend(hp1, {'$\gamma_f$', '$\tilde{\gamma}_c$', '$\tilde{\gamma}_{cf}$'}, 'Interpreter', 'latex', 'FontSize', 12);
% set(hf, 'Position', [0, 0, 600, 225]);
% % export_fig(sprintf('%s_vgram_ML.eps', testID), '-transparent', hf);

% Fine
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'YLim', [0, max(evgf)], 'XLim', [0, xmax], 'TickLabelInterpreter', 'latex');
ha.XLabel.String = {'$r$'};
ha.XLabel.Interpreter = 'latex';
ha.YLabel.String = {'$\gamma / \sigma^2_f$'};
ha.YLabel.Interpreter = 'latex';
hp = plot(x, vgram.f, 'k', xf, evgf, 'kx', x, vgram_ml.f, 'k--', x, vgram_loo.f, 'k-.', 'Parent', ha);
set(hp, 'LineWidth', 2.0);
hl = legend(hp, {'Exact', 'Empirical', 'ML', 'LOO-CV'}, 'Interpreter', 'latex');
set(hf, 'Position', [0, 0, 500, 200]);
hl.Location = 'SouthEast'; hl.Box = 'off';
export_fig(sprintf('%s_vgram_f.pdf', testID), '-transparent', hf);

% Coarse
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'YLim', [0, max(evgc)], 'XLim', [0, xmax], 'TickLabelInterpreter', 'latex');
ha.XLabel.String = {'$r$'};
ha.XLabel.Interpreter = 'latex';
ha.YLabel.String = {'$\gamma / \sigma^2_f$'};
ha.YLabel.Interpreter = 'latex';
hp = plot(x, vgram.c, 'k', xf, evgc, 'kx', x, vgram_ml.c, 'k--', x, vgram_loo.c, 'k-.', 'Parent', ha);
set(hp, 'LineWidth', 2.0);
hl = legend(hp, {'Exact', 'Empirical', 'ML', 'LOO-CV'}, 'Interpreter', 'latex');
set(hf, 'Position', [0, 0, 500, 200]);
hl.Location = 'SouthEast'; hl.Box = 'off';
export_fig(sprintf('%s_vgram_c.pdf', testID), '-transparent', hf);

% Coarse-fine
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'XLim', [0, xmax], 'TickLabelInterpreter', 'latex');
ha.XLabel.String = {'$r$'};
ha.XLabel.Interpreter = 'latex';
ha.YLabel.String = {'$\gamma / \sigma^2_f$'};
ha.YLabel.Interpreter = 'latex';
hp = plot(x, vgram.cf, 'k', x, vgram_ml.cf, 'k--', x, vgram_loo.cf, 'k-.', 'Parent', ha);
ha.YLim = [0, ha.YLim(2)];
set(hp, 'LineWidth', 2.0);
hl = legend(hp, {'Exact', 'ML', 'LOO-CV'}, 'Interpreter', 'latex');
set(hf, 'Position', [0, 0, 500, 200]);
hl.Location = 'SouthEast'; hl.Box = 'off';
export_fig(sprintf('%s_vgram_cf.pdf', testID), '-transparent', hf);