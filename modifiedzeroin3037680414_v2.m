function [root, info] = modifiedzeroin3037680414_v2(func, Int, params)
    %% Function Calls are in the form modifiedzeroin3037680414(@(x)(function with . operations), struct('a', beginning, 'b', end), struct('root_tol', 10.^(-7), 'func_tol', 10.^(-7)))
    %% Example call: modifiedzeroin3037680414(@(x)(x.^(1/2) - cos(2.*x)), struct('a', 0, 'b', 1), struct('root_tol', 10.^(-7), 'func_tol', 10.^(-7)))
    x0 = Int.a;
    x1 = Int.b;
    x2 = (x1+x0)/2;
    tot_calls = 0;
    IQI_iters = 0;
    f3 = 1;
    firstTime = true;
    while true && tot_calls < 30
        if (~firstTime && mod(IQI_iters,2) == 0)
            f3 = abs(func(x3));
            tot_calls = tot_calls + 1;
        end
        if abs((x2-x0)/x0) < params.root_tol || (~firstTime && f3 < params.func_tol)
            tot_calls = tot_calls + 1;
            root = x3;
            info.flag = 0;
            info.calls = tot_calls;
            break;
        end
        if ~firstTime
            % disp(f0*f2)
            % disp(f1*f2)
            if f0*f2 < 0 
                [x3, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x0, x2, x3]);
                x0 = x0_change;
                x1 = x1_change;
                x2 = x2_change;
                tot_calls = tot_calls + IQI_calls;
                IQI_iters = IQI_iters + 1;
            end
            if f2*f1 < 0
                [x3, IQI_calls, f0, f1, f2, x0_change, x1_change, x2_change] = IQI(func, [x1, x2, x3]);
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
        if (x3 < x0 || x3 > x1) || (IQI_iters >= 4) || (f0*f2 >= 0 && f2*f1 >= 0)
            if (f0*f2 >= 0)
                [anew, bnew, Bi_calls] = oneStepSecant(func, x0, x2);
                tot_calls = tot_calls + Bi_calls;
                x0 = anew;
                x1 = bnew;
                x2 = (x0+x1)/2;
            elseif (f2*f1 >= 0)
                [anew, bnew, Bi_calls] = oneStepSecant(func, x1, x2);
                tot_calls = tot_calls + Bi_calls;
                x0 = anew;
                x1 = bnew;
                x2 = (x0+x1)/2;
            else
                [anew, bnew, Bi_calls] = oneStepSecant(func, x0, x1);
                tot_calls = tot_calls + Bi_calls;
                x0 = anew;
                x1 = bnew;
                x2 = (x1+x0)/2;
            end
            if IQI_iters >= 4
                IQI_iters = 0;
            end
        end
    end
    if tot_calls == 30
        root = x3;
        info.flag = 0;
        info.calls = tot_calls;
    end
    if tot_calls > 30
        root = x3;
        info.flag = 1;
        info.calls = tot_calls;
    end
end

function [x3, calls, f0, f1, f2, x0, x1, x2] = IQI(func, x)
    % f_eval = str2func(vectorize(func));
    % f_eval_sols = f_eval(x);
    % f0 = f_eval_sols(1);
    % f1 = f_eval_sols(2);
    % f2 = f_eval_sols(3);
    x0 = x(1);
    x1 = x(2);
    x2 = x(3);
    f0 = func(x0);
    f1 = func(x1);
    f2 = func(x2);
    x3 = (f1.*f2).*x0/((f0-f1).*(f0-f2)) + (f0.*f2).*x1/((f1-f0).*(f1-f2)) + (f0.*f1).*x2/((f2-f0).*(f2-f1));
    calls = 3;
end

% function [anew, bnew, calls] = oneStepBisection(func, a, b)
%     p = (a + b)/2;
%     val_eval = str2func(vectorize(func));
%     vals = val_eval([a, p]);
%     % vals = [func(a), func(p)];
%     if vals(1)*vals(2) > 0
%         anew = p;
%         bnew = b;
%     else
%         anew = a;
%         bnew = p;
%     end
%     calls = 2;
% end

function [anew, bnew, calls] = oneStepSecant(func, a, b)
    % val_eval = str2func(vectorize(func));
    % vals = val_eval([a, b]);
    % q0 = vals(1);
    % q1 = vals(2);
    q0 = func(a);
    q1 = func(b);
    p = b - q1*(b - a)/(q1-q0);
    anew = b;
    bnew = p;
    calls = 2;
end