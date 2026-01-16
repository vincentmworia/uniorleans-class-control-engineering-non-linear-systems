%% EX1_MINIMAL.m
clear; clc;

M=0.5; xM=0.5;                 % sat limits
A=[1 9 27 27];                  % (p+3)^3
B={300,[40 -80],[10 -40 40]};
nm={'a','b','c'};

w=logspace(-3,3,4000);          % freq grid
dt=1e-3; t=(0:dt:25)';          % sim time

for i=1:3
    G=tf(B{i},A);

    fprintf('\n=== Case %s ===\n',nm{i});
    fprintf('poles: '); disp(pole(G).');
    fprintf('zeros: '); disp(zero(G).');

    % Nyquist negative-real crossing (approx): imag ~ 0 and Re < 0
    Gj=squeeze(freqresp(G,w)); im=imag(Gj); re=real(Gj);
    k=find(im(1:end-1).*im(2:end)<=0 & re(1:end-1)<0, 1);

    if isempty(k)
        fprintf('No Re<0 imag=0 crossing (w>0) => no DF oscillation\n');
        continue
    end

    w0=w(k); R=real(freqresp(G,w0));  % R<0
    fprintf('Nyquist crossing: w0≈%.4g rad/s, Re(G(jw0))≈%.4g\n',w0,R);

    % Describing function N(A) for odd saturation (slope 1, limit M, xM)
    N=@(Aamp) (Aamp<=xM).*1 + (Aamp>xM).*((2*M./(pi*Aamp)).*(asin(xM./Aamp)+(xM./Aamp).*sqrt(1-(xM./Aamp).^2)));
    Atheo=fzero(@(Aamp) R + 1./N(Aamp), 1);     % solve Re(G) = -1/N(A)
    fprintf('DF prediction: A(input to sat)≈%.4g\n',Atheo);

    % Nonlinear sim: e=-y, u=sat(e), y=G*u
    [y,~]=sim_sat(ss(G),t,M);
    [Ameas,wmeas]=meas(t,y);
    fprintf('Sim (y): A≈%.4g, w≈%.4g rad/s\n',Ameas,wmeas);
end
 
function y=sat(u,M), y=min(max(u,-M),M); end

function [y,u]=sim_sat(sys,t,M)
A=sys.A; B=sys.B; C=sys.C; D=sys.D;
dt=t(2)-t(1); x=0.2*ones(size(A,1),1);
y=zeros(size(t)); u=zeros(size(t));
for k=1:numel(t)
    y(k)=C*x + D*u(max(k-1,1));
    u(k)=sat(-y(k),M);
    x=x + dt*(A*x + B*u(k));
end
end

function [Aamp,w]=meas(t,y)
idx=round(2*numel(t)/3):numel(t);
yy=y(idx)-mean(y(idx));
Aamp=0.5*(max(yy)-min(yy));
zc=find(yy(1:end-1).*yy(2:end)<=0);
if numel(zc)<3, w=NaN; return; end
T2=mean(diff(t(idx(zc)))); w=pi/T2;
end
