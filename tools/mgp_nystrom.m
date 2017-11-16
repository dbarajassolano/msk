function [pred, predlow, L2] = mgp_nystrom(geom, Nlow, hypo, yfobs, ycobs, xfobs, xcobs, scale)

if nargin < 8, scale = 'coarse'; end

% Multivariate Matèrn parameters
l1  = exp(hypo(1)); v1  = exp(hypo(2)); s1 = exp(hypo(3));
l2  = exp(hypo(4)); v2  = exp(hypo(5)); s2 = exp(hypo(6));
l12 = exp(hypo(7)); v12 = 0.5 * (v1 + v2);
rho = (exp(hypo(8)) - 1) / (exp(hypo(8)) + 1);
s12 = sqrt(s1 * s2 * rho);
sn1 = exp(hypo(9));
sn2 = exp(hypo(10));

%% Low resolution
% Geometry
geomlow = geom_2d(geom.L, Nlow);

% Low resolution covariances
Ncobs = length(ycobs);
Nfobs = length(yfobs);
xctlow = geomlow.xc;

% Covariances
hypc  = log([l1; v1; s1]);
Kc    = mgp_Kfun(hypc, xctlow);
Kcp   = mgp_Kfun(hypc, xctlow, xcobs);
Kcobs = mgp_Kfun(hypc,         xcobs);

hypf  = log([l2; v2; s2]);
Kf    = mgp_Kfun(hypf, xctlow);
Kfp   = mgp_Kfun(hypf, xctlow, xfobs);
Kfobs = mgp_Kfun(hypf,         xfobs);

hypcf  = log([l12; v12; s12]);
Kcfp   = mgp_Kfun(hypcf, xctlow, xfobs);
Kfcp   = mgp_Kfun(hypcf, xctlow, xcobs);
Kcfobs = mgp_Kfun(hypcf, xcobs,  xfobs);

Kobs = [Kcobs + eye(Ncobs) * sn1^2, Kcfobs; Kcfobs', Kfobs + eye(Nfobs) * sn2^2];

% Prediction
predlow = struct('mean', [], 'var', []);

switch scale
  case 'coarse'
    Qcp  = [Kcp, Kcfp];
    Qc   = Kc - Qcp * (Kobs \ Qcp');
    predlow.mean = Qcp * (Kobs \ [ycobs; yfobs]);
    predlow.var  = diag(Qc);
  case 'fine'
    Qfp  = [Kfcp, Kfp];
    Qf   = Kf - Qfp * (Kobs \ Qfp');
    predlow.mean = Qfp * (Kobs \ [ycobs; yfobs]);
    predlow.var  = diag(Qf);
end

%% Nystrom's method
pred = struct('mean', [], 'var', []);

switch scale
  case 'coarse'
    Kc2   = mgp_Kfun(hypc,  geom.xc, geomlow.xc);
    Kcp2  = mgp_Kfun(hypc,  geom.xc, xcobs);
    Kcfp2 = mgp_Kfun(hypcf, geom.xc, xfobs);
    Qcp2  = [Kcp2, Kcfp2];
    Qc2   = Kc2 - Qcp2 * (Kobs \ Qcp');
    % Mean
    pred.mean = Qcp2 * (Kobs \ [ycobs; yfobs]);
    % Variance
    L  = chol(Qc, 'lower');
    L2 = Qc2 / (L');
    pred.var = sum(L2.^2, 2);
  case 'fine'
    Kf2   = mgp_Kfun(hypf,  geom.xc, geomlow.xc);
    Kfp2  = mgp_Kfun(hypf,  geom.xc, xfobs);
    Kfcp2 = mgp_Kfun(hypcf, geom.xc, xcobs);
    Qfp2  = [Kfcp2, Kfp2];
    Qf2   = Kf2 - Qfp2 * (Kobs \ Qfp');
    % Mean
    pred.mean = Qfp2 * (Kobs \ [ycobs; yfobs]);
    % Variance
    L  = chol(Qf, 'lower');
    L2 = Qf2 / (L');
    pred.var = sum(L2.^2, 2);
end