clear all;

% Setup
testID = ID_mgp_test;
load(sprintf('%s_setup.mat', testID));

%% Reference fields
rfwidth = 0.98;

% Reference fine scale
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'XLim', [0, geom.L(1)], 'YLim', [0, geom.L(2)], 'DataAspectRatio', [1, 1, 1]);
imagesc(geom.x, geom.y, reshape(yf, geom.N(1), geom.N(2))', 'Parent', ha); %colorbar
clim = ha.CLim;
plot(xfobs(:, 1), xfobs(:, 2), 'wo', 'MarkerSize', 1.5, 'MarkerFaceColor', 'w', 'Parent', ha);
set(hf, 'Position', [0, 0, 320, 128]);
ha.TickLabelInterpreter = 'latex';
fname = sprintf('%s_ref_yf.eps', testID);
export_fig(fname, '-transparent', hf);
[~, yfw] = system(sprintf('identify -format "%%w" %s', fname));
close(hf);


% Reference coarse scale
hf = figure('Visible', 'off');
ha = axes('Box', 'on', 'NextPlot', 'add', 'XLim', [0, geom.L(1)], 'YLim', [0, geom.L(2)], 'DataAspectRatio', [1, 1, 1]);
imagesc(geom.x, geom.y, reshape(yc, geom.N(1), geom.N(2))', 'Parent', ha); colorbar('TickLabelInterpreter', 'latex');
ha.CLim = clim;
plot(xcobs(:, 1), xcobs(:, 2), 'wo', 'MarkerSize', 1.5, 'MarkerFaceColor', 'w', 'Parent', ha);
set(hf, 'Position', [0, 0, 320, 128]);
ha.TickLabelInterpreter = 'latex';
fname = sprintf('%s_ref_yc.eps', testID);
export_fig(fname, '-transparent', hf);
[~, ycw] = system(sprintf('identify -format "%%w" %s', fname));
close(hf);

yfw = str2num(yfw);
ycw = str2num(ycw);
rw  = rfwidth * [yfw, ycw] / (yfw + ycw);
fprintf('yfw: %g\n', round(rw(1) + 1e-3, 3));
fprintf('ycw: %g\n', round(rw(2) - 1e-3, 3));