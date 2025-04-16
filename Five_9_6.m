% Time span
tspan = [0 4];

% Initial populations
x0 = [10000; 10000]; % [x1, x2]

% Define the system of ODEs
competing_species = @(t, x) [...
    x(1) * (4 - 0.0003 * x(1) - 0.0004 * x(2)); 
    x(2) * (2 - 0.0002 * x(1) - 0.0001 * x(2))
];

% Solve the system
[t, x] = ode45(competing_species, tspan, x0);

% Plotting populations over time
figure;
plot(t, x(:,1), 'b-', 'LineWidth', 2); hold on;
plot(t, x(:,2), 'r--', 'LineWidth', 2);
legend('Species x_1', 'Species x_2');
xlabel('Time t');
ylabel('Population');
title('Two Competing Species Model');
grid on;