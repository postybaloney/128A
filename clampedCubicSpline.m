function [a_j, b_j, c_j, d_j] = clampedCubicSpline(x,fx, FPO, FPN)
    a_j = fx;
    b_j = [];
    c_j = [];
    d_j = [];
    alphai = [];
    for j = 1:length(x)
        b_j(j) = nan;
        c_j(j) = nan;
        d_j(j) = nan;
        alphai(j) = nan;
    end
    hi = [];
    for i = 1:length(x) - 1
        hi(i) = x(i + 1) - x(i);
    end
    alphai(1) = (3*(a_j(2) - a_j(1))/hi(1)) - 3*FPO;
    alphai(length(x)) = 3*FPN - 3*(a_j(length(x) - a_j(length(x) - 1))/hi(length(x) - 1));
    for i = 2:length(x) - 1
        alphai(i) = (3/hi(i) .* (a_j(i+1) - a_j(i))) - (3/hi(i - 1) .* (a_j(i) - a_j(i - 1)));
    end
    li = [];
    mui = [];
    zi = [];
    li(1) = 2*hi(1);
    mui(1) = 0.5;
    zi(1) = alphai(1)/li(1);
    for i = 2:length(x) - 1
        li(i) = 2.*(x(i + 1) - x(i - 1)) - hi(i - 1).*mui(i - 1);
        mui(i) = hi(i)/li(i);
        zi(i) = (alphai(i) - hi(i-1).*zi(i - 1))/li(i);
    end
    li(length(x)) = hi(length(x) - 1).*(2 - mui(length(x) - 1));
    zi(length(x)) = (alphai(length(x)) - hi(length(x) - 1).*zi(length(x) - 1))/li(length(x));
    c_j(length(x)) = zi(length(x));
    for j = (length(x) - 1):-1:1
        c_j(j) = zi(j) - mui(j).*c_j(j+1);
        b_j(j) = ((a_j(j + 1) - a_j(j))/hi(j)) - (hi(j)*(c_j(j+1) + 2*c_j(j)))/3;
        d_j(j) = (c_j(j+1) - c_j(j))/(3*hi(j));
    end
end