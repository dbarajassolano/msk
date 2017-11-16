function K = mgp_Kfun(hyp, x, z)

if (nargin < 3) || (isempty(z))
    z = x;
end

K = feval(@covMN, hyp, x, z);