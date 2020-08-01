function [ pen_low, pen_lowmid, pen_middle, pen_midhigh, pen_high,vel_avg_low,vel_avg_lowmid,vel_avg_middle,vel_avg_midhigh] = cluster_pendeln(pen_global,vel_pen_cluster)
%Clustering der Pendelsequenzen in verschiedenen
%Geschwindigkeitsbereiche (Stadt, Land , Autobahn)

%Input: Global Matrix mit Pendelsequenzen
%Dritte Spalte: Startgeschwindigkeit der Sequenz
%Vierte Spalte: Durchschnittsgeschwindigkeit der Sequenz

%Verschiedene Bereiche definieren
%pen_low
vel_avg_low=vel_pen_cluster(1,1);
n_pen_low=0;
%pen_lowmid
vel_avg_lowmid=vel_pen_cluster(1,2);
n_pen_lowmid=0;
%pen_middle
vel_avg_middle=vel_pen_cluster(1,3);
n_pen_middle=0;
%pen_middlehigh
vel_avg_midhigh=vel_pen_cluster(1,4);
n_pen_midhigh=0;
%pen_high
n_pen_high=0;


n=length(pen_global);

%Anzahl der einzelnen Sequenzen bestimmen
for i=1:n
   if(pen_global(i,4) <= vel_avg_low)
       n_pen_low=n_pen_low+1;
   elseif(pen_global(i,4)<=vel_avg_lowmid)
       n_pen_lowmid=n_pen_lowmid+1;
   elseif(pen_global(i,4)<=vel_avg_middle)
       n_pen_middle=n_pen_middle+1;
   elseif(pen_global(i,4)<=vel_avg_midhigh)
       n_pen_midhigh=n_pen_midhigh+1;
   else
       n_pen_high=n_pen_high+1;
   end
end

%Initialisierne der Matrizen
pen_low=zeros(n_pen_low,6);
pen_lowmid=zeros(n_pen_lowmid,6);
pen_middle=zeros(n_pen_middle,6);
pen_midhigh=zeros(n_pen_midhigh,6);
pen_high=zeros(n_pen_high,6);

%Befüllen der Matrizen
low=1;
lowmid=1;
middle=1;
midhigh=1;
high=1;
for i=1:n
    if(pen_global(i,4) <= vel_avg_low )
       pen_low(low,:)=pen_global(i,:);
       low=low+1;
    elseif(pen_global(i,4) <= vel_avg_lowmid )
       pen_lowmid(lowmid,:)=pen_global(i,:);
       lowmid=lowmid+1;
    elseif(pen_global(i,4)<=vel_avg_middle)
       pen_middle(middle,:)=pen_global(i,:);
       middle=middle+1;
    elseif(pen_global(i,4)<=vel_avg_midhigh)
       pen_midhigh(midhigh,:)=pen_global(i,:);
       midhigh=midhigh+1;
    else
       pen_high(high,:)=pen_global(i,:);
       high=high+1;
   end
end

%Plotten
% figure;
% plot(pen_low(:,4), pen_low(:,2), 'r*');
% hold on
% plot(pen_middle(:,4), pen_middle(:,2), 'bo');
% plot(pen_lowmid(:,4), pen_lowmid(:,2), 'cx');
% plot(pen_midhigh(:,4), pen_midhigh(:,2), 'k^');
% plot(pen_high(:,4), pen_high(:,2), 'gd');
% xlabel 'durchschnittliche Fahrgeschwindigkeit in kmh';
% ylabel 'Pendeldauer';
% title 'Geschwindigkeitsklassen';

end