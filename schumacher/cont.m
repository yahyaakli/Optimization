function [c,ceq] = cont(X)
N = size(X,2);
a=-0.5;
b=0.5;
delta = 0.01;
T = X(end,end);
umin=-8;
x0=X(2,1:N); y0=X(3,1:N);
vd_0=X(5,1:N); vg_0=X(4,1:N);
ud_0= X(7,1:N); ug_0=X(6,1:N);
vmax=8;
coef=[0.8;0.5;0.1];
g=9.81;
deltaT = X(end,end)/N;

%% contraintes egalite
F1 = (1/delta).*(X(5,1:N-1)-X(4,1:N-1));
F2 = 0.5.*cos(X(1,1:N-1)).*(X(5,1:N-1)+X(4,1:N-1));
F3 = 0.5.*sin(X(1,1:N-1)).*(X(5,1:N-1)+X(4,1:N-1));
F4 = a.*X(4,1:N-1)+b.*X(6,1:N-1);
F5 = a.*X(5,1:N-1)+b.*X(7,1:N-1);

ceq = X(:,2:N)-X(:,1:N-1)-(T/N).*[F1;F2;F3;F4;F5;zeros(1,100);zeros(1,100)];


%% c : contraintes inégalités

    %CONTRAINTES LIEES A LA PISTE 
%     ci1 = (y0 - yp(X(2,1:N)) -omega/2);         %y-yp-omega/2<0
%     ci2 = (yp(X(2,1:N)) - y0 -omega/2);%yp-y-omega/2<0
%     ci1 = (y0 - X(2,1:N) -omega/2);
%     ci2 = (X(2,1:N) - y0 -omega/2);
%     ci3 = (x0 - 3*pi);                              %x-3pi<0 
%     ci4 = (-x0);                                    %x>0 --> -x<0 
    ci1= rp(atan2(X(3,1:N),X(2,1:N)))-sqrt(X(2,1:N).^2+X(3,1:N).^2)-0.25;
    ci2= - rp(atan2(X(3,1:N),X(2,1:N)))+sqrt(X(2,1:N).^2+X(3,1:N).^2)-0.25;
    %CONTRAINTES LIEES A L'ADHERENCE 
    ci3 = ((vg_0-vd_0)/delta).*((vg_0+vd_0)/2)-coef(1)*g ;   % (vd-vg/delta)*(vg+vd/2) - c*g<0

    %CONTRAINTES LIEES AUX VITESSES
    ci4 = (vg_0 - vmax);                            %vg<vmax
    ci5 = (-vg_0);                                  %vg>0 
    ci6 = (vd_0 - vmax);
    ci7 = (-vd_0);
    
    %CONTRAINTES LIEES AUX COMMANDES
    ci8 = (ug_0 - vmax);                            %ug<umax
    ci9= (-ug_0-umin);                              %ug>umin 
    ci10= (ud_0 - vmax);
    ci11= (-ud_0-umin);
    
    c=[ci1;ci2;ci3;ci4;ci5;ci6;ci7;ci8;ci9;ci10;ci11];
end

