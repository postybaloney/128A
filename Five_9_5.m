% Constants
k1 = 3;
k2 = 0.002;
k3 = 0.0006;
k4 = 0.5;

% Time span
tspan = [0 5];

% Initial populations
x0 = [1000; 500]; % [prey, predator]

% Define the system of ODEs
lotka_volterra = @(t, x) [...
    k1*x(1) - k2*x(1)*x(2);              % dx1/dt
    k3*x(1)*x(2) - k4*x(2)               % dx2/dt
];

% Solve using ode45
[t, x] = ode45(lotka_volterra, tspan, x0);

% Plotting
figure;
plot(t, x(:,1), 'b-', 'LineWidth', 2); hold on;
plot(t, x(:,2), 'r--', 'LineWidth', 2);
legend('Prey Population (x_1)', 'Predator Population (x_2)');
xlabel('Time t');
ylabel('Population');
title('Lotka-Volterra Predator-Prey Dynamics');
grid on;

% Optional: phase portrait
figure;
plot(x(:,1), x(:,2), 'm-', 'LineWidth', 2);
xlabel('Prey Population (x_1)');
ylabel('Predator Population (x_2)');
title('Phase Plane Trajectory');
grid on;