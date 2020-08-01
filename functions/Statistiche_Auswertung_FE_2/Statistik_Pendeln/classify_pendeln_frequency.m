function [ output_pen,class_1,class_2,class_3,class_4,class_5 ] = classify_pendeln_frequency(pen_class)
%Klassenbildung für Pendelsequenzen mit vorgegebener Häufigkeitsverteilung
%feste Häufigekeitsverteilung für Zustandsverfeinerung
rel_frequency=[0.4; 0.25; 0.15; 0.10; 0.10]; %kann variiert werden


[n,m]=size(pen_class);
%Minimum und Maximum der Pendeldauer bestimmen
min_class_t=min(pen_class(:,2));
max_class_t=max(pen_class(:,2));
%Klassen intialisieren
member_class=zeros(5,2);
class=zeros(n,5);


%Anzahl der Schritte;
number_steps=max_class_t-min_class_t;
i=0;
z=1;
%Mit erster Klasse starten
index=1;
while i <= number_steps
    for k=1:n
       if(pen_class(k,2)==(min_class_t+i))
           %Zähler in dieser Klasse erhöhen
           member_class(index,1)=member_class(index,1)+1;
           class(z,:)=pen_class(k,2:6);
           z=z+1;
       end
    end
    %Prüfen ob Häufigkeit erreicht ist
    member_class(index,2)=member_class(index,1)/n;
    if(member_class(index,2)>=rel_frequency(index,1) || (index==5 && sum(member_class(:,2))==1))
        %Mit nächster Klasse weiter
        index=index+1;
    end
    %Zähler erhöhen
    i=i+1;
end

%Klassenminimum und Klassenmaximum bestimmen
class_1=class(1:member_class(1,1),:);
class_2=class(member_class(1,1)+1:(member_class(1,1)+member_class(2,1)),:);
p=member_class(1,1)+member_class(2,1)+1;
class_3=class(p:p+member_class(3,1)-1,:);
p=member_class(1,1)+member_class(2,1)+member_class(3,1)+1;
class_4=class(p:p+member_class(4,1)-1,:);
p=member_class(1,1)+member_class(2,1)+member_class(3,1)+member_class(4,1)+1;
class_5=class(p:p+member_class(5,1)-1,:);
%Ausgabe in Matrixform
output_pen=zeros(5,4);
output_pen=member_class(:,1:2);
output_pen(1,3)=min(class_1(:,1));
output_pen(1,4)=max(class_1(:,1));
output_pen(2,3)=min(class_2(:,1));
output_pen(2,4)=max(class_2(:,1));
output_pen(3,3)=min(class_3(:,1));
output_pen(3,4)=max(class_3(:,1));
output_pen(4,3)=min(class_4(:,1));
output_pen(4,4)=max(class_4(:,1));
[a,b]=size(class_5);
if(a>0)
    output_pen(5,3)=min(class_5(:,1));
    output_pen(5,4)=max(class_5(:,1));
end

%Balkendiagramm plotten
% figure
% x=1:5;
% bar(x,output_pen(:,2),'k');
% xlabel 'Klasse';
% ylabel 'relative Haeufigkeit'

end