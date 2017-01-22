% %workspace cleaning
% close all;
% clear all;

%fenster oeffnen
figure('Name','Read from Excel','NumberTitle','off')

%%ausserhalb der Schleife, da sonst das Fenster immer wieder in den
%%Vordergrund rueckt.
%while 1 %Zur Praesentation vor der Klasse

%get data from excel
input =  xlsread('data.xlsx');

%konstanten definieren
aufloesung = 0.04; %in Sekunden
dauer = 360; %in sekunden
cw = 0.055; %Cw-Wert (Annahme)
rho = 1.293; %Luftdichte
A = 0.0062; %Stirnfl?che
m = 0.0773; %masse in kg
g = 9.81; %Schwerkraft

%vorbereiten t interval
t = 0:aufloesung:dauer;
%definieren der Arrays
data(dauer/aufloesung+1,size(input,1)*2)=0;
datao(dauer/aufloesung+1,size(input,1)*2)=0;

%daten berechnen fuer alle Inputs fuer mit und ohne Luftwiderstand
for di = 1:size(input,1)
[data(:,-1+(2*di)), data(:,(2*di))] = mitLuftwiderstand(t,input(di,2),input(di,1),cw,rho,A,m,g);
end
for di = 1:size(input,1)
[datao(:,-1+(2*di)), datao(:,(2*di))] = mitLuftwiderstand(t,input(di,2),input(di,1),0.0000001,rho,A,m,g);
end

%Berechnen von xMax und yMax
xmax = 0; ymax = 0;
for i=2:2:(size(input,1)*2)
    txmax = data(find(data(:,i)<0,1),i-1);
    tymax = max(data(:,i));
    if xmax < txmax
        xmax = txmax;
    end
    if ymax < tymax
        ymax = tymax;
    end
end
for i=2:2:(size(input,1)*2)
    txmax = datao(find(datao(:,i)<0,1),i-1);
    tymax = max(datao(:,i));
    if xmax < txmax
        xmax = txmax;
    end
    if ymax < tymax
        ymax = tymax;
    end
end
%dieser Abschnitt wird ben?tigt, falls die Zeit nicht ausreicht um die
%Landung zu erreichen.
if xmax == 0
   txmax = max(max(data(:,(1:2:size(data,2)))));
   xmax = max(max(datao(:,(1:2:size(datao,2)))));
   if txmax > xmax
       xmax = txmax;
   end
end

%Raum hinzufuegen, dass Linie nicht direkt an Rand klebt.
xmax = xmax + 2; ymax = ymax + 2;

%Subplot in Fesnter erstellen.
subplot(2,1,2);
%Definieren von i, wird zum iterieren benoetigt.
i=1;

%Iteration starten fuer jedes t
for ti = t
    take = tic; %Zeitnehmen um die Flugbahn echt darzustellen
    itstheend = true; %wird benoetigt, um zu schauen ob alle Nousse den Boden beruehrt haben.
    subplot(2,1,1); %Plot auswaehlen
    for di = 1:size(input,1)
        plot(datao(1:i,-1+(2*di)), datao(1:i,(2*di))); %Daten auslesen fuer jeden Nouss
        if itstheend  %schauen ob alle den Boden beruehrt haben.
            itstheend = datao(i,(2*di))<0;
        end 
        hold on; %hold on um weitere Flugbahnen in den gleichen Plot zu zeichnen.
    end
    title('ohne Luftwiderstand'); %Titel muss immer wieder neu gesetzt werden.
    ylim([0 ymax]); %Limiten des Plots festlegen
    xlim([0 xmax]); %Limiten des Plots festlegen
    
    hold off; %Hold off vorbereiten, fuer die naechste Runde.
    
    
    %das gleiche fuer den Plot mit Luftwiderstand
    subplot(2,1,2);
    for di = 1:size(input,1)
        plot(data(1:i,-1+(2*di)), data(1:i,(2*di)));
        title('mit Luftwiderstand');
        if itstheend 
            itstheend = data(i,(2*di))<0;
        end 
        hold on;
    end
    ylim([0 ymax]); 
    xlim([0 xmax]);
    
    hold off;
    
    
    %falls alle Nousse den Boden beruehrt haben, wird hier der Vorgang
    %beendet.
    if itstheend
        break
    end
    
    %i vorbereiten fuer die naechste Iteration
    i=i+1;
    
    %Pause einlegen, so sieht es aus, als wuerde der Nouss live fliegen.
    pause(aufloesung-toc(take));
end

%pause(2); %Zur Praesentation vor der Klasse
%end  %Zur Praesentation vor der Klasse