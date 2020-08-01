function [ dec_low, dec_middle, dec_high,dec_global_komp,dec_global,dec_low_ex,dec_mid_ex,dec_high_ex ] = cluster_decceleration(dec_global_komp,dec_global)
%Clustering der Bremssequenzen in verschiedenen
%Geschwindigkeitsbereiche (Stadt, Land , Autobahn)

%Input: Global Matrix mit Bremssequenen
%Dritte Spalte: Startgeschwindigkeit der Sequenz
%Vierte Spalte: Maximale Bremsung der Sequenz

%Verschiedene Bereiche definieren
%acc_low
vel_acc_low_h=65; %Grenze für Geschwindigkeitsbereich Low
n_acc_low=0;
%acc_middle
vel_acc_middle_h=100; %Grenze für Geschwindigkeitsbereich Mid
n_acc_middle=0;
%acc_high
n_acc_high=0;


n=length(dec_global_komp);

%Anzahl der einzelnen Sequenzen bestimmen
for i=1:n
   if(dec_global_komp(i,3)<=vel_acc_low_h)
       n_acc_low=n_acc_low+1;
       dec_global_komp(i,1)=1; %Stadt=1
   elseif(dec_global_komp(i,3)<=vel_acc_middle_h)
       n_acc_middle=n_acc_middle+1;
       dec_global_komp(i,1)=2; %land=2
   else
       n_acc_high=n_acc_high+1;
       dec_global_komp(i,1)=3; %Autobahn=3;
   end
end

%Zustand in globaler Matrix speichern
m=length(dec_global);
step=1;
j=1;
dec_global=[dec_global zeros(m,1)];
while j<=m
    t_seq=dec_global_komp(step,2);
    dec_global(j:j+t_seq-1,5)=dec_global_komp(step,1);
    step=step+1;
    j=j+t_seq;
end

%Initialisierne der Matrizen
dec_low=zeros(n_acc_low,6);
dec_middle=zeros(n_acc_middle,6);
dec_high=zeros(n_acc_high,6);

%Befüllen der Matrizen
low=1;
middle=1;
high=1;
for i=1:n
    if(dec_global_komp(i,3)<=vel_acc_low_h)
        dec_low(low,:)=dec_global_komp(i,:);
       low=low+1;
   elseif(dec_global_komp(i,3)<=vel_acc_middle_h)
       dec_middle(middle,:)=dec_global_komp(i,:);
       middle=middle+1;
    else
       dec_high(high,:)=dec_global_komp(i,:);
       high=high+1;
   end
end

%Nicht komprimierte Matrix aufbauen
length_low=sum(dec_low(:,2));
length_mid=sum(dec_middle(:,2));
length_high=sum(dec_high(:,2));
dec_low_ex=zeros(length_low,5);
dec_mid_ex=zeros(length_mid,5);
dec_high_ex=zeros(length_high,5);
low=1;
middle=1;
high=1;
for i=1:m
    if(dec_global(i,5)==1)
       dec_low_ex(low,:)=dec_global(i,:);
       low=low+1;
   elseif(dec_global(i,5)==2)
       dec_mid_ex(middle,:)=dec_global(i,:);
       middle=middle+1;
    else
       dec_high_ex(high,:)=dec_global(i,:);
       high=high+1;
   end
end

end

