% Step size and interval
h = 0.2;
t = 1:h:3;
n = length(t);

% Initialize arrays
y1 = zeros(1, n); % y(t)
y2 = zeros(1, n); % y'(t)

% Initial conditions
y1(1) = 4;
y2(1) = 3;

% Define the system of ODEs
f1 = @(t, y1, y2) y2;
f2 = @(t, y1, y2) (-3*t - t*y2 + 4*y1) / t^2;

% Runge-Kutta 4th Order Method
for i = 1:n-1
    k1_1 = f1(t(i), y1(i), y2(i));
    k1_2 = f2(t(i), y1(i), y2(i));
    
    k2_1 = f1(t(i)+h/2, y1(i)+h/2*k1_1, y2(i)+h/2*k1_2);
    k2_2 = f2(t(i)+h/2, y1(i)+h/2*k1_1, y2(i)+h/2*k1_2);
    
    k3_1 = f1(t(i)+h/2, y1(i)+h/2*k2_1, y2(i)+h/2*k2_2);
    k3_2 = f2(t(i)+h/2, y1(i)+h/2*k2_1, y2(i)+h/2*k2_2);
    
    k4_1 = f1(t(i)+h, y1(i)+h*k3_1, y2(i)+h*k3_2);
    k4_2 = f2(t(i)+h, y1(i)+h*k3_1, y2(i)+h*k3_2);
    
    y1(i+1) = y1(i) + (h/6)*(k1_1 + 2*k2_1 + 2*k3_1 + k4_1);
    y2(i+1) = y2(i) + (h/6)*(k1_2 + 2*k2_2 + 2*k3_2 + k4_2);
end

% Actual solution
y_exact = @(t) 2*t.^2 + t + 1./t.^2;
y_true = y_exact(t);

% Display results
fprintf('   t      y (RK4)     y (exact)     Error\n');
fprintf('-------------------------------------------\n');
for i = 1:n
    fprintf('%5.2f   %10.5f   %10.5f   %10.5f\n', ...
        t(i), y1(i), y_true(i), abs(y1(i) - y_true(i)));
end