
clc; clear all; close all;

%% Variable
% BASE
Kg = 33.3; % total gear ratio
Km = 0.0401; % motor constant (Nm/amp)
Rm = 19.2; % armature resistance (ohms)
K_ptheta = [10,20,5,10,10,10];
K_dtheta = [0,0,0,1,-1,-.5];

% RIGID ARM
J_hub = 0.0005; % base inertia (Kgm^2)
J_extra = 0.2 * 0.2794^2; % extra mass (Kgm^2)
J_load = 0.0015; % load inertia of bar (Kgm^2)
J = J_hub + J_load + J_extra; % total inertia (Kgm^2)


%% Equations
for i = 1:length(K_ptheta)
    
n1(i) = (K_ptheta(i) .* Kg .* Km) ./ (J.*Rm);
d2(i) = 1;
d1(i) = (Kg^2.* Km^2) ./ (J.*Rm) + (K_dtheta(i).*Kg.*Km) ./ (J.*Rm);
d0(i) = (K_ptheta(i) .* Kg .* Km) ./ (J.*Rm);
end

%% Closed Loop System
num = n1;
den = [d2 d1 d0];
sysTF = tf(num,den);


%% Step Response
[t,x] = step(sysTF);
figure;
hold on;
plot (x,t);
grid on;
