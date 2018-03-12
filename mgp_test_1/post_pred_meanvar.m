clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat',  testID));
load(sprintf('%s_pred_meanvar.mat',  testID));
rfwidth = 0.98;

%% Predictive mean

% Fine
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'XLim', [0, geom.L(1)], 'YLim', [0, geom.L(2)], 'DataAspectRatio', [1, 1, 1]);
imagesc(geom.x, geom.y, reshape(pred_fine_ML.mean, geom.N(1), geom.N(2))', 'Parent', ha);
clim = ha.CLim;
%plot(xfobs(:, 1), xfobs(:, 2), 'wo', 'MarkerSize', 1.5, 'MarkerFaceColor', 'w', 'Parent', ha);
set(hf, 'Position', [0, 0, 320, 128]);
ha.TickLabelInterpreter = 'latex';
fname = sprintf('%s_pred_mean_fine.eps', testID);
export_fig(fname, '-transparent', hf);
[~, yfw] = system(sprintf('identify -format "%%w" %s', fname));
close(hf);

% Coarse
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'XLim', [0, geom.L(1)], 'YLim', [0, geom.L(2)], 'DataAspectRatio', [1, 1, 1]);
imagesc(geom.x, geom.y, reshape(pred_coarse_ML.mean, geom.N(1), geom.N(2))', 'Parent', ha); colorbar('TickLabelInterpreter', 'latex');
ha.CLim = clim;
%plot(xfobs(:, 1), xfobs(:, 2), 'wo', 'MarkerSize', 1.5, 'MarkerFaceColor', 'w', 'Parent', ha);
set(hf, 'Position', [0, 0, 320, 128]);
ha.TickLabelInterpreter = 'latex';
fname = sprintf('%s_pred_mean_coarse.eps', testID);
export_fig(fname, '-transparent', hf);
[~, ycw] = system(sprintf('identify -format "%%w" %s', fname));
close(hf);

yfw = str2num(yfw);
ycw = str2num(ycw);
rw  = rfwidth * [yfw, ycw] / (yfw + ycw);
fprintf('yfw: %g\n', round(rw(1) + 1e-3, 3));
fprintf('ycw: %g\n', round(rw(2) - 1e-3, 3));

%% Predictive variance

% Fine
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'XLim', [0, geom.L(1)], 'YLim', [0, geom.L(2)], 'DataAspectRatio', [1, 1, 1]);
imagesc(geom.x, geom.y, reshape(pred_fine_ML.var, geom.N(1), geom.N(2))', 'Parent', ha);
clim = ha.CLim;
%plot(xcobs(:, 1), xcobs(:, 2), 'wo', 'MarkerSize', 1.5, 'MarkerFaceColor', 'w', 'Parent', ha);
set(hf, 'Position', [0, 0, 320, 128]);
ha.TickLabelInterpreter = 'latex';
fname = sprintf('%s_pred_var_fine.eps', testID);
export_fig(fname, '-transparent', hf);
[~, yfw] = system(sprintf('identify -format "%%w" %s', fname));
close(hf);

% Coarse
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'XLim', [0, geom.L(1)], 'YLim', [0, geom.L(2)], 'DataAspectRatio', [1, 1, 1]);
imagesc(geom.x, geom.y, reshape(pred_coarse_ML.var, geom.N(1), geom.N(2))', 'Parent', ha); colorbar('TickLabelInterpreter', 'latex');
ha.CLim = clim;
%plot(xcobs(:, 1), xcobs(:, 2), 'wo', 'MarkerSize', 1.5, 'MarkerFaceColor', 'w', 'Parent', ha);
set(hf, 'Position', [0, 0, 320, 128]);
ha.TickLabelInterpreter = 'latex';
fname = sprintf('%s_pred_var_coarse.eps', testID);
export_fig(fname, '-transparent', hf);
[~, ycw] = system(sprintf('identify -format "%%w" %s', fname));
close(hf);

yfw = str2num(yfw);
ycw = str2num(ycw);
rw  = rfwidth * [yfw, ycw] / (yfw + ycw);
fprintf('yfw: %g\n', round(rw(1) + 1e-3, 3));
fprintf('ycw: %g\n', round(rw(2) - 1e-3, 3));

%% Table
mse = @(pred, ref) sum((pred.mean - ref).^2 + pred.var) / geom.Nc;
fprintf('%.3g & %.3g & %.3g & %.3g\n', mse(pred_fine_ML, yf), mse(pred_fine_only_ML, yf), mse(pred_coarse_ML, yc), mse(pred_coarse_only_ML, yc));
fprintf('%.3g & %.3g & %.3g & %.3g\n', mse(pred_fine_LOO, yf), mse(pred_fine_only_LOO, yf), mse(pred_coarse_LOO, yc), mse(pred_coarse_only_LOO, yc));
