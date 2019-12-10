clear all

theta = 0:2*pi/100:2*pi;
r=1+2.*exp(-4*cos(theta).^2)+0.5.*exp(4*cos(theta).*sin(theta));
x=cos(theta).*r;
y=sin(theta).*r;
xplus=cos(theta).*(r+0.25);
yplus=sin(theta).*(r+0.25);
xmoins=cos(theta).*(r-0.25);
ymoins=sin(theta).*(r-0.25);
plot(xplus,yplus,'r',xmoins,ymoins,'r',x,y,'b');
hold on

%% construction de la matrice X
N=100;
T=60;
delta = 0.01;
deltaT = 60/N;
Vl = sqrt((diff(x)./deltaT).^2+(diff(y)./deltaT).^2);
Vtheta = diff(theta)./deltaT;
M = [-1/delta 1/delta;1/2 1/2];
V = inv(M)*[Vtheta;Vl];
%Vg et Vd
Vg = [0,V(1,:)];
Vd = [0,V(2,:)];
Ug = [V(1,:),0];
Ud = [V(2,:),T];
%matrice X
X = [theta;x;y;Vg;Vd;Ug;Ud];

%% contraintes
lb = [-inf*ones(1,N+1); -inf*ones(1,N+1); -inf*ones(1,N+1); zeros(1,N+1) ; zeros(1,N+1) ; -8*ones(1,N+1) ; -8*ones(1,N+1)];
ub = [+inf*ones(1,N+1); +inf*ones(1,N+1); +inf*ones(1,N+1) ; 8*ones(1,N+1) ; 8*ones(1,N+1) ; 8*ones(1,N+1) ; 8*ones(1,N+1)];
A=[];
b=[];
Aeq=[];
beq=[];

obj = @(X)(X(end,end));
[sol,fval,exitflag,output] = fmincon(obj,X,A,b,Aeq,beq,lb,ub,@cont);
plot(sol(2,:),sol(3,:),'--k');
fprintf("%i", sol(end,end));
