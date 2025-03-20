function [p, iter] = steffensenMethod(func, p0, TOL, maxIter)
    iter = 1;
    while iter < maxIter
        p1_iter1 = func(p0);
        p2_iter1 = func(p1_iter1);
        p = p0 - (p1_iter1 - p0).^2/(p2_iter1 - 2.*p1_iter1 + p0);
        if abs(p - p0) < TOL
            break;
        end
        iter = iter + 1;
        p0 = p;
    end
end