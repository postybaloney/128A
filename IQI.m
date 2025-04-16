function x3 = IQI(func, x)
    f_eval = func(x)
    x3 = (f1*f2)*x0/((f0-f1)*(f0-f2)) + (f0*f2)*x1/((f1-f0)*(f1-f2)) + (f0*f1)*x2/((f2-f0)*(f2-f1));
end