f = @(x)(2.*x.*cos(2.*x) - (x+1).^2);
Int = struct('a',-4,'b', -2);
params = struct('root_tol', 10^(-7), 'func_tol', 10^(-7));
[root, info] = modifiedzeroin3037680414(f, Int, params);