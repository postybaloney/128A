% Time interval and step size
h = 0.2;
t = 0:h:2;

% Initialize arrays
n = length(t);
u1 = zeros(1, n);
u2 = zeros(1, n);

% Initial conditions
u1(1) = -3;
u2(1) = 5;

% Actual solutions for comparison
u1_exact = @(t) -3*exp(t) + t.^2;
u2_exact = @(t) 4*exp(t) - 3*t + 1;

% Define the system of ODEs
f1 = @(t, u1, u2) (1/9)*u1 - (2/3)*u2 - (1/9)*t.^2 + (2/3);
f2 = @(t, u2) u2 + 3*t - 4;

% Runge-Kutta method
for i = 1:n-1
    k1_1 = f1(t(i), u1(i), u2(i));
    k1_2 = f2(t(i), u2(i));
    
    k2_1 = f1(t(i)+h/2, u1(i)+h/2*k1_1, u2(i)+h/2*k1_2);
    k2_2 = f2(t(i)+h/2, u2(i)+h/2*k1_2);
    
    k3_1 = f1(t(i)+h/2, u1(i)+h/2*k2_1, u2(i)+h/2*k2_2);
    k3_2 = f2(t(i)+h/2, u2(i)+h/2*k2_2);
    
    k4_1 = f1(t(i)+h, u1(i)+h*k3_1, u2(i)+h*k3_2);
    k4_2 = f2(t(i)+h, u2(i)+h*k3_2);
    
    u1(i+1) = u1(i) + (h/6)*(k1_1 + 2*k2_1 + 2*k3_1 + k4_1);
    u2(i+1) = u2(i) + (h/6)*(k1_2 + 2*k2_2 + 2*k3_2 + k4_2);
end

% Exact solutions
u1_true = u1_exact(t);
u2_true = u2_exact(t);

% Display results
fprintf('   t      u1 (RK4)     u1 (exact)     Error u1     u2 (RK4)     u2 (exact)     Error u2\n');
fprintf('------------------------------------------------------------------------------------------\n');
for i = 1:n
    fprintf('%5.2f   %10.5f   %10.5f   %10.5f   %10.5f   %10.5f   %10.5f\n', ...
        t(i), u1(i), u1_true(i), abs(u1(i) - u1_true(i)), ...
        u2(i), u2_true(i), abs(u2(i) - u2_true(i)));
end