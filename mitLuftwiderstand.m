function [x, y] =  mitLuftwiderstand(t, winkel, geschwindigkeit, cw,rho,A,m,g)



abschlaggeschwindigkeit = geschwindigkeit*3.6; %in kmh

alpha = winkel;
alpha = alpha/180*pi;

x0=abschlaggeschwindigkeit/3.6*cos(alpha);
y0=abschlaggeschwindigkeit/3.6*sin(alpha);

k = 1/2 * rho * cw * A;

v = sqrt(m/k*g);

tu = (v/g) * atan(y0/v);

x = zeros(1,length(t));
y = zeros(1,length(t));

for i = 1:length(t)
  
    x(i) = (v^2/g)*(log(1+(x0*g*t(i))/(v^2)));
    
if t(i) < tu 
    y(i) = (v^2/g)*(log(cos(g*(tu-t(i))/v))-log(cos((g*tu)/v)));
else
    y(i) = (v^2/g)*(-((g*(t(i)-tu))/v)-log(((1+exp((-2*g*(t(i)-tu))/v))/2)*cos((g*tu)/v)));
end
end 

% %Geschwindigkeit bei der Landung
% neg=find(y<0);
% y2 = y(neg(1)-1);
% y1 = y(neg(1)-2);
% 
% x2 = x(neg(1)-1);
% x1 = x(neg(1)-2);
% 
% t2 = t(neg(1)-1);
% t1 = t(neg(1)-2);
% 
% s = sqrt((x2-x1)^2+(y2-y1)^2);
% dt = t2-t1;
% 
% vlanding = (s/dt)*3.6;
% landing = x2;