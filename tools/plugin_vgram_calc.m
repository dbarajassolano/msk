function vgram = plugin_vgram_calc(hypo, x)

g = @(R, l, nu, s, t) s^2 * (1 - (2^(1 - nu) / gamma(nu)) .* (sqrt(2 * nu) * (R + eps) / l).^nu .* besselk(nu, sqrt(2 * nu) * (R + eps) / l)) + t^2;

hypp = hypo_process(hypo);

vgram = struct('c', g(x, hypp.l1, hypp.v1, hypp.s1, hypp.sn1), 'f', g(x, hypp.l2, hypp.v2, hypp.s2, hypp.sn2), 'cf', g(x, hypp.l12, hypp.v12, hypp.s12, 0), 'x', x);