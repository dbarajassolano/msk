clear all;

% Test ID
testID = ID_mgp_test;

% Geometry
L       = [2.0, 1.0];
N       = [256, 128];
geom    = geom_2d(L, N);
pad     = 8;
cor_len = 0.10;
seed    = 4;

%% Fields
filename_fine   = 'ref_256x128_fine.txt';
filename_coarse = 'ref_256x128_coarse.txt';
[yf, yc, ~] = refgen(L, N, pad, cor_len, filename_fine, filename_coarse, seed);

%% Observations
rng(79);

noise_std_dev = 5e-2;

% Coarse observations
Ncobs = 50;
icobs = randperm(geom.Nc, Ncobs)';
xcobs = geom.xc(icobs, :);
ycobs = yc(icobs);

% Fine observations
Nfobs = 150;
ifobs = randi([1, geom.Nc], Nfobs, 1);
xfobs = geom.xc(ifobs, :);
yfobs = yf(ifobs);

% Add the noise!
ycobs = ycobs + noise_std_dev * randn(Ncobs, 1);
yfobs = yfobs + noise_std_dev * randn(Nfobs, 1);

save(sprintf('%s_setup.mat', testID), 'geom', 'yf', 'yc', 'ycobs', 'yfobs', 'xcobs', 'xfobs', 'pad', 'cor_len');
