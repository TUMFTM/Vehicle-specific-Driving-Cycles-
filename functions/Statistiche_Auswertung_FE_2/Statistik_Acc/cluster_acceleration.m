function [ acc_low, acc_mid, acc_high,acc_global_komp,acc_global,acc_low_ex,acc_mid_ex,acc_high_ex] = cluster_acceleration(acc_global_komp,acc_global)
%Clustering der Beschleunigungssequenzen in verschiedenen
%Geschwindigkeitsbereiche (Stadt, Land , Autobahn)
%Input: Global Matrix mit Beschleunigungssequenen
%Dritte Spalte: Startgeschwindigkeit der Sequenz
%Vierte Spalte: Endgeschwindigkeit der Sequenz

%Verschiedene Bereiche definieren
%acc_low
vel_acc_low_h=65; %Grenze für Geschwindigkeitsbereich Low
n_acc_low=0;
%acc_middle
vel_acc_middle_h=110; %Grenze für Geschwindigkeitsbereich Mid
n_acc_middle=0;
%acc_high
n_acc_high=0;


n=length(acc_global_komp);

%Anzahl der einzelnen Sequenzen bestimmen
for i=1:n
   if(acc_global_komp(i,3)<=vel_acc_low_h && acc_global_komp(i,4)<=vel_acc_low_h)
       n_acc_low=n_acc_low+1;
       acc_global_komp(i,1)=1; %Stadt=1
   elseif(acc_global_komp(i,4)<=vel_acc_middle_h)
       n_acc_middle=n_acc_middle+1;
       acc_global_komp(i,1)=2; %Land=2;
   else
       n_acc_high=n_acc_high+1;
       acc_global_komp(i,1)=3; %Autobahn=3;
   end
end

%Zustand in globaler Matrix speichern
m=length(acc_global);
step=1;
j=1;
acc_global=[acc_global zeros(m,1)];
while j<=m
    t_seq=acc_global_komp(step,2);
    acc_global(j:j+t_seq-1,5)=acc_global_komp(step,1);
    step=step+1;
    j=j+t_seq;
end
    

%Initialisierne der Matrizen
acc_low=zeros(n_acc_low,6);
acc_mid=zeros(n_acc_middle,6);
acc_high=zeros(n_acc_high,6);

%Befüllen der Matrizen
low=1;
middle=1;
high=1;
for i=1:n
    if(acc_global_komp(i,3)<=vel_acc_low_h && acc_global_komp(i,4)<=vel_acc_low_h)
        acc_low(low,:)=acc_global_komp(i,:);
       low=low+1;
   elseif(acc_global_komp(i,4)<=vel_acc_middle_h)
       acc_mid(middle,:)=acc_global_komp(i,:);
       middle=middle+1;
    else
       acc_high(high,:)=acc_global_komp(i,:);
       high=high+1;
   end
end

%Nicht komprimierte Matrix aufbauen
length_low=sum(acc_low(:,2));
length_mid=sum(acc_mid(:,2));
length_high=sum(acc_high(:,2));
acc_low_ex=zeros(length_low,5);
acc_mid_ex=zeros(length_mid,5);
acc_high_ex=zeros(length_high,5);
low=1;
middle=1;
high=1;
for i=1:m
    if(acc_global(i,5)==1)
       acc_low_ex(low,:)=acc_global(i,:);
       low=low+1;
   elseif(acc_global(i,5)==2)
       acc_mid_ex(middle,:)=acc_global(i,:);
       middle=middle+1;
    else
       acc_high_ex(high,:)=acc_global(i,:);
       high=high+1;
   end
end

end

