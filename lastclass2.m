clear; clc; close all;

%% ----- Linear system L(p) -----
tau1 = 0.1;
tau2 = 1;
K    = 1;

s = tf('p');
L = K / ( s*(1 + tau1*s)*(1 + tau2*s) );

%% ----- Nyquist of L(jw), zoomed like in the slide -----
wmin = 0.01;      % start frequency
wmax = 100;       % end frequency
figure;
nyquist(L,{wmin,wmax});  % only this freq range
hold on; grid on;
title('Nyquist of L(j\omega) with critical locus');

% Zoom the axes so it looks like the slide
axis([-2 0.2 -3 3]);     % [xmin xmax ymin ymax]

%% ----- Describing function and critical locus -1/N(x1) -----
% Choose M and xM so that -1/k is around -0.5 (like the slide)
M  = 2;          % saturation level
xM = 1;          % amplitude at which saturation begins
k  = M/xM;       % small-signal gain

x1 = linspace(0.1,10,500);
N  = zeros(size(x1));

for i = 1:length(x1)
    if x1(i) <= xM
        N(i) = k;                % no saturation
    else
        N(i) = 2*M/(pi*x1(i));   % saturated region
    end
end

crit = -1./N;    % critical points

% Plot critical locus on same Nyquist plane
plot(crit, zeros(size(crit)), 'r', 'LineWidth', 2);
legend('Nyquist L(j\omega)', 'Critical locus -1/N(x_1)', ...
       'Location','best');
