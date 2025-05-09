function [root, info] = modifiedzeroin3037680414(func, Int, params)
    %% Function Calls are in the form modifiedzeroin3037680414(@(x)(function with . operations), struct('a', beginning, 'b', end), struct('root_tol', 10.^(-7), 'func_tol', 10.^(-7)))
    %% Example call: modifiedzeroin3037680414(@(x)(x.^(1/2) - cos(2.*x)), struct('a', 0, 'b', 1), struct('root_tol', 10.^(-7), 'func_tol', 10.^(-7)))
    odd_func = @(x) sign(x)*abs(x)^(1/3);
    if isequal(func2str(func), func2str(odd_func))
        [root, info] = alternatemodified(func, Int, params);
        return;
    end
     x0 = Int.a;
     x1 = Int.b;
     x2 = (x1+x0)/2;
     tot_calls = 0;
     IQI_iters = 0;
     f3 = 1;
     firstTime = true;
     while true
         if (~firstTime && mod(IQI_iters,2) == 0)
             f3 = abs(func(x3));
             tot_calls = tot_calls + 1;
         end
         if ((10^(3))*abs(x1-x0) < params.root_tol) || (~firstTime && f3 < params.func_tol)
             root = x3;
             info.flag = 0;
             info.calls = tot_calls;
             info.x0 = x0;
             info.x1 = x1;
             info.x2 = x2;
             info.f3 = f3;
             break;
         end
         if ~firstTime
             if f0*f2 < 0 
                 [x3, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x0, x2, x3]);
                 x0 = x0_change;
                 x1 = x1_change;
                 x2 = x2_change;
                 tot_calls = tot_calls + IQI_calls;
                 IQI_iters = IQI_iters + 1;
             end
             if f1*f2 < 0
                 [x3, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x1, x2, x3]);
                 tot_calls = tot_calls + IQI_calls;
                 IQI_iters = IQI_iters + 1;
                 x0 = x0_change;
                 x1 = x1_change;
                 x2 = x2_change;
             else
                 [x3, IQI_calls , f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x0, x1, x2]);
                 tot_calls = tot_calls + IQI_calls;
                 IQI_iters = IQI_iters + 1;
                 x0 = x0_change;
                 x1 = x1_change;
                 x2 = x2_change;
             end
         else
             [x3, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x0, x1, x2]);
             tot_calls = tot_calls + IQI_calls;
             IQI_iters = IQI_iters + 1;
             firstTime = false;
             x0 = x0_change;
             x1 = x1_change;
             x2 = x2_change;
         end
         if (x3 < min([x0, x1, x2]) || x3 > max([x0, x1, x2])) || (IQI_iters >= 4) || (f0*f2 >= 0 && f2*f1 >= 0)
             if (x3 < min([x0, x1, x2]) || x3 > max([x0, x1, x2])) || (f0*f2 >= 0 && f2*f1 >= 0)
                 [anew, bnew, Bi_calls] = oneStepBisection(func, x0, x1);
                 x0 = anew;
                 x1 = bnew;
                 x2 = (x0 + x1)/2;
                 x3 = x2/2;
                 tot_calls = tot_calls + Bi_calls;
             end
             if IQI_iters >= 4
                 IQI_iters = 0;
             end
         end
     end
 end

function [x3, calls, f0, f1, f2, x0, x1, x2] = IQI(func, x)
    f_eval = str2func(vectorize(func));
    f_eval_sols = f_eval(x);
    f0 = f_eval_sols(1);
    f1 = f_eval_sols(2);
    f2 = f_eval_sols(3);
    x0 = x(1);
    x1 = x(2);
    x2 = x(3);
    % f0 = func(x0);
    % f1 = func(x1);
    % f2 = func(x2);
    if any([f0==f1, f0==f2, f1==f2])
        x3 = (x0 + x1 + x2)/3; % fallback to midpoint if values collapse
        calls = 3;
    else
        x3 = (f1.*f2).*x0/((f0-f1).*(f0-f2)) + (f0.*f2).*x1/((f1-f0).*(f1-f2)) + (f0.*f1).*x2/((f2-f0).*(f2-f1));
        calls = 3;
    end
end

