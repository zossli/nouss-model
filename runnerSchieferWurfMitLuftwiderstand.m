% clear all; close all;
figure('Name','Schiefer Wurf mit Luftwiderstand','NumberTitle','off')
plot(2) 

aufloesung = 0.04; %in Sekunden
dauer = 15; %in sekunden
cw = 0.055; %Cw-Wert (Annahme)
rho = 1.293; %Luftdichte
A = 0.0062; %Stirnfl?che
m = 0.0773; %masse in kg
g = 9.81; %Schwerkraft

v = 83.3333;

alpha = 29;

t = 0:aufloesung:dauer;

[x, y] = mitLuftwiderstand(t, alpha, v, cw,rho,A,m,g);
plot(x,y);
ylim([0 inf]);
%title('mit Luftwiderstand');
