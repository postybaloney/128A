function [phat] = aitkensMethod(pn)
    phat = [];
    arr_iter = 1;
    iter = 1;
    while iter < size(pn, 2) - 2
        phat(arr_iter) = pn(iter) - (((pn(iter+1) - pn(iter)).^2)/(pn(iter+2) - 2.*pn(iter+1) + pn(iter)));
        arr_iter = arr_iter + 1;
        iter = iter + 1;
    end
end