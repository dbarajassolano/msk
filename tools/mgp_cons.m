function [c, ceq] = mgp_cons(hyp)

l1  = exp(hyp(1)); v1 = exp(hyp(2));
l2  = exp(hyp(4)); v2 = exp(hyp(5));
l12 = exp(hyp(7));
rho = (exp(hyp(8)) - 1) / (exp(hyp(8)) + 1);

v12 = 0.5 * (v1 + v2);

a1  = sqrt(2 * v1) / l1;
a2  = sqrt(2 * v2) / l2;
a12 = sqrt(2 * v12) / l12;

a12lim = sqrt(0.5 * (a1^2 + a2^2));
rholim = (a1^v1 * a2^v2 / (a12^(v1 + v2))) * (gamma(0.5 * (v1 + v2)) / (sqrt(gamma(v1)) * sqrt(gamma(v2))));

c = [a12lim^2 - a12^2; rho - rholim];
ceq = [];
