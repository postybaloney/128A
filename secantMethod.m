function [p,iter] = secantMethod(func, p0, p1, TOL, maxIter)
    iter = 0;
    q0 = func(p0);
    q1 = func(p1);
    while iter < maxIter
        p = p1 - q1*(p1 - p0)/(q1 - q0);
        if abs(p - p1) < TOL
            break;
        end
        iter = iter + 1;
        p0 = p1;
        q0 = q1;
        p1 = p;
        q1 = func(p);
    end
end