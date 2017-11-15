function [nlml, K] = gausslik(hyp, covfunc, x, y)

n    = length(y);
K    = feval(covfunc{:}, hyp(1 : end - 1), x);
sn   = exp(hyp(end));
sn2  = sn^2;
B    = K + eye(n) * sn2;
nlml = (y' * (B \ y)) / 2 + log(det(B)) / 2 + n * log(2 * pi) / 2;
