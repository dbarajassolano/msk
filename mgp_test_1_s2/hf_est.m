clear all;

% Setup
testID = 'mgp_test_1';
sID    = 's2';
Ns     = 4000;
seed   = 0;
load(sprintf('../%s%s%s_setup.mat', testID, filesep, testID));
load(sprintf('%s_%s_hf.mat', testID, sID));

%% Reference

% MRST geometry
mg = cartGrid(geom.N, geom.L);
mg = computeGeometry(mg);
Nc = mg.cells.num;
xc = mg.cells.centroids;

% BCs
hl = 1; hr = 0;
bc = pside([], mg, 'LEFT' , hl);
bc = pside(bc, mg, 'RIGHT', hr);

% Reference h
Kref = exp(yf);
href = head_steady(mg, bc, Kref);

% Observations
rng(0);
Nhobs = 40;
ihobs = randperm(Nc, Nhobs)';
xcobs = geom.xc(ihobs, :);
hobs  = href(ihobs);

%% Minimum mean square estimation

itest = (xc(:, 2) > (geom.L(2) - geom.dy)) & (xc(:, 2) < geom.L(2));

tic;
hT    = h';
meanh = mean(hT)';
hTd   = bsxfun(@minus, hT, meanh');
Cho   = hTd(:, ihobs)' * hTd(:, ihobs) / (Ns - 1);
Cht   = hTd(:, itest)' * hTd(:, itest) / (Ns - 1);
Chto  = hTd(:, itest)' * hTd(:, ihobs) / (Ns - 1);
toc

Chpred = Cht - Chto * (Cho \ Chto');
meanhpred = meanh(itest) + Chto * (Cho \ (hobs - meanh(ihobs)));

hf = figure('Visible', 'off');
ha = axes(hf, 'Box', 'on', 'NextPlot', 'add', 'TickLabelInterpreter', 'latex', 'YLim', [0, 1]);
f = [meanhpred + 2 * sqrt(diag(Chpred)); flipdim(meanhpred - 2 * sqrt(diag(Chpred)), 1)];
fill([geom.x; flipdim(geom.x, 1)], f, [7, 7, 7] / 8, 'LineStyle', 'none', 'Parent', ha);
plot(geom.x, meanhpred, 'r', geom.x, href(itest), 'k', 'Parent', ha);
ha.XLabel.String = {'$x / L$'};
ha.XLabel.Interpreter = 'latex';
ha.YLabel.String = {'$(h - h_{\mathrm{R}}) / (h_{\mathrm{L}} - h_{\mathrm{R}})$'};
ha.YLabel.Interpreter = 'latex';
set(hf, 'Position', [0, 0, 300, 225], 'Color', 'w');
export_fig(sprintf('%s_%s_hf_cond.eps', testID, sID));

hf = figure('Visible', 'off');
ha = axes(hf, 'Box', 'on', 'NextPlot', 'add', 'TickLabelInterpreter', 'latex', 'YLim', [0, 1]);
f = [meanh(itest) + 2 * sqrt(diag(Cht)); flipdim(meanh(itest) - 2 * sqrt(diag(Cht)), 1)];
fill([geom.x; flipdim(geom.x, 1)], f, [7, 7, 7] / 8, 'LineStyle', 'none', 'Parent', ha);
plot(geom.x, meanh(itest), 'r', 'Parent', ha);
ha.XLabel.String = {'$x / L$'};
ha.XLabel.Interpreter = 'latex';
ha.YLabel.String = {'$(h - h_{\mathrm{R}}) / (h_{\mathrm{L}} - h_{\mathrm{R}})$'};
ha.YLabel.Interpreter = 'latex';
set(hf, 'Position', [0, 0, 300, 225], 'Color', 'w');
export_fig(sprintf('%s_%s_hf_unc.eps', testID, sID));