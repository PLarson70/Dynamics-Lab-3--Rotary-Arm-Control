clc;
clear all;
close all;

data = readtable('group0406-Test1', 'FileType', 'text', 'Delimiter', '\t');

Time = data{:,1};
HubangleRAW = data{:,2};

% for loop to find where the data is at zero position (to match the sim)
for i= 4000:length(HubangleRAW) % start at 4000 b/c data has it where you start going down and i couldnt figure out a way to add increaseing the the if statement so i just roughly hard coded it

    if HubangleRAW(i) == 0 && HubangleRAW(i+1)>HubangleRAW(i)
    startpoint=i;
    break
    end

end

% making the data set start at the found zero point
Hubangle = HubangleRAW(startpoint:end);

% time based on how long the data is after starting at zero
Time_sec1 = (Time - startpoint) / 1000;
Time_sec = Time_sec1(startpoint:end) - Time_sec1(startpoint);

Kg = 33.3; % total gear ratio
Km = 0.0401; % motor constant (Nm/amp)
Rm = 19.2; % armature resistance (ohms)
K_ptheta = 15;
K_dtheta = 1;

J_hub = 0.0005; % base inertia (Kgm^2)
J_extra = 0.2*0.2794^2; % extra mass (Kgm^2)
J_load = 0.0015; % load inertia of bar (Kgm^2)
J = J_hub + J_load + J_extra; % total inertia (Kgm^2)

step_amp = 0.5;
t1 = 0:0.01:5;
u1 = step_amp * ones(size(t1));
t2 = 5.01:0.01:10;
u2 = -1 * step_amp * ones(size(t2));
t = [t1, t2];
u = [u1, u2];

n1 = (K_ptheta*Kg*Km) / (J*Rm);
d2 = 1;
d1 = (Kg^2*Km^2) / (J*Rm) + (K_dtheta*Kg*Km) / (J*Rm);
d0 = (K_ptheta*Kg*Km) / (J*Rm);
num = n1;
den = [d2 d1 d0];
sysTF = tf(num, den);

y = lsim(sysTF, u, t);

figure;
hold on;
plot(t, y, 'LineWidth', 1.5, 'DisplayName', 'Model Output (Simulated)');
plot(t, u, '--', 'DisplayName', 'Input (Amp)');
plot(Time_sec, Hubangle, 'LineWidth', 1.5, 'DisplayName', 'Experimental Data');

yline(0.475,':k','DisplayName','5% Bounds');
yline(0.525,':k','HandleVisibility','off');
xline(1,'--r','DisplayName','Step Change');
yline(-0.475,':k','HandleVisibility','off');
yline(-0.525,':k','HandleVisibility','off');
xline(6,'--r','HandleVisibility','off');
yline(0.4,'--k','HandleVisibility','off');
yline(0.6,'--k','HandleVisibility','off');
yline(-0.4,'--k','HandleVisibility','off');
yline(-0.6,'--k','HandleVisibility','off');

xlabel('Time (s)');
ylabel('Angular Position (rad)');
title(['Comparison: Experimental vs. Model Output (K1 = ', num2str(K_ptheta), ', K3 = ', num2str(K_dtheta), ')']);
legend('show');
grid on;
hold off;