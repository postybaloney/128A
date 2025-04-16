function [root, info, final_calls] = modifiedzeroin_v2(func, a, b, root_tol, func_tol)
    x0 = a;
    x1 = b;
    x2 = (x1+x0)/2;
    tot_calls = 0;
    IQI_iters = 0;
    while true
        [x3, IQI_calls, f0, f1, f2] = IQI(func, [x0, x1, x2]);
        tot_calls = tot_calls + IQI_calls;
        IQI_iters = IQI_iters + 1;
        if f0*f2 < 0 
            [x3, IQI_calls, f0, f1, f2] = IQI(func, [x0, x2, x3]);
            tot_calls = tot_calls + IQI_calls;
            IQI_iters = IQI_iters + 1;
        end
        if f2*f1 < 0
            [x3, IQI_calls, f0, f1, f2] = IQI(func, [x1, x2, x3]);
            tot_calls = tot_calls + IQI_calls;
            IQI_iters = IQI_iters + 1;
        end
        if abs(x2-x0) < root_tol
            root = x3;
            info = 0;
            final_calls = tot_calls;
            break;
        end
        %% f3 = func(x3);
        %% tot_calls = tot_calls + 1; %% calculating func(x3)
        % if abs(f3) < func_tol
        %     root = x3;
        %     info = 0;
        %     final_calls = tot_calls;
        %     break;
        % end
        if (x3 < a || x3 > b) || (IQI_iters >= 4)
            % disp("Bisect")
            % disp(IQI_iters)
            [anew, bnew, Bi_calls] = oneStepBisection(func, a, b);
            tot_calls = tot_calls + Bi_calls;
            a = anew;
            b = bnew;
            x0 = a;
            x1 = b;
            x2 = (x1+x0)/2;
            if IQI_iters >= 4
                IQI_iters = 0;
            end
        end
    end
    root = x3;
    info = 1;
    final_calls = tot_calls;
end

function [x3, calls, f0, f1, f2] = IQI(func, x)
    f_eval = func(x);
    f0 = f_eval(1);
    f1 = f_eval(2);
    f2 = f_eval(3);
    x0 = x(1);
    x1 = x(2);
    x2 = x(3);
    x3 = (f1.*f2).*x0/((f0-f1).*(f0-f2)) + (f0.*f2).*x1/((f1-f0).*(f1-f2)) + (f0.*f1).*x2/((f2-f0).*(f2-f1));
    calls = 3;
end

function [anew, bnew, calls] = oneStepBisection(func, a, b)
    p = (a + b)/2;
    vals = func([a, p]);
    if vals(1)*vals(2) > 0
        anew = p;
        bnew = b;
    else
        anew = a;
        bnew = p;
    end
    calls = 2;
end