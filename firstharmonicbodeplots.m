clc; clear; close all; 

w = 5;                     
b_values = [3 30];          
G = cell(1,2);             

figure; hold on; grid on;

for i = 1:2
    b = b_values(i);

    num = b^2;
    den = [1 2*b b^2];

    G{i} = tf(num, den);  
    bode(G{i});    

    [mag, phase] = bode(G{i}, w);

    mag = mag(:);
    phase = phase(:);

    fprintf('\nFor b = %d:\n', b);
    fprintf('  Gain at w=5 (linear): %g\n', mag);
    fprintf('  Gain at w=5 (dB): %.2f dB\n', 20*log10(mag));
    fprintf('  Phase at w=5 (deg): %.2f°\n', phase);
end

legend('b = 3','b = 30');
title('Bode Plots for b = 3 and b = 30');
 