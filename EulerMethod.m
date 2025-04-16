function sol = EulerMethod(f, a, b, N, alpha)
    h = (b-a)/N;
    t = a;
    w = alpha;
    disp(t);
    disp(w);
    for i = 1:N
        w = w + h*f(t, w);
        t = a + i*h;
        disp(t);
        disp(w);
    end
    sol = w;
end