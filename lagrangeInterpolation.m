function [value, error] = lagrangeInterpolation(func, x0, x1, x2, x3, degree, evalX)
    if degree == 1
        P1x = @(x)(func(x0) + (x-x0)*(func(x1) - func(x0))/(x1 - x0));
        value = P1x(evalX);
    elseif degree == 2
        P2x = @(x)(func(x0)*((x - x1)*(x-x2))/((x0 - x1)*(x0 - x2)) + func(x1)*((x - x0)*(x-x2))/((x1 - x0)*(x1 - x2)) + func(x2)*((x - x0)*(x-x1))/((x2 - x0)*(x2 - x1)));
        value = P2x(evalX);
    elseif degree == 3
        firstorderx0x1 = (func(x1) - func(x0))/(x1 - x0);
        firstorderx1x2 = (func(x2) - func(x1))/(x2 - x1);
        firstorderx2x3 = (func(x3) - func(x2))/(x3 - x2);
        secondorderx0x1x2 = (firstorderx1x2 - firstorderx0x1)/(x2 - x0);
        secondorderx1x2x3 = (firstorderx2x3 - firstorderx1x2)/(x3 - x1);
        thirdOrderDifference = (secondorderx1x2x3 - secondorderx0x1x2)/(x3 - x0);
        P3x = @(x)(func(x0) + firstorderx0x1*(x - x0) + secondorderx0x1x2*(x-x0)*(x-x1) + thirdOrderDifference*(x - x0)*(x - x1)*(x - x2));
        value = P3x(evalX);
    else
        disp("Function not effective for degree greater than 3")
    end
    error = abs(func(evalX) - value);
end