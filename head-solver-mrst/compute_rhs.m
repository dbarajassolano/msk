function [c_hf, c_struct, c_val, flux_gf, flux_struct] = compute_rhs(G, bc)
% Compute right-hand side contributions to flow problem linear system
% Adapted from the MRST function solvers/computePressureRHS

N_hf = size(G.cells.faces, 1); % Number of half-faces
N_gf = G.faces.num;            % Number of global faces

c_hf        = zeros(N_hf, 1);
c_struct    = false(N_gf, 1);
flux_gf     = zeros(N_gf, 1);
flux_struct = false(N_gf, 1);
c_val       = [];

if ~isempty(bc),
    % Check that bc and g are compatible.
    assert (max(bc.face) <= G.faces.num && min(bc.face) > 0, 'Boundary condition refer to face not existant in grid.');
    assert (all(accumarray(bc.face, 1, [G.faces.num, 1]) <= 1), 'There are repeated faces in boundary condition.');
    
    % Dirichlet boundary conditions.
    %  1) Extract the faces marked as defining pressure conditions.
    %     Define a local numbering (map) of the face indices to the
    %     pressure condition values.
    %
    is_press = strcmpi('pressure', bc.type);
    face     = bc.face (is_press);
    c_val    = bc.value(is_press);
    map      = sparse(double(face), 1, 1 : numel(face));
    
    %  2) For purpose of (mimetic) pressure solvers, mark the 'face's as
    %     having pressure boundary conditions.  This information will be
    %     used to eliminate known pressures from the resulting system of
    %     linear equations.  See (e.g.) 'solveIncompFlow' for details.
    %
    c_struct(face) = true;
    
    %  3) Enter Dirichlet conditions into system right hand side.
    %     Relies implictly on boundary faces being mentioned exactly once
    %     in g.cells.faces(:,1).
    %
    i       =   c_struct(G.cells.faces(:, 1));
    c_hf(i) = -c_val(map(G.cells.faces(i, 1)));
    
    %  4) Reorder Dirichlet conditions according to SORT(face).  This
    %     allows the caller to issue statements such as 'X(dF) = dC' even
    %     when ISLOGICAL(dF).
    %
    c_val = c_val(map(c_struct));
    
    % Flux (Neumann) boundary conditions.
    %
    is_flux           = strcmpi('flux', bc.type);
    face              = bc.face(is_flux);
    flux_struct(face) = true;
    flux_gf(face)     = -bc.value(is_flux);
end