function [c,x, calculated_val] = Legendre(n, func, lower_bound, upper_bound)
    %
    % this routine computes the weights and nodes
    % for the n-node Gaussian quadrature
    % through the n-th order Legendre polynomial.
    %
    % Written by Ming Gu for Math 128A, Fall 2008
    %
    b = (1:n-1)';
    b = b./sqrt((2*b-1).*(2*b+1));
    B = diag(b,1)+diag(b,-1);
    [Q,D] = eig(B);
    x = diag(D);
    x(abs(x)<1e-15) = 0;
    c = 2*(Q(1,:).^2)';

    sum = 0;
    weight_iter = 1;
    for val = c
        sum = val.*func(x(weight_iter)) + sum;
        weight_iter = weight_iter + 1;
    end
    sum = (upper_bound - lower_bound)/2 .* sum;

    final = 0;
    iter = 1;
    while iter <= length(sum)
        final = final + sum(iter);
        iter = iter + 1;
    end
    calculated_val = final;
end
