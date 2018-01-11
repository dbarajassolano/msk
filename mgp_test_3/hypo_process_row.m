function hypp = hypo_process_row(hypo)

l1  = exp(hypo(1)); v1  = exp(hypo(2)); s1 = exp(hypo(3));
l2  = exp(hypo(4)); v2  = exp(hypo(5)); s2 = exp(hypo(6));
l12 = exp(hypo(7)); v12 = 0.5 * (v1 + v2);
rho = (exp(hypo(8)) - 1) / (exp(hypo(8)) + 1);
s12 = sqrt(s1 * s2 * rho);
sn1 = exp(hypo(9));
sn2 = exp(hypo(10));

hypp = [l1, v1, s1, l2, v2, s2, l12, v12, rho, s12, sn1, sn2];