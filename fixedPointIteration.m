function [p,iter] = fixedPointIteration(func, p0, TOL, maxIter)
    iter = 0;
    while iter < maxIter
        p = func(p0);
        if abs(p - p0) < TOL
            break;
        end
        iter = iter + 1;
        p0 = p;
    end
end