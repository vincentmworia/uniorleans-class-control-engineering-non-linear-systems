clear; clc; close all;

%% Parameters
tau1 = 0.1;
tau2 = 1;
K = 1;

% Transfer function L(p)
s = tf('p');
L = K / ( s * (1 + tau1*s) * (1 + tau2*s) );

%% Nyquist Curve of L(jw)
figure;
nyquist(L)
title('Nyquist plot of L(j\omega)')
grid on;

%% Critical locus -1/N(x1)
M  = 1; 
xM = 1; 
x1 = linspace(0.1, 10, 200);   % now we go well beyond xM

N = zeros(size(x1));

for i = 1:length(x1)
    if x1(i) <= xM
        N(i) = M / xM;
    else
        ratio = xM / x1(i);
        N(i) = (2*M / (pi*x1(i))) * (asin(ratio) + ratio * sqrt(1 - ratio^2));
    end
end

crit = -1./N;

hold on;
plot(crit, zeros(size(crit)), 'r', 'LineWidth', 2);
legend('Nyquist L(j\omega)', 'Critical locus -1/N(x_1)')