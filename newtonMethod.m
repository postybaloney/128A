function [p,iter, pn_arr] = newtonMethod(func, p0, TOL, maxIter)
    iter = 0;
    pn_arr = [];
    arr_iter = 1;
    syms x
    f_symbolic = func(x);
    differentiated = diff(f_symbolic);
    while iter < maxIter
        p = p0 - func(p0)/vpa(subs(differentiated, x, p0));
        pn_arr(arr_iter) = p;
        arr_iter = arr_iter + 1;
        if abs(p - p0) < TOL
            break;
        end
        iter = iter + 1;
        p0 = p;
    end
end