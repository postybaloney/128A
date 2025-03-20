function P = nevilleInterpolation(evalX, xArray, func)
    P = zeros(length(xArray), length(xArray));
    for i = 1:length(xArray)
        P(i, 1) = P(i, 1) + func(xArray(i));
    end
    for j = 2:length(xArray)
        for i = j+1:length(xArray)
            top = ((evalX - xArray(i - j)).*P(i, j - 1) - (evalX - xArray(i)).*P(i - 1, j - 1));
            P(i, j) = P(i, j) + top/(xArray(i) - xArray(i - j));
        end
    end
end