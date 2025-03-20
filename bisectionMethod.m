function [p, iter] = bisectionMethod(func, a, b, TOL, max)
    iter = 0;
    while iter < max
        iter = iter + 1;
        p = (a + b) / 2;
        if abs(func(p) - func(a)) < TOL
            break;
        end
        if func(a)*func(p) > 0
            a = p;
        else
            b = p;
        end
    end
end