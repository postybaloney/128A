function [value, error] = lagrangeInterpolationNotGivenF(x0, fx0, x1, fx1, x2, fx2, x3, fx3, degree, evalX)
    if degree == 1
        P1x = @(x)(fx0 + (x-x0)*(fx1 - fx0)/(x1 - x0));
        value = P1x(evalX);
    elseif degree == 2
        P2x = @(x)(fx0*((x - x1)*(x-x2))/((x0 - x1)*(x0 - x2)) + fx1*((x - x0)*(x-x2))/((x1 - x0)*(x1 - x2)) + fx2*((x - x0)*(x-x1))/((x2 - x0)*(x2 - x1)));
        syms x
        f_symbolic = P2x(x);
        differentiated = diff(f_symbolic);
        diffEval = vpa(subs(differentiated, x, evalX))
        value = P2x(evalX);
    elseif degree == 3
        firstorderx0x1 = (fx1 - fx0)/(x1 - x0);
        firstorderx1x2 = (fx2 - fx1)/(x2 - x1);
        firstorderx2x3 = (fx3 - fx2)/(x3 - x2);
        secondorderx0x1x2 = (firstorderx1x2 - firstorderx0x1)/(x2 - x0);
        secondorderx1x2x3 = (firstorderx2x3 - firstorderx1x2)/(x3 - x1);
        thirdOrderDifference = (secondorderx1x2x3 - secondorderx0x1x2)/(x3 - x0);
        P3x = @(x)(fx0 + firstorderx0x1*(x - x0) + secondorderx0x1x2*(x-x0)*(x-x1) + thirdOrderDifference*(x - x0)*(x - x1)*(x - x2));
        value = P3x(evalX);
    else
        disp("Function not effective for degree greater than 3")
    end
    %% error = abs(func(evalX) - value);
end