clear all;

% Test ID
testID = ID_mgp_test;

% Geometry
L       = [1.0, 1.0];
N       = [64,  64];
geom    = geom_2d(L, N);
pad     = 8;
cor_len = 0.05;
seed    = 0;

%% Fields
Nf = 500;

% Padded fine
filename_padded = 'ref_padded.txt';
system(sprintf('Rscript refgen_padded.R %s %g %g %g %g %g %g %g %g', filename_padded, L(1), L(2), N(1), N(2), pad, cor_len, seed, Nf));
y_padded = dlmread(filename_padded)';
delete(filename_padded);

yf = zeros(prod(N), Nf);
yc = zeros(prod(N), Nf);
h = [0.5 / pad; (1 / pad) * ones(pad - 1, 1); 0.5 / pad];
H = h * h';
for k = 1 : Nf
    % Fine
    y_padded_m = reshape(y_padded(:, k), N(2) + pad, []);
    y_fine_m   = y_padded_m(pad / 2 + (1 : N(2)), pad / 2 + (1 : N(1)));
    y_fine_k   = y_fine_m';
    yf(:, k)   = y_fine_k(:);
    
    % Coarse
    y_coarse_m = filter2(H, y_padded_m, 'valid');
    y_coarse_k = y_coarse_m';
    yc(:, k)   = y_coarse_k(:);
end

%% Observations
rng(237);

noise_std_dev = 5e-2;

% Coarse observations
Ncobs = 50;
icobs = randperm(geom.Nc, Ncobs)';
xcobs = geom.xc(icobs, :);
ycobs = yc(icobs, :) + noise_std_dev * randn(Ncobs, Nf);

% Fine observations
Nfobs = 150;
ifobs = randi([1, geom.Nc], Nfobs, 1);
xfobs = geom.xc(ifobs, :);
yfobs = yf(ifobs, :) + noise_std_dev * randn(Nfobs, Nf);

save(sprintf('%s_setup.mat', testID), 'Nf', 'geom', 'yf', 'yc', 'ycobs', 'yfobs', 'xcobs', 'xfobs', 'pad', 'cor_len');
