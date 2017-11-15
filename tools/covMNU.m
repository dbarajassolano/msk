function K = covMNU(hyp, x, z)

if nargin < 2
    K = 'D';
    return;
end

if (nargin < 3) || (isempty(z))
    z = x;
end

l      = exp(hyp(1));
nu     = exp(hyp(2));
[n, ~] = size(x);
[m, ~] = size(z);
R      = zeros(n, m);
for i = 1 : m
    R(:, i) = sqrt(sum(bsxfun(@minus, x, z(i, :)).^2, 2));
end

R = R + eps;
k = @(R) (2^(1 - nu) / gamma(nu)) .* (sqrt(2 * nu) * R / l).^nu .* besselk(nu, sqrt(2 * nu) * R / l);
K = k(R);