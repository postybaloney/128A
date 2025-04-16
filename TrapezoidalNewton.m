function [w] = TrapezoidalNewton(func, a, b, N, alpha, TOL, M)
    syms y t;
    f_symbolic = func(t, y);
    differentiated = diff(f_symbolic, y);
    h = (b-a)/N;
    t_other = a;
    w = alpha;
    disp([t_other, w])
    for i = 1:N
        k1 = w + (h/2)*func(t_other, w);
        w0 = k1;
        j = 1;
        FLAG = 0;
        while FLAG == 0
            w = w0 - (w0 - (h*func(t_other + h, w0))/2 - k1)/(1 - (h*vpa(subs(differentiated, [t y], [t_other + h, w0]))/2));
            if abs(w - w0) < TOL
                FLAG = 1;
            else
                j = j + 1;
                w0 = w;
                if j > M
                    break;
                end
            end
        end
        t_other = a + i*h;
        disp([t_other, w])
    end
end