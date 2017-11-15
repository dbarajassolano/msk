function [nlml, K] = LOOlik(hyp, covfunc, x, y)

n   = length(y);
K   = feval(covfunc{:}, hyp(1 : end - 1), x);
sn  = exp(hyp(end));
sn2 = sn^2;
B   = K + eye(n) * sn2;

Kinv  = inv(B);
Kinvy = Kinv * y;
Kinvi = diag(Kinv);
ymmui = Kinvy ./ Kinvi;
si2   = 1 ./ Kinvi;
nlmlv = 0.5 * log(2 * pi * si2) + 0.5 * ymmui.^2 ./ si2;
nlml  = sum(nlmlv);