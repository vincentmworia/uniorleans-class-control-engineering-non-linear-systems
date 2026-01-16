Stability
clear; close all; clc;
s = tf('s');

L  = 5 / ((1 + s/2) * (1 + s/10));      
k1 = 0.2;                              
k2 = 2.0;                               
w  = logspace(-3, 3, 3000);            

% Off-center circle 
a_off = 2.0;     
b_off = 1.0;   
r_off = 1.5;    

Ljw = squeeze(freqresp(L, w));
 




%% 1) POPOV   
k = k2 - k1;
if k <= 0, error('Need k2 > k1'); end

L1   = L / (1 + k1*L);
L1jw = squeeze(freqresp(L1, w));
 
% Re{ (1 + j*w*q) * L1(jw) + 1/k } >= 0 for all w>=0
qGrid = linspace(0, 50, 1001);   % exam: scan a reasonable range
qFound = NaN;

for q = qGrid
    pop = real( (1 + 1j*w*q).*L1jw + (1/k) );
    if all(pop >= 0)
        qFound = q;
        break;
    end
end

fprintf('\n[POPOV]\n');
if isnan(qFound)
    disp('Result: INCONCLUSIVE on this q-range (no q found).');
else
    fprintf('Result: PASS (found q = %.4g)\n', qFound);
    figure; semilogx(w, real((1 + 1j*w*qFound).*L1jw + (1/k))); grid on;
    yline(0,'k--'); xlabel('\omega'); ylabel('Popov margin');
    title(sprintf('Popov margin (q = %.4g): must stay >= 0', qFound));
end

%% 2) CIRCLE CRITERION (sector [k1,k2]) 
fprintf('\n[CIRCLE]\n');

figure; nyquist(L, w); grid on; hold on;
title('Nyquist(L) with Circle forbidden region');

if k1 == 0
    % Special case often treated as half-plane condition
    xline(-1/k2,'k--');
    disp('k1=0 special case (often shown as a half-plane test).');
    disp('Result: Use your course’s specific [0,k2] circle/half-plane form.');
else
    a = -1/k1; b = -1/k2;
    c = (a+b)/2;              % center (real)
    r = abs(a-b)/2;           % radius

    th = linspace(0,2*pi,600);
    C = c + r*exp(1j*th);
    plot(real(C), imag(C), 'k--', 'LineWidth', 1.2);
    plot([a b],[0 0],'ko','MarkerFaceColor','k');

    inside = abs(Ljw - c) < r;
    if any(inside)
        disp('Result: FAIL (Nyquist enters forbidden disk) => no stability guarantee.');
    else
        disp('Result: PASS (Nyquist stays outside forbidden disk) => stability certified.');
    end
end
hold off;

%% 3) OFF-CENTER (OFF-AXIS) CIRCLE 
fprintf('\n[OFF-CENTER CIRCLE]\n');

figure; nyquist(L, w); grid on; hold on;
title('Nyquist(L) with Off-center forbidden circles');

c1 = (-a_off) + 1j*b_off;
c2 = (-a_off) - 1j*b_off;

th = linspace(0,2*pi,600);
plot(real(c1 + r_off*exp(1j*th)), imag(c1 + r_off*exp(1j*th)), 'k--', 'LineWidth', 1.2);
plot(real(c2 + r_off*exp(1j*th)), imag(c2 + r_off*exp(1j*th)), 'k--', 'LineWidth', 1.2);
plot(real([c1 c2]), imag([c1 c2]), 'ko', 'MarkerFaceColor', 'k');

insideOff = (abs(Ljw - c1) < r_off) | (abs(Ljw - c2) < r_off);
if any(insideOff)
    disp('Result: FAIL (Nyquist enters forbidden off-center circle) => no stability guarantee.');
else
    disp('Result: PASS (Nyquist stays outside both circles) => stability certified.');
end
hold off;
