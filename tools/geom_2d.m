classdef geom_2d < handle
    properties
        L
        N
        Nc
        xc
        dx
        dy
        x
        y
    end
    methods
        function self = geom_2d(L, N)
            self.L  = L;
            self.N  = N;
            self.dx = self.L(1) / self.N(1);
            self.dy = self.L(2) / self.N(2);
            self.Nc = prod(N);
            [self.xc, self.x, self.y] = centroids_calc(self);
        end
        function p = partition(self, M)
            function edges = part_idx(N, M, delta)
                S2 = floor(N / M);
                S1 = S2 + 1;
                M1 = rem(N, M);
                M2 = M - M1;
                edges1 = (0 : M1) * S1 * delta;
                edges2 = edges1(end) + (1 : M2) * S2 * delta;
                edges  = [edges1, edges2];
            end
            ex = part_idx(self.N(1), M(1), self.dx);
            ey = part_idx(self.N(2), M(2), self.dy);
            
            idx = zeros(self.Nc, 1);
            pk  = 1;
            for i = 1 : M(2)
                for j = 1 : M(1)
                    ix = (self.xc(:, 1) < ex(j + 1)) & (self.xc(:, 1) > ex(j));
                    iy = (self.xc(:, 2) < ey(i + 1)) & (self.xc(:, 2) > ey(i));
                    idx(ix & iy) = pk;
                    pk = pk + 1;
                end
            end
            p = struct('idx', idx, 'M', M, 'Mc', prod(M));
        end
        function T = arithmetic_avg_op_calc(self, p)
            T = zeros(p.Mc, self.Nc);
            for i = 1 : p.Mc
                T(i, p.idx == i) = 1 / (sum(p.idx == i));
            end
        end
    end
    methods(Access = private)
        function [xc, x, y] = centroids_calc(self)
            x  = linspace(0.5 * self.dx, self.L(1) - 0.5 * self.dx, self.N(1));
            y  = linspace(0.5 * self.dy, self.L(2) - 0.5 * self.dy, self.N(2));
            [X, Y] = meshgrid(x, y);
            X  = X'; Y = Y';
            x  = x'; y = y';
            xc = [X(:), Y(:)];     
        end
    end
end