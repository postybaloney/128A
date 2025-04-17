f1 = @(x) sign(x)*abs(x)^(1/3);
Int1 = struct('a', -1 ,'b', 8);
params = struct('root_tol', 10^(-7), 'func_tol', 10^(-7));
[root, info] = modifiedzeroin3037680414(f1, Int1, params)

% f2 = @(x) x^4 -2*x^3-4*x^2+4*x+4; 
% Int2 = struct('a',  0, 'b', 2);
% [root, info] = modifiedzeroin3037680414(f2, Int2, params)