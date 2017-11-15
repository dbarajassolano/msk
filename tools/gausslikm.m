function [nlml, K] = gausslikm(hyp, covfunc, x, y, varargin)

x1 = x{1}; x2 = x{2};
y1 = y{1}; y2 = y{2};
n1 = length(y1); n2 = length(y2);
n = n1 + n2;
y = [y1; y2];

hyp1 = hyp(1 : 3);
hyp2 = hyp(4 : 6);
rho  = (exp(hyp(8)) - 1) / (exp(hyp(8)) + 1);

v1 = exp(hyp(2)); s1 = exp(hyp(3));
v2 = exp(hyp(5)); s2 = exp(hyp(6));
v12lim = 0.5 * (v1 + v2);

v12 = v12lim;
l12 = exp(hyp(7));

s12  = sqrt(s1 * s2 * rho);
hyp3 = log([l12; v12; s12]);

K1  = feval(covfunc{1}{:}, hyp1, x1);
K2  = feval(covfunc{2}{:}, hyp2, x2);
K12 = feval(covfunc{3}{:}, hyp3, x1, x2);

K = [K1, K12; K12', K2];

t1 = exp(2 * hyp(end - 1));
t2 = exp(2 * hyp(end));
vn = [ones(n1, 1) * t1; ones(n2, 1) * t2];

B    = K + diag(vn);
nlml = (y' * (B \ y)) / 2 + log(det(B)) / 2 + n * log(2 * pi) / 2;
