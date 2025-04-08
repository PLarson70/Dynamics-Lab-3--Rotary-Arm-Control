clc;
clear all;
close all;

%% Variable
% BASE
Kg = 33.3; % total gear ratio
Km = 0.0401; % motor constant (Nm/amp)
Rm = 19.2; % armature resistance (ohms)
K_ptheta = [10, 20, 5, 10, 10, 10];
K_dtheta = [0, 0, 0, 1, -1, -0.5];

% RIGID ARM
J_hub = 0.0005; % base inertia (Kgm^2)
J_extra = 0.2*0.2794^2; % extra mass (Kgm^2)
J_load = 0.0015; % load inertia of bar (Kgm^2)
J = J_hub + J_load + J_extra; % total inertia (Kgm^2)

step_amp = 0.5;

t = 0:0.01:10;
u = step_amp * ones(size(t));

%% Equations, Closed Loop System and Step Response
figure;
for i = 1:length(K_ptheta)
    n1 = (K_ptheta(i)*Kg*Km) / (J*Rm);
    d2 = 1;
    d1 = (Kg^2*Km^2) / (J*Rm) + (K_dtheta(i)*Kg*Km) / (J*Rm);
    d0 = (K_ptheta(i)*Kg*Km) / (J*Rm);
    
    num = n1;
    den = [d2 d1 d0];
    sysTF = tf(num, den);
    
    y = lsim(sysTF, u, t);

    subplot(3, 2, i);
    plot(t, y);
    title(['K1 = ', num2str(K_ptheta(i)), ', K3 = ', num2str(K_dtheta(i))]);
    xlabel('Time');
    ylabel('Output');
    grid on;
end