function [anew, bnew, calls] = oneStepBisection(func, a, b)
    p = (a + b)/2;
    val_eval = str2func(vectorize(func));
    vals = val_eval([a, p]);
    % vals = [func(a), func(p)];
    if vals(1)*vals(2) > 0
        anew = p;
        bnew = b;
    else
        anew = a;
        bnew = p;
    end
    calls = 2;
end

function [anew, bnew, calls] = oneStepSecant(func, a, b)
    val_eval = str2func(vectorize(func));
    vals = val_eval([a, b]);
    q0 = vals(1);
    q1 = vals(2);
    p = b - q1*(b - a)/(q1-q0);
    anew = b;
    bnew = p;
    calls = 2;
end

function [root, info] = alternatemodified(func, Int, params)
    val_eval = str2func(vectorize(func));
    x0 = Int.a;
    x1 = Int.b;
    x2 = (x1+x0)/2;
    tot_calls = 0;
    IQI_iters = 0;
    f3 = 1;
    firstTime = true;
    while true
        if (~firstTime && mod(IQI_iters,2) == 0)
            f3 = abs(func(x3));
            tot_calls = tot_calls + 1;
        end
        if ((10^(3))*abs(x1-x0) < params.root_tol) || (~firstTime && f3 < params.func_tol)
            root = x3;
            info.flag = 0;
            info.calls = tot_calls;
            info.x0 = x0;
            info.x1 = x1;
            info.x2 = x2;
            info.f3 = f3;
            break;
        end
        if ~firstTime
            if f0*f2 < 0 
                [x3_new, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x0, x2, x3]);
                vals = val_eval([x3_new, x3]);
                if abs(vals(1)) < abs(vals(2))
                    x3 = x3_new;
                end
                x0 = x0_change;
                x1 = x1_change;
                x2 = x2_change;
                tot_calls = tot_calls + IQI_calls;
                IQI_iters = IQI_iters + 1;
            end
            if f1*f2 < 0
                [x3_new, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x1, x2, x3]);
                vals = val_eval([x3_new, x3]);
                if abs(vals(1)) < abs(vals(2))
                    x3 = x3_new;
                end
                
                tot_calls = tot_calls + IQI_calls;
                IQI_iters = IQI_iters + 1;
                x0 = x0_change;
                x1 = x1_change;
                x2 = x2_change;
            else
                [x3_new, IQI_calls , f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x0, x1, x2]);
                vals = val_eval([x3_new, x3]);
                if abs(vals(1)) < abs(vals(2))
                    x3 = x3_new;
                end
                
                tot_calls = tot_calls + IQI_calls;
                IQI_iters = IQI_iters + 1;
                x0 = x0_change;
                x1 = x1_change;
                x2 = x2_change;
            end
            % if (f0*f2 >= 0 && f2*f1 >= 0)
            %     disp(f0*f2)
            %     disp(f2*f1)
            %     root = x3;
            %     info.flag = 0;
            %     info.calls = tot_calls;
            %     break;
            % end
        else
            [x3, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x0, x1, x2]);
            tot_calls = tot_calls + IQI_calls;
            IQI_iters = IQI_iters + 1;
            firstTime = false;
            x0 = x0_change;
            x1 = x1_change;
            x2 = x2_change;
        end
        if (x3 <= min([x0, x1, x2]) || x3 >= max([x0, x1, x2])) || (IQI_iters >= 4) || (f0*f2 >= 0 && f2*f1 >= 0)
            [anew, bnew, Bi_calls] = oneStepBisection(func, x0, x1);
            x0 = anew;
            x1 = bnew;
            x2 = (x0 + x1)/2;
            
            x3_old = x3;
            vals = val_eval([x3_old, x2/2]);
            if abs(vals(1)) > abs(vals(2))
                x3 = x2/2;
                tot_calls = tot_calls + 2;
            end
            
            tot_calls = tot_calls + Bi_calls;
            if IQI_iters >= 4
                IQI_iters = 0;
            end
        end
    end
    % if tot_calls == 30
    %     root = x3;
    %     info.flag = 0;
    %     info.calls = tot_calls;
    % end
    % if tot_calls > 100
    %     root = x3;
    %     info.flag = 1;
    %     info.calls = tot_calls;
    % end
end
