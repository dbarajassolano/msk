clear all;

Lx = 2.0;
Nx = 256;
dx = Lx / Nx;

pad  = [8, 16];
Npad = length(pad);
cor_len = pad(1) * dx;

for k = 1 : Npad
    covfunc = {@covMaterniso, 1};
    % cor_len = pad(k) * dx;
    std_dev = 1.0;
    covhyp  = log([cor_len; std_dev]);
    
    [vgram, x] = block_avg_vgram_calc(Lx, Nx, pad(k), covfunc, covhyp);
    xp = x / cor_len;
    xpmax = 0.5 / cor_len;
    
    hf = figure('Visible', 'off');
    ha = axes('Box', 'on', 'NextPlot', 'add', 'YLim', [0, 1.0], 'XLim', [0, xpmax], 'TickLabelInterpreter', 'latex');
    hp = plot(xp, vgram.f, 'r', xp, vgram.c, 'b', xp, vgram.cf, 'k', 'Parent', ha);
    set(hp, 'LineWidth', 2.0);
    hl = legend(hp, {'$\gamma_f$', '$\tilde{\gamma}_c$', '$\tilde{\gamma}_{cf}$'}, 'Interpreter', 'latex', 'FontSize', 12);
    set(hf, 'Position', [0, 0, 300, 225]);
    hl.Location = 'Best'; hl.Box = 'off';
    ha.XLabel.String = {'$r / \lambda_f$'};
    ha.XLabel.Interpreter = 'latex';
    ha.YLabel.String = {'$\gamma / \sigma^2_f$'};
    ha.YLabel.Interpreter = 'latex';
    export_fig(sprintf('block_avg_vgram_%d.eps', k), '-transparent', hf);
    export_fig(sprintf('block_avg_vgram_%d.png', k), '-transparent', hf);
    close(hf);
end