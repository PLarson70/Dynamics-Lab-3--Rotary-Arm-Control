clc;
clear all;
close all;


data = readtable('group0406-Test1', 'FileType', 'text', 'Delimiter', '\t');

Time = data{:,1};
HubangleRAW = data{:,2};

for i= 4000:length(HubangleRAW)

    if HubangleRAW(i) == 0 && HubangleRAW(i+1)>HubangleRAW(i)
    startpoint=i;
    break
    end

end

Hubangle = HubangleRAW(startpoint:end);

Time_sec1 = (Time - startpoint) / 1000;
Time_sec = Time_sec1(startpoint:end) - Time_sec1(startpoint);

figure;
plot(Time_sec, Hubangle, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Angular Position (rad)');
title('Angular Position vs Time');
grid on;