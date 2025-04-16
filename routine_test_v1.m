% Copyright (C) 2025 by Raehyun Kim (rhkim79@math.berkeley.edu)
efficient_flag = 1;
clc; clear;
func1 = @(x) x*exp(-x) - 2*x + 1; Int1.a = 0; Int1.b = 3;
func2 = @(x) x*cos(x) - 2*x^2 + 3*x - 1; Int2.a = 1; Int2.b = 3;
func3 = @(x) x^3-7*x^2+14*x-6; Int3.a = 0; Int3.b = 1;
func4 = @(x) sqrt(x)-cos(x); Int4.a = 0; Int4.b = 1;
func5 = @(x) sign(x)*abs(x)^(1/3); Int5.a = -1; Int5.b = 8;
func6 = @(x) (x-3)^11; Int6.a = 2.4; Int6.b = 3.4;
func7 = @(x) x^4 -2*x^3-4*x^2+4*x+4; Int7.a = 0; Int7.b = 2;

test_functions = {func1, func2, func3, func4, func5, func6, func7};
test_intervals = {Int1, Int2, Int3, Int4, Int5, Int6, Int7};

params.root_tol = 1e-7; params.func_tol = 1e-7;
for j = 5:7
    func = test_functions{j}; Int = test_intervals{j};
    disp("#####")
    profile on
    %%%%
    % PUT YOUR FUNCTION NAME BELOW e.g.
    % [root, info] = modifiedzeroin31415926535(func, Int, params)
    %%%%
    [root, info] = modifiedzeroin3037680414(func, Int, params);
    profile off
    root_tol_check = abs(root - fzero(func, root)) < params.root_tol;
    func_tol_check = abs(func(root)) < params.func_tol;
    int_check = (root > Int.a) & (root < Int.b);
    if (root_tol_check || func_tol_check) && int_check
        fprintf("CORRECT for test function %d !! \n", j);
    else
        disp(root)
        disp(root_tol_check)
        disp(func_tol_check)
        disp(int_check)
        fprintf("FAILED for test function%d !! \n", j);
    end
    p = profile('info');
    foo = {p.FunctionTable.CompleteName};
    bar = strfind(foo, func2str(func));
    bar2 = strfind(foo, vectorize(func));
    fcall_idx = find(~cellfun(@isempty, bar));
    fcall_idx2 = find(~cellfun(@isempty, bar2));
    num_fcall = p.FunctionTable(fcall_idx).NumCalls;
    num_fcall2 = p.FunctionTable(fcall_idx2).NumCalls;
    
    fprintf("It takes %d %d function calls !! \n", num_fcall, num_fcall2);
end
