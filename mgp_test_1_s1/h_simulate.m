clear all;

% Setup
testID = 'mgp_test_1';
sID    = 's1';
Ns     = 1000;
seed   = 0;
load(sprintf('../%s%s%s_setup.mat', testID, filesep, testID));
load(sprintf('%s_%s_Y.mat', testID, sID));

% MRST geometry
mg = cartGrid(geom.N, geom.L);
mg = computeGeometry(mg);
Nc = mg.cells.num;
xc = mg.cells.centroids;

% BCs
hl = 1; hr = 0;
bc = pside([], mg, 'LEFT' , hl);
bc = pside(bc, mg, 'RIGHT', hr);

h = zeros(Nc, Ns);
tic;
for is = 1 : Ns
    K = exp(sqrt(2) * Yf(:, is));
    h(:, is) = head_steady(mg, bc, K);
end
toc

save(sprintf('%s_%s_h.mat', testID, sID), 'h');
