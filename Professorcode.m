x`clear all
close all
clc

%% Définition du procédé (the plant)
p = tf('p');
G = 1 / ( p*(0.1*p+1)*(p+1) );

figure;
nyquist(G);
hold all
grid on


%% Définition de la non-linéarité (saturation)
M  = 15;
xM = 1;
x1 = 0:100;    % professor used integers 0 → 100

N1 = zeros(size(x1));

k = 1;
for k = 1:length(x1)

    if x1(k) <= xM
        N1(k) = M / xM;   
    else
        % full describing function formula
        N1(k) = (2*M/(xM*pi)) * ( asin(xM/x1(k)) + (xM/x1(k))*sqrt(1 - (xM/x1(k))^2) );
    end
end


%% Plot N(x1)
figure;
plot(x1, N1, 'o-')
xlabel('x_1')
ylabel('N_1')


%% Plot critical locus -1/N(x1) with Nyquist
figure;
plot(real(-1./N1), imag(-1./N1), 'ro-')   
hold all
nyquist(G)
hold all 
grid on

