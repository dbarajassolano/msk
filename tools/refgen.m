function [y_fine, y_coarse, y_padded] = refgen(L, N, pad, cor_len, filename_fine, filename_coarse, seed)

if (nargin < 7), seed = 0; end

% Padded fine
filename_padded = 'ref_padded.txt';
system(sprintf('Rscript refgen_padded.R %s %g %g %g %g %g %g %g', filename_padded, L(1), L(2), N(1), N(2), pad, cor_len, seed));
y_padded = dlmread(filename_padded);
delete(filename_padded);

% Fine
y_padded_m = reshape(y_padded, N(2) + pad, []);
y_fine_m   = y_padded_m(pad / 2 + (1 : N(2)), pad / 2 + (1 : N(1)));
y_fine = y_fine_m';
y_fine = y_fine(:);

fid = fopen(filename_fine, 'w'); fclose(fid);
dlmwrite(filename_fine, y_fine);

% Coarse
h = [0.5 / pad; (1 / pad) * ones(pad - 1, 1); 0.5 / pad];
H = h * h';
y_coarse_m = filter2(H, y_padded_m, 'valid');
y_coarse = y_coarse_m';
y_coarse = y_coarse(:);

fid = fopen(filename_coarse, 'w'); fclose(fid);
dlmwrite(filename_coarse, y_coarse);