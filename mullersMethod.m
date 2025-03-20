function [p, iter] = mullersMethod(func, p0, p1, p2, TOL, maxIter)
    iter = 3;
    h1 = p1 - p0;
    h2 = p2 - p1;
    delta1 = (func(p1) - func(p0))/h1;
    delta2 = (func(p2) - func(p1))/h2;
    d = (delta2 - delta1)/(h2 + h1);
    while iter < maxIter
        b = delta2 + h2*d;
        D = (b^2 - 4*func(p2)*d)^(1/2);
        if abs(b - D) < abs(b + D)
            E = b + D;
        else
            E = b - D;
        end
        h = -2*func(p2)/E;
        p = p2 + h;
        if abs(h) < TOL
            break;
        end
        p0 = p1;
        p1 = p2;
        p2 = p;
        h1 = p1 - p0;
        h2 = p2 - p1;
        delta1 = (func(p1) - func(p0))/h1;
        delta2 = (func(p2) - func(p1))/h2;
        d = (delta2 - delta1)/(h2 + h1);
        iter = iter + 1;
    end
end