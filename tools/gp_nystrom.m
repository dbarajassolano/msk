function [pred, predlow, L2] = gp_nystrom(geom, Nlow, hypo, yfobs, ycobs, xfobs, xcobs, scale)

if nargin < 8, scale = 'coarse'; end

% Multivariate Matèrn parameters
l1  = exp(hypo(1)); v1  = exp(hypo(2)); s1 = exp(hypo(3));
l2  = exp(hypo(4)); v2  = exp(hypo(5)); s2 = exp(hypo(6));
% l12 = exp(hypo(7)); v12 = 0.5 * (v1 + v2);
% rho = (exp(hypo(8)) - 1) / (exp(hypo(8)) + 1);
% s12 = sqrt(s1 * s2 * rho);
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

switch scale
  case 'coarse'
    Kobs = Kcobs + eye(Ncobs) * sn1^2;
  case 'fine'
    Kobs = Kfobs + eye(Nfobs) * sn2^2;
end

% Prediction
predlow = struct('mean', [], 'var', []);

switch scale
  case 'coarse'
    Qc   = Kc - Kcp * (Kobs \ Kcp');
    predlow.mean = Kcp * (Kobs \ ycobs);
    predlow.var  = diag(Qc);
  case 'fine'
    Qf   = Kf - Kfp * (Kobs \ Kfp');
    predlow.mean = Kfp * (Kobs \ yfobs);
    predlow.var  = diag(Qf);
end

%% Nystrom's method
pred = struct('mean', [], 'var', []);

switch scale
  case 'coarse'
    Kc2   = mgp_Kfun(hypc,  geom.xc, geomlow.xc);
    Kcp2  = mgp_Kfun(hypc,  geom.xc, xcobs);
    Qc2   = Kc2 - Kcp2 * (Kobs \ Kcp');
    % Mean
    pred.mean = Kcp2 * (Kobs \ ycobs);
    % Variance
    L  = chol(Qc, 'lower');
    L2 = Qc2 / (L');
    pred.var = sum(L2.^2, 2);
  case 'fine'
    Kf2   = mgp_Kfun(hypf,  geom.xc, geomlow.xc);
    Kfp2  = mgp_Kfun(hypf,  geom.xc, xfobs);
    Qf2   = Kf2 - Kfp2 * (Kobs \ Kfp');
    % Mean
    pred.mean = Kfp2 * (Kobs \ yfobs);
    % Variance
    L  = chol(Qf, 'lower');
    L2 = Qf2 / (L');
    pred.var = sum(L2.^2, 2);
end