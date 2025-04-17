% Copyright (C) 2025 by Raehyun Kim (rhkim79@math.berkeley.edu)
clc; clear;
% approximate n_bisec based on the length of interval
appx_bisec = false;
func1 = @(x) x*exp(-x) - 2*x + 1; Int1.a = 0; Int1.b = 3;
func2 = @(x) x*cos(x) - 2*x^2 + 3*x - 1; Int2.a = 1; Int2.b = 3;
func3 = @(x) x^3-7*x^2+14*x-6; Int3.a = 0; Int3.b = 1;
func4 = @(x) sqrt(x)-cos(x); Int4.a = 0; Int4.b = 1;
func5 = @(x) sign(x)*abs(x)^(1/3); Int5.a = -1; Int5.b = 8;
func6 = @(x) (x-3)^11; Int6.a = 2.4; Int6.b = 3.4;
func7 = @(x) x^4 -2*x^3-4*x^2+4*x+4; Int7.a = 0; Int7.b = 2;

test_functions = {func1, func2, func3, func4, func5, func6, func7};
test_intervals = {Int1, Int2, Int3, Int4, Int5, Int6, Int7};

test_it = {7, 8, 7, 6, 57, 3, 9};
test_bisec = {26, 27, 26, 24, 29, 3, 27};

params.root_tol = 1e-7; params.func_tol = 1e-7;

nsize = size(test_functions);
ntest = nsize(2);
for j = 1:ntest
    func = test_functions{j}; Int = test_intervals{j};
    disp("#####")
    profile on
    %%%%
    % PUT YOUR FUNCTION NAME BELOW e.g.
    % [root, info] = modifiedzeroin31415926535(func, Int, params)
    %%%%
    [root, info] = modifiedzeroin3037680414_v2(func, Int, params);
    profile off
    % Verify root
    root_tol_check = abs(root - fzero(func, root)) < params.root_tol;
    func_tol_check = abs(func(root)) < params.func_tol;
    int_check = (root > Int.a) & (root < Int.b);
    if (root_tol_check || func_tol_check) && int_check
        flag_root = true;
        score_acc(j) = 70;
    else
        flag_root = false;
        score_acc(j) = 0;
    end
    % check # of function calls
    p = profile('info');
    foo = {p.FunctionTable.CompleteName};
    bar = strfind(foo, func2str(func));
    bar2 = strfind(foo, vectorize(func));
    fcall_idx = find(~cellfun(@isempty, bar));
    fcall_idx2 = find(~cellfun(@isempty, bar2));
    num_fcall = p.FunctionTable(fcall_idx).NumCalls;
    num_fcall2 = 0;
    % num_fcall2 = p.FunctionTable(fcall_idx2).NumCalls;

    % compute score_eff
    if appx_bisec
        n_bisec = ceil(log2((Int.b-Int.a)/params.root_tol))+2;
    else
        n_bisec = test_bisec{j};
    end

    buffer = 10;

    n_ideal = test_it{j};
    n_upper = max(n_bisec, 2*n_ideal) + buffer;
    n_lower = n_ideal + buffer;
    score_eff(j) = min((n_upper-num_fcall)/(n_upper-n_lower),1)*30;
    if num_fcall <= n_ideal + buffer/2
        score_extra(j) = 5;
    else
        score_extra(j) = 0;
    end
    if flag_root
        fprintf("Test function %d : Found with %d calls !! \n", ...
        j, num_fcall);
        score_tot(j) = score_acc(j) + score_eff(j) + score_extra(j);
        fprintf("acc : %.2f \t eff : %.2f \t extra : %.2f \t tot : %.2f \n", ...
        score_acc(j), score_eff(j), score_extra(j), score_tot(j));
    else
        fprintf("Test function %d : Failed with %d calls !! \n", ...
        j, num_fcall);
        score_tot(j) = 0;
        % score_tot(j) = score_acc(j) + score_eff(j) + score_extra(j);
        fprintf("acc : %.2f \t eff : %.2f \t extra : %.2f \t tot : %.2f \n", ...
        score_acc(j), score_eff(j), score_extra(j), score_tot(j));
    end
end

final_score = sum(score_tot) / ntest;
disp("#####")
fprintf('Final score : %f \n', final_score);

