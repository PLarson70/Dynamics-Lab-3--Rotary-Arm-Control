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

zeta = ((Kg^2*Km^2)+(K_dtheta*Kg*Km))./(2*sqrt(K_ptheta*Kg*Km*J*Rm));

step_amp = 0.5;

t1 = 0:0.01:5;
u1 = step_amp * ones(size(t1));
max_overshoot = exp((-zeta.*pi) ./ sqrt(1-zeta.^2));
%const1 = step_amp * ones(size(t1));
t2 = 5.01:0.01:10;
u2 = -1*step_amp * ones(size(t2));
%const2 = -1*step_amp * ones(size(t2));
t = [t1, t2];
u = [u1, u2];
%const = [const1, const2];
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
    %y2 = lsim(sysTF, u2, t2);
    

    subplot(3, 2, i);
    hold on;
    plot(t, y);
    plot(t, u, LineWidth=1);

    yline(0.475,':k');
    yline(0.525,':k');
    xline(1,'--r')
    yline(-0.475,':k');
    yline(-0.525,':k');
    xline(6,'--r')

    yline(0.4,'--k');
    yline(0.6,'--k');
    yline(-0.4,'--k');
    yline(-0.6,'--k');


    title(['K1 = ', num2str(K_ptheta(i)), ', K3 = ', num2str(K_dtheta(i))]);
    xlabel('Time');
    ylabel('Output');
    legend('Arm', 'Amp','5% Settling Time','Max Overshoot');
    grid on;
end

K_ptheta = 15;
K_dtheta = 1;


    n1 = (K_ptheta*Kg*Km) / (J*Rm);
    d2 = 1;
    d1 = (Kg^2*Km^2) / (J*Rm) + (K_dtheta*Kg*Km) / (J*Rm);
    d0 = (K_ptheta*Kg*Km) / (J*Rm);

    num = n1;
    den = [d2 d1 d0];
    sysTF = tf(num, den);
    
    y = lsim(sysTF, u, t);

    figure();
    hold on;
    plot(t,y);
   plot(t, u, LineWidth=1);

    yline(0.475,':k');
    yline(0.525,':k');
    xline(1,'--r')
    yline(-0.475,':k');
    yline(-0.525,':k');
    xline(6,'--r')

    yline(0.4,'--k');
    yline(0.6,'--k');
    yline(-0.4,'--k');
    yline(-0.6,'--k');


    title(['K1 = ', num2str(K_ptheta), ', K3 = ', num2str(K_dtheta)]);
    xlabel('Time');
    ylabel('Output');
    legend('Arm', 'Amp','5% Settling Time','Max Overshoot');
    grid on;
