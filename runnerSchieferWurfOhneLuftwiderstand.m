% clear all; close all;
figure('Name','Schiefer Wurf ohne Luftwiderstand','NumberTitle','off')
plot(1) 

g = 9.81;

v = 83.3333;

alpha = 29/180*pi;

x=(1:1000);

[y, landing] = ohneLuftwiderstand(x, alpha, v , g, 0);
plot(x(1:landing),y(1:landing));
%title('ohne Luftwiderstand');