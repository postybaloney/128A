function [a_j, b_j, c_j, d_j] = naturalCubicSpline(x,fx)
    a_j = fx;
    b_j = [];
    c_j = [];
    d_j = [];
    for j = 1:length(x)
        b_j(j) = nan;
        c_j(j) = nan;
        d_j(j) = nan;
    end
    hi = [];
    for i = 1:length(x) - 1
        hi(i) = x(i + 1) - x(i);
    end
    alphai = [];
    alphai(1) = nan;
    for i = 2:length(x) - 1
        alphai(i) = (3/hi(i) .* (fx(i+1) - fx(i))) - (3/hi(i - 1) .* (fx(i) - fx(i - 1)));
    end
    li = [];
    mui = [];
    zi = [];
    li(1) = 1;
    mui(1) = 0;
    zi(1) = 0;
    group_iter = 2;
    for i = 2:length(x) - 1
        li(i) = 2.*(x(i + 1) - x(i - 1)) - hi(i - 1).*mui(i - 1);
        mui(i) = hi(i)/li(i);
        zi(i) = (alphai(i) - hi(i-1).*zi(i - 1))/li(i);
        group_iter = group_iter + 1;
    end
    li(length(x)) = 1;
    zi(length(x)) = 0;
    c_j(length(x)) = 0;
    for j = (length(x) - 1):-1:1
        c_j(j) = zi(j) - mui(j).*c_j(j+1);
        b_j(j) = ((fx(j + 1) - fx(j))/hi(j)) - (hi(j)*(c_j(j+1) + 2*c_j(j)))/3;
        d_j(j) = (c_j(j+1) - c_j(j))/(3*hi(j));
    end
end