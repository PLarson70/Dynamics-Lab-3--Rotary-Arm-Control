clc;
clear all;
close all;

data = readtable('group0406-Test1', 'FileType', 'text', 'Delimiter', '\t');

Time = data{:,1};
Hubangle = data{:,2};

Time_sec = (Time - 11006571) / 1000;

figure;
plot(Time_sec, Hubangle, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Angular Position (rad)');
title('Angular Position vs Time');
grid on;
