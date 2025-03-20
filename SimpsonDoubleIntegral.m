function [calculated_val] = SimpsonDoubleIntegral(f, dx, cx, a, b, m, n)
    h = (b - a)/n;
    J1 = 0;
    J2 = 0;
    J3 = 0;
    for i = 1:n+1
        x = a + i*h;
        if isa(dx, "double") && isa(cx, "double")
            HX = (dx - cx)/m;
            K1 = f(x, cx) + f(x, dx);
        else
            HX = (dx(x) - cx(x))/m;
            K1 = f(x, cx(x)) + f(x, dx(x));
        end
        K2 = 0;
        K3 = 0;
        for j = 1:m-1
            if isa(cx, "double")
                y = cx + j*HX;
            else
                y = cx(x) + j*HX;
            end
            Q = f(x, y);
            if mod(j, 2) == 0
                K2 = K2 + Q;
            else
                K3 = K3 + Q;
            end
        end
        L = (K1 + 2*K2 + 4*K3)*HX/3;
        if i == 1 || i == n+1
            J1 = J1 + L;
        elseif mod(i, 2) == 0
            J2 = J2 + L;
        else
            J3 = J3 + L;
        end
    end
    calculated_val = h*(J1 + 2*J2 + 4*J3)/3;
end