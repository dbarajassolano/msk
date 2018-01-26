function ops = tpfa_ops(G, bc, K)
% Compute head field using TPFA discretization
% Adapted from MRST solver incompTPFA

% Resolve fine-scale cell neighborship, and other geometric quantities
neighborship = getNeighbourship(G, 'Topological', true);
% cell_no    : Cell of each half-face, size Nhf x 1
% cell_faces : Global face of each half-face, size Nhf x 1
[cell_no, cell_faces, ~] = getCellNoFaces(G);
Nc  = G.cells.num;
Ngf = G.faces.num; % Number of global faces

% Right-hand side information
% c_hf        : Dirichlet BC values per half-face, size Nhf x 1
% c_struct    : Logical array of global faces containing Dirichlet BCs, size Ngf x 1
% flux_struct : Logical array of global faces containing Neumann BCs, size Ngf x 1
[c_hf, c_struct] = compute_rhs(G, bc);

%% TPFA fluxes
D_field = struct('perm', K);
TD = computeTrans(G, D_field);
fD = 1 ./ accumarray(cell_faces, 1 ./ TD, [Ngf, 1]);

% Compute diffusion matrix
in = all(neighborship ~= 0, 2);
ID = [neighborship(in, 1); neighborship(in, 2); (1 : Nc)'];
JD = [neighborship(in, 2); neighborship(in, 1); (1 : Nc)'];
% Main diagonal contributions
d_1 = accumarray(reshape(neighborship(in,:), [], 1), repmat(fD(in), [2, 1]),  [Nc, 1]); 
% Diagonal contributions due to Dirichlet BCs
d_2 = accumarray(cell_no(c_struct(cell_faces)), TD(c_struct(cell_faces)), [Nc, 1]); 
diag = d_1 + d_2;
VD = [-fD(in); -fD(in); diag];
AD = sparse(double(ID), double(JD), VD, Nc, Nc);
clear ID JD VD diag;

%% Right-hand side
% TODO : Contributions from non-homogeneous Neumann BCs

% Contributions from Dirichlet BCs
rhs = accumarray(cell_no, - fD(cell_faces) .* c_hf, [Nc, 1]);

% Output
ops = struct('AD', AD, 'rhs', rhs);