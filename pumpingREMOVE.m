 
clear; close all; clc;

p = tf('p');
G = 10/(p*(1+0.16*p));       
M = pi;  xM = 1;             
x1 = linspace(0.01,10,400);

%% Describing function 
N = (M/xM)*ones(size(x1));
idx = x1 > xM;
N(idx) = (2*M/(pi*xM)) .* ...
         ( asin(xM./x1(idx)) + ...
         (xM./x1(idx)).*sqrt(1-(xM./x1(idx)).^2) );

%% Nichols plot + critical locus
figure; nichols(G); grid on; hold on;
plot(real(-1./N), imag(-1./N),'r','LineWidth',1.5);
legend('G(j\omega)','-1/N(x_1)');

%% Hysteresis h = 0.06 (qualitative)
h = 0.06;
Nh = (4*M./(pi*x1)) .* ...
     ( sqrt(1-(h./x1).^2) - 1i*(h./x1) );
Nh(x1<=h) = NaN;

figure; nichols(G); grid on; hold on;
plot(real(-1./Nh), imag(-1./Nh),'m','LineWidth',1.5);
legend('G(j\omega)','-1/N_h(x_1)');

%% Delay G'(p) = G(p)e^{-0.02p}
Gd = G*exp(-0.02*p);
figure; nichols(Gd); grid on; hold on;
plot(real(-1./N), imag(-1./N),'r','LineWidth',1.5);
legend('G_d(j\omega)','-1/N(x_1)');

%% Phase-lead compensation
a = 5; tau = 0.2;
C = (1 + a*tau*p)/(1 + (tau/a)*p);

figure; nichols(C*G); grid on; hold on;
plot(real(-1./N), imag(-1./N),'r','LineWidth',1.5);
legend('C(p)G(j\omega)','-1/N(x_1)');
